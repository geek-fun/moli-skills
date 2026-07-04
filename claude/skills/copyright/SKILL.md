---
name: moli-cn-copyright
description: 生成中国软件著作权（软著）全套申请材料。用户提到"软著"、"软件著作权"、"版权登记"、"软著申请"时使用。AI 自动分析项目代码，生成程序鉴别材料（源代码PDF）和文档鉴别材料（用户操作手册）。
version: 1.0.0
---

# moli-cn-copyright

完整工作流见 `instructions/moli-cn-copyright.md`，读取后按步骤执行。

## 工作流

1. **setup check** — 检查 Python、python-docx、字体
2. **source scan** — 读取项目源码，理解页面和功能
3. **ask unclear** — 向用户确认名称/版本/截图方式（最多 3 项）
4. **generate** — 生成源代码 PDF + 操作手册 DOCX → `docs/moli/copyright-v1/`
5. **review** — 告知用户查看结果，补充截图，修改内容
6. **validate** — 用户运行 `validate_materials.py` 检查合规
7. **fix** — 根据验证结果修复问题，重复直到全部通过

## Validate

```bash
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-v1/正式资料 \
  --software-name "xxx软件" \
  --version V1.0
```

## 安装

```bash
git clone --depth=1 https://github.com/geek-fun/moli-skills.git ~/.moli-skills
pip install python-docx
export MOLI_SKILLS_DIR="$HOME/.moli-skills"
```

## Validate

```bash
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-v1/正式资料 \
  --software-name "xxx软件" \
  --version V1.0
```

根据 ❌ 错误修复后重新验证，直到全部通过方可提交。
