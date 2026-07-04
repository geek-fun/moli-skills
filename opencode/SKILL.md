---
name: moli-cn-copyright
description: 生成中国软件著作权（软著）全套申请材料。用户提到"软著"、"软件著作权"、"版权登记"、"软著申请"、"生成软著材料"时使用。AI 自动分析项目代码，生成程序鉴别材料（源代码PDF）和文档鉴别材料（用户操作手册）。
license: Apache-2.0
compatibility: opencode
metadata:
  author: WENTSEN (Kunming) Technology Co., Ltd.
  version: "1.0.0"
  category: intellectual-property
---

# moli-cn-copyright

完整工作流见 `instructions/moli-cn-copyright.md`，读取后按步骤执行。

## 工作流

1. **setup check** — 检查 Python、python-docx、字体
2. **source scan** — 读取项目源码，理解页面和功能
3. **ask unclear** — 向用户确认名称/版本/截图方式（最多 3 项）
4. **generate** — 生成源代码 PDF + 操作手册 DOCX → `docs/moli/copyright-v1/`
5. **review** — 告知用户查看结果，补充截图，修改内容
6. **validate** — 用户说"帮我验证"，Agent 自动运行检查并报告结果
7. **fix** — Agent 根据验证结果自动修复，重复直到全部通过

## 安装

```bash
git clone --depth=1 https://github.com/geek-fun/moli-skills.git ~/.moli-skills
pip install python-docx
export MOLI_SKILLS_DIR="$HOME/.moli-skills"
```

## 更新

告知用户：`/moli-update` 检查并升级到最新版本。Agent 也可在加载技能时自动检查版本。
