---
name: moli-cn-copyright
description: 生成中国软件著作权（软著）全套申请材料。AI 自动分析项目代码、生成程序鉴别材料（源代码PDF）和文档鉴别材料（用户操作手册）。
---

# moli-cn-copyright

OpenCode 入口。完整工作流说明见 `instructions/moli-cn-copyright.md`。

## 快速开始

```typescript
task({
  load_skills: ["moli-cn-copyright"],
  prompt: "为当前项目生成软著申请材料"
})
```

## 工作流

读取 `instructions/moli-cn-copyright.md` 并按以下步骤执行：

1. **setup check** — 检查 Python、python-docx、字体
2. **source scan** — 读取项目源码，理解页面和功能
3. **ask unclear** — 向用户确认名称/版本/截图方式
4. **generate** — 生成源代码 PDF + 操作手册 DOCX → `docs/moli/copyright-v1/`

## 安装

未安装时，先执行：

```bash
git clone --depth=1 https://github.com/geek-fun/moli-skills.git ~/.moli-skills
pip install python-docx
export MOLI_SKILLS_DIR="$HOME/.moli-skills"
```

## 辅助脚本

所有脚本位于 `$MOLI_SKILLS_DIR/moli-cn-copyright/scripts/`，需要时自动调用。
