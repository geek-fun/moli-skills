---
name: moli-update
description: 检查并升级 moli-skills 到最新版本。当用户提到"升级"、"更新"、"检查更新"、"update"时使用。
license: Apache-2.0
compatibility: opencode
metadata:
  author: WENTSEN (Kunming) Technology Co., Ltd.
  version: "1.0.0"
  category: maintenance
---

# moli-cn-copyright-update

检查并升级墨吏到最新版本。

## 工作流

1. 运行 `moli check-update` 或直接查询 GitHub API 对比版本
2. 如果有新版本，告知用户并询问是否升级
3. 用户确认后运行 `moli update`
4. 升级完成后告知用户

## 检查

```bash
python3 $MOLI_SKILLS_DIR/cli.py check-update
```

## 升级

```bash
python3 $MOLI_SKILLS_DIR/cli.py update
```
