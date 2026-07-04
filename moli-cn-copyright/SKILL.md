---
name: moli-cn-copyright
description: 生成中国软件著作权（软著）全套申请材料。从项目源码自动提取代码、生成程序鉴别材料（前后各30页源代码PDF）、文档鉴别材料（用户操作手册）、申请表信息，符合中国版权保护中心要求。
---

# 软著申请材料生成

本技能为 **墨吏（moli）** 系列技能之一，用于生成中国软件著作权申请所需的全部材料。

## 适用范围

- 微信小程序、Web 应用、移动 App（HarmonyOS / Android / iOS）、桌面应用
- 适用技术栈：JavaScript/TypeScript、Vue、React、Python、Java、Go、C# 等
- 支持 uni-app、Tauri、Electron 等跨平台框架

## 工作流总览

```
① 环境检查 → ② 项目分析 → ③ 业务理解 → ④ 申请表确认 → ⑤ 代码选择
→ ⑥ 代码材料生成 → ⑦ 操作手册生成 → ⑧ 截图 → ⑨ 正式输出 → ⑩ 验证
```

**核心规则**：第③④⑤⑦⑧步必须等待用户确认后才能继续（"门禁"机制）。

---

## 第一阶段：环境检查

在当前工作目录创建输出目录并检查运行能力：

```bash
python3 ${MOLI_SKILLS_DIR}/moli-cn-copyright/scripts/check_environment.py \
  --out-dir 软件著作权申请资料
```

输出：`软件著作权申请资料/环境检查.md` 和 `环境检查.json`

告知用户：
- 当前会在"当前目录/软件著作权申请资料"下生成材料
- Markdown 草稿、TXT、基础 DOCX 是否可用
- 内置 vendor/docx-toolkit 的完整 OpenXML 环境是否可用
- 如 .NET SDK 缺失，询问是否安装完整环境

**门禁 `environment`**：必须等待用户选择后再继续。

---

## 第二阶段：定位项目

扫描当前目录，避开本技能目录、输出目录、node_modules、构建产物和隐藏目录，找到项目根目录。

有多个候选时停止询问，单个时直接使用。

---

## 第三阶段：分析项目

```bash
python3 ${MOLI_SKILLS_DIR}/moli-cn-copyright/scripts/analyze_project.py \
  --project <项目目录> \
  --out 软件著作权申请资料/analysis/project.json
```

分析内容：package.json/README/入口文件/路由/页面/组件/API/状态管理/源程序行数等。

---

## 第四阶段：业务理解

先收集项目证据：

```bash
python3 ${MOLI_SKILLS_DIR}/moli-cn-copyright/scripts/generate_business_context.py \
  --project <项目目录> \
  --analysis 软件著作权申请资料/analysis/project.json \
  --software-name "<软件全称>" \
  --out-dir 软件著作权申请资料/草稿
```

输出：`草稿/业务理解证据.md`、`草稿/业务理解证据.json`、`草稿/业务理解模型稿模板.json`

**模型必须亲自阅读项目源码**（README、PRD、页面路由、组件文案、接口定义），自行判断：
- 软件属于什么行业/领域
- 目标用户是谁
- 核心价值是什么
- 哪些功能应写入软著申请资料
- 典型操作流程如何组织
- 操作手册适合采用什么章节结构

**禁止**：用脚本关键字表决定行业/功能/结构；照抄范本文案。

生成业务理解 JSON（不少于以下字段）：`product_positioning`、`industry`、`target_users`、`core_value`、`business_features`、`business_feature_details`、`operation_flow`、`application_purpose`、`main_functions`、`technical_characteristics`、`manual_sections`、`manual_modules`、`system_requirements`、`faq`、`glossary`。

然后运行：

```bash
python3 ${MOLI_SKILLS_DIR}/moli-cn-copyright/scripts/generate_business_context.py \
  --project <项目目录> \
  --analysis ... \
  --software-name "<软件全称>" \
  --out-dir 软件著作权申请资料/草稿 \
  --model-context <模型生成的业务理解JSON>
```

**门禁 `business`**：生成 `草稿/业务理解.md` 后停止，等待用户确认。

---

## 第五阶段：确认申请表字段

按官网顺序向用户确认以下字段：

| 字段 | 说明 |
|---|---|
| 软件全称 | **必须用户确认**，所有正式文件名、页眉以此为准 |
| 软件简称 | 可选 |
| 版本号 | **必须用户确认**，项目版本 < V1.0 时需询问是否写 V1.0 |
| 软件分类 | 默认"应用软件" |
| 开发完成日期 | YYYY-MM-DD 格式 |
| 开发方式 | 单独开发/合作开发/委托开发/下达任务开发 |
| 软件说明 | 原创/修改 |
| 发表状态 | 已发表/未发表 |
| 首次发表日期 | 已发表时填写 |
| 著作权人 | 国家/省市/类型/姓名/证件号 |
| 权利范围 | 全部权利/部分权利 |
| 权利取得方式 | 原始取得/继受取得 |
| 硬件环境 | ≤50字符 |
| 软件环境 | ≤50字符 |
| 编程语言 | 预设按钮 + 自定义 ≤120字符 |
| 源程序量 | 纯数字（总行数） |
| 开发目的 | ≤50字符 |
| 面向领域/行业 | ≤50字符 |
| 主要功能 | **500-1300字** |
| 技术特点 | 多选标签 + ≤100字符 |

**门禁 `application-fields`**：生成 `草稿/申请表信息.md` 后停止，等待用户补全确认。

---

## 第六阶段：选择代码文件

生成候选清单：

```bash
python3 ${MOLI_SKILLS_DIR}/moli-cn-copyright/scripts/propose_code_selection.py \
  --project <项目目录> \
  --analysis ... \
  --out-dir 软件著作权申请资料/草稿
```

输出：`草稿/代码文件候选清单.md`、`草稿/代码文件选择.json`

**模型必须阅读源码后**修改 `代码文件选择.json`，填写 `selected`、`start_line`、`end_line`、`model_reason`。

优先抽取：入口、路由、页面、核心组件、接口封装、状态管理、工具函数等能让审核员看懂软件功能的代码。

排除：`node_modules`、`dist/build/.next/.nuxt/coverage`、lock 文件、图片/字体/二进制、sourcemap、minified 文件、自动生成文件。

**门禁 `code-selection`**：停止等待用户确认。

---

## 第七阶段：生成代码材料

```bash
python3 ${MOLI_SKILLS_DIR}/moli-cn-copyright/scripts/extract_code_material.py \
  --project <项目目录> \
  --analysis ... \
  --selection 软件著作权申请资料/草稿/代码文件选择.json \
  --software-name "<软件全称>" \
  --version "<版本号>" \
  --out-dir 软件著作权申请资料/草稿
```

### 代码格式规则

| 规则 | 要求 |
|---|---|
| 每页行数 | 50 行 |
| 总页数 | 正好 60 页（前30+后30） |
| 空行 | 全部删除 |
| 注释 | 全部删除 |
| 页眉 | 左侧"软件全称 版本号"，右侧"第 X 页" |
| 字体 | 宋体（SimSun/Songti）10.5pt（五号） |
| 公司名 | 不得出现在页眉 |
| 结尾 | 必须以完整代码模块结尾（如 `};`） |
| 真实性 | 必须来自项目源文件，禁止 AI 编造 |

不足 60 页时：全部输出。候选有余时：继续选择补充文件。

---

## 第八阶段：生成操作手册

```bash
python3 ${MOLI_SKILLS_DIR}/moli-cn-copyright/scripts/generate_manual_draft.py \
  --analysis ... \
  --business-context 软件著作权申请资料/草稿/业务理解.json \
  --software-name "<软件全称>" \
  --version "<版本号>" \
  --out-dir 软件著作权申请资料/草稿
```

### 操作手册结构

```
一、相关文档（表格）
二、说明（产品定位、目标用户、业务场景）
三、功能特点（段落式，4-8 项）
四、系统要求（表格：最低/推荐配置）
五～N、具体页面/功能操作（逐章说明）
常见问题解答（3-5 个）
术语表（表格）
```

### 写作规范

- 一级标题使用中文大写序号：`一、` 而非 `1.`
- 正文使用自然段落，**禁止**项目符号列表、编号列表
- **禁止**输出"进入方式：""页面内容：""操作步骤："等字段模板
- 每个核心页面必须覆盖：使用场景 → 页面用途 → 进入位置 → 页面内容 → 用户动作 → 输入/状态规则 → 系统反馈
- 语言面向普通用户，避免技术化表达（代码、框架、接口、状态管理、异步等）
- **去 AI 味**：避免"旨在、赋能、一站式、高效便捷、显著提升、强大能力、丰富功能"等套话
- 截图预留使用可见文字：`【截图预留：请在空白处插入XXX截图。】`

### 自检记录

生成时必须同步输出 `草稿/操作手册自检记录.md` 和 `.json`，至少包含：
- 第 1 轮：初稿，检查章节完整性和内容厚度
- 第 2 轮：按项目流程扩写，补足操作衔接
- 第 3 轮：去 AI 味，检查重复句式和套话

---

## 第九阶段：截图

让用户选择截图方式：

1. **Playwright / 浏览器工具**：适合 Web 项目
2. **用户自行截图**：将图片放入 `软件著作权申请资料/用户截图/`
3. **跳过截图**：保留可见截图预留文字

**门禁 `screenshot-method`**：必须等待用户选择。

截图后运行：

```bash
python3 ${MOLI_SKILLS_DIR}/moli-cn-copyright/scripts/capture_screenshots.py \
  --manual-dir 软件著作权申请资料/用户截图 \
  --out-dir 软件著作权申请资料/截图
```

---

## 第十阶段：正式输出

用户确认所有 Markdown 草稿后（**门禁 `markdown`**），生成正式材料：

```bash
python3 ${MOLI_SKILLS_DIR}/moli-cn-copyright/scripts/build_docx_from_md.py \
  --workdir 软件著作权申请资料 \
  --software-name "<软件全称>" \
  --version "<版本号>"
```

### 输出清单

```
正式资料/
├── 申请表信息.txt
├── <软件全称>-代码(前30页).docx    # 或 .pdf
├── <软件全称>-代码(后30页).docx    # 或 .pdf
├── <软件全称>_操作手册.docx         # 或 .pdf
└── 生成报告.md
```

---

## 第十一步：验证

至少执行三轮验证：

1. **文件完整性**：目标文件是否存在且非空
2. **代码真实性**：抽样检查代码片段能回溯到项目源码
3. **业务真实性**：申请表和操作手册内容能回溯到业务理解文档
4. **一致性**：软件名称、版本号、页数规则、申请表字段是否一致

可用命令：

```bash
python3 ${MOLI_SKILLS_DIR}/moli-cn-copyright/vendor/docx-toolkit/scripts/docx_preview.sh <生成的docx>
```

---

## 材料规范参考

详细规范文档见 `references/` 目录：

| 文件 | 内容 |
|---|---|
| `references/copyright_material_rules.md` | 鉴别材料规则（页数、格式） |
| `references/code_selection_rules.md` | 代码抽取规则（排除项、优先级） |
| `references/manual_structure.md` | 操作手册结构与写作规范 |
| `references/application_fields.md` | 申请表字段详细说明 |
| `references/business_understanding_rules.md` | 业务理解规范 |

---

## 依赖

### 必需
- Python 3.10+ 和 `python-docx`

### 可选（增强 DOCX 质量）
- .NET SDK 8.0+（用于完整 OpenXML 校验）

---

## 与环境变量

技能目录路径通过 `MOLI_SKILLS_DIR` 环境变量传递。建议在调用前设置为技能所在目录的绝对路径：

```bash
export MOLI_SKILLS_DIR=/path/to/moli-skills
```
