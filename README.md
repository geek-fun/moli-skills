# 墨吏 Skills

墨吏（moli）是一款面向中文场景的 AI 文书技能集，覆盖软件著作权申请、专利文档生成、文章润色、社交媒体文案等写作任务。

## 核心理念

> 与文书打交道的事，交给墨吏。

墨吏 skills 的目标是让重复性的文书工作变得可自动化、可追溯、可审查。每个技能都遵循"收集 → 草稿 → 确认 → 输出"的工作流，确保最终产出经得起审查。

## 技能清单

| 技能 | 命令 | 说明 | 状态 |
|---|---|---|---|
| 软著申请 | `moli-cn-copyright` | 生成中国软件著作权全套申请材料 | ✅ |
| 专利申请 | `moli-cn-patent` | 生成中国专利申请材料 | 🔜 |
| 文章润色 | `moli-write-polish` | 文章润色与修改 | 🔜 |
| 小红书文案 | `moli-write-xiaohongshu` | 小红书内容创作 | 🔜 |
| 文章写作 | `moli-write-article` | 结构化文章写作 | 🔜 |

## 快速开始

### 在 OpenCode 中调用

```typescript
// 加载技能
const copyrightSkill = await skill({ name: 'moli-cn-copyright' })

// 或在任务中加载
task({
  category: "unspecified-high",
  load_skills: ["moli-cn-copyright"],
  prompt: "为我的项目生成软著申请材料"
})
```

### 目录结构

```
moli-skills/
├── README.md                 # 本文件
├── ARCHITECTURE.md           # 架构与命令体系文档
├── moli-cn-copyright/        # 软著申请（已实现）
├── moli-cn-patent/           # 专利申请（预留）
├── moli-write-polish/        # 文章润色（预留）
└── templates/                # 共享模板
```

## 开发规范

1. 每个技能是一个独立目录，包含完整的 `SKILL.md`
2. `SKILL.md` 必须包含：name、description、详细工作流、验证检查项
3. 脚本和资源放在技能目录内部，不跨目录引用
4. 共享资源放在 `templates/` 目录下

## 许可证

MIT License. 各技能目录内含原始作者许可证信息。
