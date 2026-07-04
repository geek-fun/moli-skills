---
name: moli-cn-copyright
description: 生成中国软件著作权（软著）全套申请材料。AI 自动分析项目代码，生成程序鉴别材料（源代码PDF）和文档鉴别材料（用户操作手册）。
compatibility: >
  需要 Python 3.10+ 和 python-docx。可选 .NET SDK 8.0+ 增强 DOCX 校验。
---

# moli-cn-copyright

完整工作流见 `instructions/moli-cn-copyright.md`，请读取并按步骤执行。

## 快速开始

```
/software-copyright-materials 为当前项目生成软著申请材料
```

## 工作流

读取 `instructions/moli-cn-copyright.md` 并按以下步骤执行：

1. **setup check** — 检查 Python、python-docx、字体
2. **source scan** — 读取项目源码，理解页面和功能
3. **ask unclear** — 向用户确认名称/版本/截图方式
4. **generate** — 生成源代码 PDF + 操作手册 DOCX → `docs/moli/copyright-v1/`
5. **validate** — 运行 `scripts/validate_materials.py` 检查合规

## 安装

```bash
git clone --depth=1 https://github.com/geek-fun/moli-skills.git ~/.moli-skills
pip install python-docx
export MOLI_SKILLS_DIR="$HOME/.moli-skills"
```

## 加载插件

```bash
claude --plugin /path/to/moli-skills/claude
```

或放入 `.claude/plugins/` 目录。
