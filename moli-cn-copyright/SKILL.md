---
name: moli-cn-copyright
description: 生成中国软件著作权（软著）全套申请材料。AI 自动分析项目代码、生成程序鉴别材料（源代码PDF）和文档鉴别材料（用户操作手册），仅需用户做最关键的决定。
---

# moli-cn-copyright

一条命令，AI 自主完成软著材料生成。

## 工作方式

一条命令，四步完成：

```
① setup check → ② source scan → ③ ask unclear → ④ generate
```

AI 直接阅读项目源码，理解业务逻辑、页面结构和功能流程，自行生成全套材料。Python 脚本仅用于格式化和验证。

## 工作流

### Phase 1：Setup Check（环境检查）

自动检查以下依赖是否就绪：

| 依赖 | 用途 | 不满足时 |
|---|---|---|
| Python 3.10+ | 运行排版脚本 | 提示用户安装 |
| python-docx | DOCX 文件生成 | `pip install python-docx` |
| 宋体字体（Songti/SimSun） | PDF 中文排版 | 提示用户安装中文字体 |
| pdftotext（可选） | PDF 验证 | 验证步骤降级 |

**环境不兼容时不阻塞**——AI 告知用户缺少什么、推荐安装方式，用户可选择"暂时跳过，先看扫描结果"或"帮我安装"。

### Phase 2：Source Scan（自动扫描）

AI 扫描项目并收集信息：

**项目元数据**
- 从 `package.json`、`manifest.json`、`app.json`、`pyproject.toml` 等读取
- 确定软件名称候选、版本号、技术栈
- 统计源程序总行数

**页面与路由**
- 遍历页面/组件文件，理解导航结构
- 记录每个页面的 UI 文案、按钮、入口等用户可见元素

**业务逻辑**
- 读取 README、PRD、架构文档
- 理解核心功能和操作流程
- 识别主要 API 和数据流

**代码抽取**
- 筛选核心业务逻辑文件（排除 node_modules/dist/构建产物/遗留代码）
- 去除空行和注释
- 选定前 30 页和后 30 页代码

### Phase 3：Ask Unclear（仅问拿不准的）

AI 自行完成上述扫描后，向用户呈现检测结果，只问 AI 无法确定的事项：

```
📋 检测结果：
   软件名称：山野集-菌迹软件
   版本号：V1.0（项目配置中为 1.0.0，软著首次申请建议 V1.0）
   源程序量：15,234 行
   著作权人：沃泰森（昆明）科技有限公司（从 git config 推断）
   功能描述：已根据源码生成约 600 字

❓ 需要确认（最多 3 项）：
   1. 软件名称正确吗？ [Y/n]
   2. 版本号用 V1.0 还是保持项目版本的 1.0.0？ [V1.0]
   3. 截图方式：自行截图 / 跳过保留占位 [自行截图]
```

**无歧义时不问**——如果项目只有一个明显的软件名称、版本号确定、功能清晰，直接跳过确认进入生成。

### Phase 4：Generate（输出材料）

生成 4 份文件，但只需上传 2 份到版权中心：

| 文件 | 用途 | 上传版权中心 |
|---|---|---|
| `xxx_源代码.pdf` | **程序鉴别材料**（前30页+后30页，60页） | ✅ **是** |
| `xxx_操作手册.docx` | **文档鉴别材料**（用户操作手册） | ✅ **是**（截图后转PDF） |
| `申请表信息.txt` | 本地备份，官网填表时对照复制 | ❌ 否 |
| `验证报告.md` | 合规检查结果，确认无误再提交 | ❌ 否 |

输出目录结构（`项目根目录/docs/moli/copyright/`）：

```
docs/moli/copyright/
├── 正式资料/
│   ├── 申请表信息.txt
│   ├── 山野集-菌迹软件_V1.0_源代码.pdf    ← 直接上传版权中心
│   └── 山野集-菌迹软件_V1.0_操作手册.docx  ← 截图后转PDF上传
├── 草稿/              ← AI 思考过程，可删
├── 截图/              ← 你放入的截图
└── 验证报告.md
```

目录规范：所有墨吏生成的材料统一放在 `docs/moli/<功能>/` 下，方便项目管理和 `.gitignore`。生成的代码 PDF 和操作手册就是最终提交文件，无需二次排版。

## 使用方式

```typescript
// 在 OpenCode 中
task({
  load_skills: ["moli-cn-copyright"],
  prompt: "为 mycotrail 项目生成软著申请材料"
})

// 或直接对话
"用 moli-cn-copyright 给当前项目生成软著材料"
```

## 验证

生成完成后，AI 自动进行合规验证：

```bash
cd moli-skills && python3 moli-cn-copyright/scripts/validate_materials.py \
  --workdir 软件著作权申请资料/正式资料 \
  --software-name "山野集-菌迹软件" \
  --version V1.0
```

## 格式规范参考

AI 在生成时遵循以下规范文档（位于 `references/`）：

| 文件 | 内容 |
|---|---|
| `copyright_material_rules.md` | 源代码页眉、页数、行数规则 |
| `code_selection_rules.md` | 代码抽取优先级和排除项 |
| `manual_structure.md` | 操作手册章节结构和写作规范 |
| `application_fields.md` | 申请表各字段说明和字数限制 |
| `validation_rules_compendium.md` | 33 条综合校验规则大全 |
| `business_understanding_rules.md` | 业务理解规范 |

## 辅助脚本

Python 脚本在 `scripts/` 下，用于格式化和验证，AI 会在需要时自动调用：

| 脚本 | 用途 | AI 调用时机 |
|---|---|---|
| `validate_materials.py` | 33 条规则合规验证 | 生成完成后 |
| `build_docx_from_md.py` | Markdown → 正式 DOCX | 排版操作手册 |
| `capture_screenshots.py` | 整理用户提供的截图 | 用户提供截图后 |

## 与原始 Fokkyp 的区别

| 项目 | 原始 Fokkyp | 墨吏 moli-cn-copyright |
|---|---|---|
| 驱动方式 | 脚本编排（11 步，6 个门禁） | **AI 自主驱动** |
| 代码分析 | 脚本 `analyze_project.py` | **AI 直接阅读源码** |
| 业务理解 | 脚本生成 JSON + 用户确认 | **AI 自行理解，仅确认名称** |
| 用户干预 | 频繁停等（环境/业务/字段/代码/截图/草稿） | **最少干预（名称/版本/截图）** |
| 验证 | 无 | **内置 33 条规则验证器** |
| 输出 | DOCX（用户转 PDF） | **直接生成可上传 PDF** |
