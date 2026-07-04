---
name: moli-cn-copyright-validate
description: 验证已生成的软著申请材料是否合规。用户完成 review 和截图补充后运行，自动检查 33 条规范并修复问题。
version: 1.0.0
---

# moli-cn-copyright-validate

验证 `docs/moli/copyright-*/` 下已生成的软著材料。

## 工作流

1. **定位** — 找到 `docs/moli/copyright-latest` 指向的最新版本
2. **validate** — 运行 `validate_materials.py` 检查 33 条规则
3. **report** — 向用户呈现结果（✅/❌/⚠️）
4. **fix** — 自动修复可修复的问题
5. **re-validate** — 直到全部通过

## Agent 执行

```bash
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-latest/正式资料
```
