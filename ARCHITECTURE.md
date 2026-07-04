# 墨吏 Skills — 架构与命令体系

## 命名体系

墨吏（moli）skills 采用分层命名体系，格式如下：

```
moli-<地域/领域>-<功能>
```

| 层级 | 说明 | 示例 |
|---|---|---|
| `moli` | 根命名空间，代表"墨吏"品牌 | — |
| `<地域/领域>` | 地域或领域分类 | `cn`（中国）、`write`（写作） |
| `<功能>` | 具体功能 | `copyright`（软著）、`patent`（专利）、`polish`（润色） |

### 现有技能

| 技能名称 | 功能 | 状态 |
|---|---|---|
| `moli-cn-copyright` | 中国软件著作权申请材料生成 | ✅ 已实现 |
| `moli-cn-patent` | 中国专利申请材料生成 | 📅 规划中 |
| `moli-write-polish` | 文章润色 | 📅 规划中 |
| `moli-write-xiaohongshu` | 小红书文案生成 | 📅 规划中 |
| `moli-write-article` | 文章写作 | 📅 规划中 |

### 调用方式

在 OpenCode 中通过 `skill()` 工具加载：

```typescript
// 加载软著技能
const skillContent = await skill({ name: 'moli-cn-copyright' })

// 未来加载其他技能
const polishSkill = await skill({ name: 'moli-write-polish' })
```

或在 agent 任务中作为技能加载：

```typescript
task({
  category: "unspecified-high",
  load_skills: ["moli-cn-copyright"],
  prompt: "..."
})
```

## 目录结构

```
moli-skills/
├── README.md                 # 墨吏 skills 整体说明
├── ARCHITECTURE.md           # 本文件：架构与命令体系
├── moli-cn-copyright/        # 软著申请技能
│   ├── SKILL.md              # OpenCode 技能入口
│   ├── references/           # 规范文档与参考资料
│   ├── scripts/              # Python 脚本工具集
│   └── vendor/               # 第三方依赖（如 docx-toolkit）
├── moli-cn-patent/           # 🔜 专利生成技能（预留）
│   └── SKILL.md
├── moli-write-polish/        # 🔜 文章润色技能（预留）
│   └── SKILL.md
└── templates/                # 共享模板资源（预留）
```

## 设计原则

1. **自包含**：每个技能目录独立，包含完整的 SKILL.md、脚本和参考资料
2. **平台无关**：Python 脚本等核心逻辑不绑定特定 AI 平台
3. **渐进增强**：基础功能不依赖外部工具，可选安装增强功能（如 .NET SDK 提升 DOCX 质量）
4. **一致体验**：所有技能遵循相同的工作流模式：收集信息 → 生成草稿 → 用户确认 → 输出正式材料
5. **可扩展**：新增技能只需创建新目录 + 编写 SKILL.md，无需修改现有结构

## OpenCode 兼容性

每个技能目录下的 `SKILL.md` 符合 OpenCode 技能规范：

```yaml
---
name: moli-cn-copyright
description: 中国软件著作权申请材料生成
---
```

技能内容包含完整的工作流说明、验证检查项和输出标准，Agent 可直接按照 SKILL.md 的指引执行任务。
