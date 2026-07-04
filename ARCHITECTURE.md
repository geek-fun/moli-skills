# 墨吏 Skills — 架构与命令体系

## 设计哲学

**共享指令 + 薄适配层**：核心工作流写一次，所有 agent 共享。每个 agent 只需要一个轻量入口指向共享指令。

```
instructions/           ← 纯 Markdown，任意 agent 可读
└── moli-cn-copyright.md

opencode/SKILL.md       ← 3 行 YAML + 引用 instructions/
claude/plugin.json      ← 引用 instructions/ (🔜)
cursor/rules/           ← 引用 instructions/ (🔜)
```

## 命名体系

```
moli-<地域/领域>-<功能>
```

| 命令 | 功能 | 状态 |
|---|---|---|
| `moli-cn-copyright` | 中国软著申请 | ✅ |
| `moli-cn-patent` | 中国专利申请 | 🔜 |
| `moli-write-polish` | 文章润色 | 🔜 |

## 目录结构

```
moli-skills/
│
├── instructions/           ← 📖 共享工作流（所有 agent 的真相来源）
│   └── moli-cn-copyright.md
│
├── opencode/               ← 🔧 OpenCode 适配层
│   └── SKILL.md
├── claude/                 ← 🔧 Claude Code 适配层 (🔜)
├── cursor/                 ← 🔧 Cursor/Windsurf 适配层 (🔜)
│
├── moli-cn-copyright/      ← ⚙️ 核心实现
│   ├── scripts/            ← Python 辅助脚本
│   ├── references/         ← 规范文档
│   └── vendor/             ← 第三方工具链
│
├── AGENTS.md               ← 兼容性说明
├── ARCHITECTURE.md         ← 本文件
├── cli.py                  ← CLI 入口
├── install.sh              ← 安装脚本
└── README.md               ← 项目说明
```

## 设计原则

1. **instructions/ 是唯一真相来源**——所有 agent 读同一份工作流，行为一致
2. **适配层越薄越好**——只做一件事：告诉 agent 去哪里读 instructions/
3. **脚本是工具，不是流程**——agent 自行决策，脚本只做格式化和验证
4. **最少干预**——只问 AI 无法确定的决定（名称/版本/截图）
5. **版本可追溯**——`copyright-v1/`、`copyright-v2/` + `修订历史.md`
