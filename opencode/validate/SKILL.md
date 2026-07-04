---
name: moli-cn-copyright-validate
description: 验证已生成的软著申请材料是否合规。检查 28 条规则，自动修复可修复的问题（标点、页眉、格式等），直到全部通过。适用于已生成过软著材料的项目。
license: Apache-2.0
compatibility: opencode
metadata:
  author: WENTSEN (Kunming) Technology Co., Ltd.
  version: "2.0.0"
  category: intellectual-property
---

# moli-cn-copyright-validate

验证 `docs/moli/copyright-*/` 下已生成的软著材料是否合规。

## 工作流

1. **定位** — 找到最新版本的正式资料目录（`docs/moli/copyright-latest`）
2. **validate** — 运行 `validate_materials.py` 检查 28 条规则
3. **auto-fix** — 如果发现标点符号混用问题，自动运行 `--fix-punctuation` 修复
4. **re-validate** — 修复后重新验证
5. **report** — 向用户呈现最终结果（✅/❌/⚠️），截图未添加等需用户手动处理的问题单独标注
6. **done** — 全部通过时告知用户"可以提交"

## Agent 执行

```bash
# 首次验证
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-latest/正式资料 \
  --software-name "<自动检测>" \
  --version "<自动检测>"

# 如果 R-MA-14 标点报错，自动修复
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-latest/正式资料 \
  --fix-punctuation

# 修复后重新验证
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-latest/正式资料 \
  --software-name "<自动检测>" \
  --version "<自动检测>"
```

重复验证→修复→验证流程，直到所有可自动修复的问题消除。截图、内容补充等需用户手动处理的事项在报告中单独说明。
