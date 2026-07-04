#!/usr/bin/env python3
"""
墨吏 CLI — moli 命令行工具

用法:
  moli copyright validate [options]    验证软著材料

示例:
  moli copyright validate --workdir docs/moli/copyright-latest/正式资料
  moli copyright validate --software-name "山野集-菌迹软件" --version V1.0
"""

import os
import sys
import argparse
from pathlib import Path

SKILLS_DIR = Path(os.environ.get("MOLI_SKILLS_DIR", Path(__file__).resolve().parent))
VERSION = "1.0.0"


def cmd_validate(args: argparse.Namespace) -> int:
    """运行软著材料合规验证"""
    sys.path.insert(0, str(SKILLS_DIR / "moli-cn-copyright" / "scripts"))
    try:
        from validate_materials import CopyrightValidator
    except ImportError as e:
        print(f"❌ 无法导入验证模块: {e}")
        print(f"   请确保 MOLI_SKILLS_DIR 正确指向 moli-skills 目录")
        print(f"   当前值: {SKILLS_DIR}")
        return 1

    workdir = args.workdir or (Path.cwd() / "docs" / "moli" / "copyright-latest" / "正式资料")
    if not Path(workdir).exists():
        print(f"❌ 目录不存在: {workdir}")
        print(f"   请通过 --workdir 指定材料所在目录，或先生成软著材料")
        return 1

    validator = CopyrightValidator(
        workdir=str(workdir),
        software_name=args.software_name or "",
        version=args.version or "",
    )
    validator.run_all()
    report = validator.print_report(format="json" if args.json else "text")
    print(report)

    summary = validator.summary()
    return 0 if summary["errors"] == 0 else 1


def main() -> int:
    parser = argparse.ArgumentParser(
        description=f"墨吏 v{VERSION} — AI 文书技能集",
    )
    parser.add_argument("--version", action="version", version=f"moli v{VERSION}")

    sub = parser.add_subparsers(dest="command")
    sub.required = True

    # copyright
    cp = sub.add_parser("copyright", help="软著申请相关命令")
    cp_sub = cp.add_subparsers(dest="action")
    cp_sub.required = True

    # copyright validate
    validate = cp_sub.add_parser("validate", help="验证已生成的软著材料")
    validate.add_argument("--workdir", "-w", help="材料目录（默认: docs/moli/copyright-latest/正式资料）")
    validate.add_argument("--software-name", "-n", help="软件全称")
    validate.add_argument("--version", "-v", help="版本号")
    validate.add_argument("--json", action="store_true", help="JSON 格式输出")
    validate.set_defaults(func=cmd_validate)

    args = parser.parse_args()
    return args.func(args)


if __name__ == "__main__":
    sys.exit(main())
