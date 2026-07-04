# 墨吏 Skills

墨吏（moli）是一款面向中文场景的 AI 文书技能集。**任何 agent 都能用。**

## Agent 兼容

| Agent | 使用方式 | 状态 |
|---|---|---|
| OpenCode | `opencode/SKILL.md` | ✅ |
| Claude Code | `claude/plugin.json` | 🔜 |
| Cursor / Windsurf | `.cursor/rules/` | 🔜 |
| Codex / Cline / Aider / 任何 LLM | 读取 `instructions/` 或 `README.md` | ✅ 通用 |

## 技能清单

| 技能 | 说明 | 状态 |
|---|---|---|
| `moli-cn-copyright` | AI 自动生成软著全套材料 | ✅ |
| `moli-cn-patent` | 专利申请材料生成 | 🔜 |
| `moli-write-polish` | 文章润色 | 🔜 |

## 安装

告诉你的 agent：

```
帮我安装 https://github.com/geek-fun/moli-skills
```

Agent 会读取本说明，自动完成：克隆 → 装依赖 → 配环境。

或手动：

```bash
curl -sSL https://raw.githubusercontent.com/geek-fun/moli-skills/master/install.sh | bash
```

## 使用：软著申请

```
帮我用 moli-cn-copyright 生成软著申请材料
```

AI 自动完成四步：

```
① setup check   → 检查环境
② source scan   → 读源码、理解功能
③ ask unclear   → 最多问 3 个问题
④ generate      → 输出可上传的材料
```

### 输出

```
docs/moli/
├── copyright-v1/
│   ├── 正式资料/
│   │   ├── xxx_V1.0_源代码.pdf      ← 直接上传版权中心
│   │   └── xxx_V1.0_操作手册.docx   ← 截图后转PDF
│   └── 验证报告.md
├── copyright-v2/                    ← 修订版
├── 修订历史.md
└── copyright-latest -> copyright-v2
```

## 架构

```
moli-skills/
├── instructions/           ← 共享工作流（所有 agent 可读）
│   └── moli-cn-copyright.md
├── opencode/               ← OpenCode 适配层
│   └── SKILL.md
├── claude/                 ← Claude Code 适配层 (🔜)
├── cursor/                 ← Cursor 适配层 (🔜)
├── moli-cn-copyright/      ← 核心脚本与规范
│   ├── scripts/            ← Python 辅助脚本
│   ├── references/         ← 规范文档
│   └── vendor/             ← DOCX 工具链
├── AGENTS.md               ← 兼容性说明
├── ARCHITECTURE.md         ← 命令体系设计
├── cli.py                  ← CLI 入口
└── install.sh              ← 安装脚本
```

## 许可证

Apache 2.0 © 2026 WENTSEN (Kunming) Technology Co., Ltd.
