# Agent 兼容性

墨吏采用 **共享指令 + 平台适配层** 架构，任何 agent 都能用。

## 兼容矩阵

| Agent | 方式 | 状态 |
|---|---|---|
| **OpenCode** | `opencode/SKILL.md` → 引用 `instructions/` | ✅ 已适配 |
| **Claude Code** | `claude/plugin.json` → 引用 `instructions/` | 🔜 规划中 |
| **Cursor** | `.cursor/rules/moli-cn-copyright.mdc` → 引用 `instructions/` | 🔜 规划中 |
| **Codex (GitHub)** | 读取 `instructions/` 或 `README.md` | ✅ 通用 |
| **Cline / Roo Code** | `.clinerules` 或直接读取 `instructions/` | ✅ 通用 |
| **Aider** | 读取 `instructions/` 或通过 `--read` 加载 | ✅ 通用 |
| **任何 LLM** | 读取 `README.md` + `instructions/moli-cn-copyright.md` | ✅ 通用 |

## 设计原则

```
instructions/       ← 纯 Markdown，所有 agent 可读
└── moli-cn-copyright.md

opencode/SKILL.md   ← 薄适配层，引用 instructions/
claude/plugin.json  ← 薄适配层，引用 instructions/  (规划中)
cursor/rules/       ← 薄适配层，引用 instructions/  (规划中)
```

核心工作流写一次（`instructions/`），每个 agent 只需要一个轻量入口指向它。

## 给 agent 的安装指引

任何 agent 都可以通过以下步骤安装墨吏：

1. 克隆仓库：`git clone --depth=1 https://github.com/geek-fun/moli-skills.git ~/.moli-skills`
2. 安装依赖：`pip install python-docx`
3. 设置环境变量：`export MOLI_SKILLS_DIR="$HOME/.moli-skills"`
4. 读取工作流：`instructions/moli-cn-copyright.md`
