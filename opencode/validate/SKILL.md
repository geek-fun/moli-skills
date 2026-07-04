---
name: moli-cn-copyright-validate
description: 验证已生成的软著申请材料是否合规。用户完成 review 和截图补充后，运行此命令检查 33 条规范，发现问题自动修复。适用于已生成过软著材料的项目。
license: Apache-2.0
compatibility: opencode
metadata:
  author: WENTSEN (Kunming) Technology Co., Ltd.
  version: "1.0.0"
  category: intellectual-property
---

# moli-cn-copyright-validate

验证 `docs/moli/copyright-*/` 下已生成的软著材料是否合规。

## 工作流

1. **定位** — 找到最新版本的正式资料目录（`docs/moli/copyright-latest`）
2. **validate** — 运行 `validate_materials.py` 检查 33 条规则
3. **report** — 向用户呈现结果（✅/❌/⚠️）
4. **fix** — 自动修复可修复的问题（页眉、页码等）
5. **re-validate** — 修复后重新验证，直到全部通过
6. **done** — 告知用户"全部通过 ✅ 可以提交了"

## 验证内容

| 类别 | 规则数 |
|---|---|
| 源代码校验 | 10 条 |
| 操作手册校验 | 7 条 |
| 申请表校验 | 7 条 |
| 跨文档一致性 | 4 条 |
| 2026 新政 | 5 条 |

完整规则见 `instructions/moli-cn-copyright.md` 附录。

## Agent 执行

```bash
# 自动定位最新版本目录
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-latest/正式资料 \
  --software-name "<自动检测>" \
  --version "<自动检测>"
```

根据结果逐条修复，重新验证，直到全部通过。
