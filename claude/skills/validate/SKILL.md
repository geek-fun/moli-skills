---
name: moli-cn-copyright-validate
description: 验证已生成的软著申请材料是否合规。自动检查 28 条规则，修复标点符号等可自动处理的问题。
version: 2.0.0
---

# moli-cn-copyright-validate

验证 `docs/moli/copyright-*/` 下已生成的软著材料。

## 工作流

1. 定位最新版本 → 2. 验证 → 3. 标点自动修复 → 4. 重新验证 → 5. 报告结果

## Agent 执行

```bash
# 验证
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-latest/正式资料

# 如有标点问题则修复
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-latest/正式资料 --fix-punctuation

# 重新验证
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-latest/正式资料
```
