#!/usr/bin/env python3
"""
墨吏 CLI — moli 命令行工具

用法:
  moli copyright             生成软著申请材料
  moli copyright --validate  验证现有材料
  moli copyright --help      显示帮助

安装后可直接使用:
  pip install moli-skills
  moli copyright --project ./my-app
"""

import argparse
import os
import sys
from pathlib import Path

SKILLS_DIR = Path(os.environ.get("MOLI_SKILLS_DIR", Path(__file__).resolve().parent))


def cmd_copyright(args: argparse.Namespace) -> int:
    """软著申请材料生成"""
    if args.validate:
        from moli_skills.validate_materials import CopyrightValidator
        validator = CopyrightValidator(
            workdir=args.workdir or ".",
            software_name=args.software_name or "",
            version=args.version or "",
        )
        validator.run_all()
        print(validator.print_report(format="json" if args.json else "text"))
        return 0 if validator.summary()["errors"] == 0 else 1

    # 非验证模式：打印帮助信息
    print("墨吏 · 软著申请材料生成")
    print("=" * 40)
    print("在 OpenCode 中运行：")
    print('  task({ load_skills: ["moli-cn-copyright"], prompt: "..." })')
    print()
    print("或直接说：")
    print('  "用 moli-cn-copyright 生成软著材料"')
    print()
    print("独立运行：")
    print("  moli copyright --project ./my-app")
    print("  moli copyright --validate --software-name xxx --version V1.0")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="墨吏 — AI 文书技能集")
    parser.add_argument("--skill-dir", default=str(SKILLS_DIR), help=argparse.SUPPRESS)

    sub = parser.add_subparsers(dest="command")
    sub.required = True

    # copyright
    cp = sub.add_parser("copyright", help="软著申请材料生成/验证")
    cp.add_argument("--project", "-p", help="项目目录")
    cp.add_argument("--workdir", "-w", help="材料所在目录（验证模式）")
    cp.add_argument("--software-name", "-n", help="软件全称")
    cp.add_argument("--version", "-v", help="版本号")
    cp.add_argument("--validate", action="store_true", help="验证现有材料")
    cp.add_argument("--json", action="store_true", help="JSON 格式输出")
    cp.set_defaults(func=cmd_copyright)

    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
