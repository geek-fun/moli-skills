# 墨吏 Skills

墨吏（moli）是一款面向中文场景的 AI 文书技能集。**任何 agent 都能用。**

## 技能清单

| 技能 | 说明 | 状态 |
|---|---|---|
| `moli-cn-copyright` | AI 自动分析项目代码，生成全套软著申请材料 | ✅ |
| `moli-cn-patent` | 专利申请材料生成 | 🔜 |
| `moli-write-polish` | 文章润色 | 🔜 |

## 安装

告诉你的 agent：

```
帮我安装 https://github.com/geek-fun/moli-skills
```

任何 agent 都会读取本说明，自动完成。也可手动：

```bash
curl -sSL https://raw.githubusercontent.com/geek-fun/moli-skills/master/install.sh | bash
```

### 各平台适配

安装后，各平台自动注册：

| Agent | 位置 | 说明 |
|---|---|---|
| OpenCode | `~/.config/opencode/skills/moli-cn-copyright/` | skill 即可用 |
| Claude Code | `~/.claude/plugins/moli-skills/` | 运行 `claude --plugin ~/.claude/plugins/moli-skills` |
| Cursor / Windsurf | `cursor/rules/` | 复制到项目 `.cursor/rules/` |

## 使用：软著申请

安装完成后，直接输入命令：

| 平台 | 命令 |
|---|---|
| OpenCode | `/moli-cn-copyright` |
| Claude Code | `/moli-skills:copyright` |
| Cursor | `@moli-cn-copyright 生成软著` |

### 工作流

```
/moli-cn-copyright                  → 生成材料
        ↓
你补充截图、修改内容
        ↓
/ 告诉 agent "帮我验证软著材料"   → 验证 → 修复 → ✅ 通过
```

### 完整流程

```
① setup check   → 检查环境
② source scan   → 读源码、理解功能
③ ask unclear   → 最多问 3 个问题
④ generate      → 输出 docs/moli/copyright-v1/
⑤ review        → 你补充截图、修改内容
⑥ validate      → 你告诉 AI"帮我验证"，AI 自动检查
⑦ fix           → AI 修复问题，直到全部通过 ✅
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
├── claude/                 ← Claude Code 适配层
│   ├── .claude-plugin/
│   │   └── plugin.json
│   └── skills/
│       └── copyright/
│           └── SKILL.md
├── cursor/                 ← Cursor / Windsurf 适配层
│   └── rules/
│       └── moli-cn-copyright.mdc
├── moli-cn-copyright/      ← 核心脚本与规范
│   ├── scripts/            ← Python 辅助脚本
│   ├── references/         ← 规范文档
│   └── vendor/             ← DOCX 工具链
├── ARCHITECTURE.md         ← 命令体系设计
├── cli.py                  ← CLI 入口
└── install.sh              ← 安装脚本
```

## 许可证

Apache 2.0 © 2026 WENTSEN (Kunming) Technology Co., Ltd.
