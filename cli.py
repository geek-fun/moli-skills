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
import json
import urllib.request
import argparse
from pathlib import Path

SKILLS_DIR = Path(os.environ.get("MOLI_SKILLS_DIR", Path(__file__).resolve().parent))
VERSION = open(SKILLS_DIR / "VERSION").read().strip()
REPO = "geek-fun/moli-skills"


def cmd_validate(args: argparse.Namespace) -> int:
    """运行软著材料合规验证"""
    sys.path.insert(0, str(SKILLS_DIR / "moli-cn-copyright" / "scripts"))


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


def cmd_update(args: argparse.Namespace) -> int:
    """检查并更新 moli-skills 到最新版本"""
    return _do_update(check_only=args.check)


def _get_latest_release() -> tuple[str | None, str | None]:
    """查询最新 Release 版本号和下载地址"""
    api = f"https://api.github.com/repos/{REPO}/releases/latest"
    try:
        resp = urllib.request.urlopen(api, timeout=10)
        data = json.loads(resp.read())
        tag = data.get("tag_name")
        tarball = data.get("tarball_url")
        return tag, tarball
    except Exception as e:
        print(f"❌ 查询失败: {e}")
        return None, None


def _do_update(check_only: bool = False) -> int:
    local_version = (SKILLS_DIR / "VERSION.installed").read_text().strip() if (SKILLS_DIR / "VERSION.installed").exists() else f"v{VERSION}"
    print(f"当前版本: {local_version}")

    remote_tag, remote_url = _get_latest_release()
    if not remote_tag:
        return 1

    print(f"最新版本: {remote_tag}")

    if remote_tag == local_version:
        print("✅ 已是最新版本")
        return 0

    print(f"📦 新版本可用: {local_version} → {remote_tag}")
    if check_only:
        print("  运行 `moli update` 升级")
        return 0

    # 执行更新
    import subprocess
    import shutil

    print(f"  ℹ 下载 {remote_tag}...")
    temp_dir = SKILLS_DIR.with_name(SKILLS_DIR.name + ".tmp")
    if temp_dir.exists():
        shutil.rmtree(temp_dir)

    try:
        subprocess.run(
            ["curl", "-sL", remote_url],
            capture_output=True, check=True,
        )
        # 下载并解压
        import tarfile
        resp = urllib.request.urlopen(remote_url, timeout=30)
        with tarfile.open(fileobj=resp, mode="r:gz") as tar:
            tar.extractall(path=temp_dir)
        # 找到解压后的目录（GitHub tarball 包含一个子目录）
        extracted = list(temp_dir.iterdir())[0]
        # 替换安装目录
        shutil.rmtree(SKILLS_DIR)
        shutil.copytree(extracted, SKILLS_DIR)
        shutil.rmtree(temp_dir)
        # 更新版本记录
        (SKILLS_DIR / "VERSION.installed").write_text(remote_tag)
        print(f"✅ 已升级到 {remote_tag}")
        print("   重新打开终端或 source ~/.zshrc 使环境变量生效")
        return 0
    except Exception as e:
        print(f"❌ 升级失败: {e}")
        if temp_dir.exists():
            shutil.rmtree(temp_dir)
        return 1


def main() -> int:
    parser = argparse.ArgumentParser(
        description=f"墨吏 v{VERSION} — AI 文书技能集",
    )
    parser.add_argument("--version", action="version", version=f"moli v{VERSION}")

    sub = parser.add_subparsers(dest="command")
    sub.required = True

    # update / check-update
    update = sub.add_parser("update", help="升级到最新版本")
    update.set_defaults(func=cmd_update, check=False)

    check = sub.add_parser("check-update", help="检查是否有新版本")
    check.set_defaults(func=cmd_update, check=True)

    # copyright
    cp = sub.add_parser("copyright", help="软著申请相关命令")
    cp_sub = cp.add_subparsers(dest="action")
    cp_sub.required = True


if __name__ == "__main__":
    sys.exit(main())
