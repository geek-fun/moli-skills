# moli-cn-copyright — 软著申请材料生成

## 工作流

```
 setup check → source scan → ask unclear → generate
                                              ↓
                                        用户 review
                                         （补充截图/修改内容）
                                              ↓
                                        validate  ← 用户触发
                                              ↓
                                            fix
                                              ↓
                                          完成 ✅
```

---

## Step 1: Setup Check

检查以下依赖是否就绪。缺啥装啥，不要阻塞。

| 依赖 | 用途 | 安装命令 |
|---|---|---|
| Python 3.10+ | 运行排版脚本 | `python3 --version` 验证 |
| python-docx | DOCX 生成 | `pip install python-docx` |
| 宋体 (Songti/SimSun) | PDF 中文排版 | macOS 自带，无需安装 |

## Step 2: Source Scan

扫描项目，收集以下信息。**直接读取源码文件，不要靠问用户。**

**项目元数据**
- 读取 `package.json` / `manifest.json` / `app.json` / `pyproject.toml`
- 确定：软件名称、版本号、技术栈、源程序总行数

**页面与功能**
- 遍历页面/组件文件，记录每个页面的 UI 文案、按钮、入口
- 理解导航结构和页面关系

**业务逻辑**
- 读取 README / PRD / 架构文档
- 理解核心功能、操作流程、主要 API

**代码抽取**
- 排除：`node_modules`、`dist`、`build`、`.next`、lock 文件、二进制文件
- 排除：`mockData`、`util.js` 默认模板、`pages/logs` 等遗留代码
- 去除空行和注释
- 选定前 30 页和后 30 页的连续代码

## Step 3: Ask Unclear

向用户呈现检测结果。**只问 AI 无法确定的事项，通常不超过 3 项。**

```
📋 检测结果：
   软件名称：山野集-菌迹软件
   版本号：V1.0（项目配置为 1.0.0，软著首次申请建议 V1.0）
   源程序量：15,234 行
   著作权人：沃泰森（昆明）科技有限公司（从 git config 推断）
   主要功能：已根据源码生成约 600 字

❓ 需要确认：
   1. 软件名称正确吗？[Y/n]
   2. 版本号用 V1.0 还是保持项目的 1.0.0？[V1.0]
   3. 截图方式：自行截图 / 跳过（保留占位文字）[自行截图]
```

**无歧义时不问**——名称明确、版本清晰、功能完备时直接跳过。

## Step 4: Generate

### 输出目录

```
docs/moli/copyright-v1/
├── 正式资料/
│   ├── 申请表信息.txt
│   ├── xxx_V1.0_源代码.pdf          ← 上传版权中心
│   └── xxx_V1.0_操作手册.docx       ← 截图后转PDF上传
└── 验证报告.md
```

### 产出文件

| 文件 | 用途 | 上传版权中心 |
|---|---|---|
| `源代码.pdf` | 程序鉴别材料（前30+后30，60页） | ✅ |
| `操作手册.docx` | 文档鉴别材料 | ✅（截图后转PDF） |
| `申请表信息.txt` | 本地备份，填官网时对照 | ❌ |
| `验证报告.md` | 合规检查结果 | ❌ |

### 源代码 PDF 规范

- 总页数：正好 60 页（前 30 + 后 30）
- 每页：50 行有效代码，无空行，无注释
- 页眉：左侧"软件全称 V1.0"，右侧"第 X 页"
- 字体：宋体 10.5pt（五号）
- 禁止：页眉出现公司名称、URL、文档类型字样
- 结尾：以完整模块结束（如 `};`）

### 操作手册 DOCX 规范

章节结构（中文大写序号）：

```
一、相关文档（表格）
二、说明（产品定位、目标用户、业务场景）
三、功能特点（段落式，4-8 项）
四、系统要求（表格）
五～N、逐页面操作说明
常见问题解答（3-5 个）
术语表（表格）
```

写作要求：
- 正文为自然段落，禁止项目符号列表和编号步骤列表
- 禁止输出"进入方式："、 "操作步骤："等字段模板
- 每个页面覆盖：使用场景 → 页面用途 → 用户动作 → 系统反馈
- 语言面向普通用户，避免技术术语
- 去 AI 味：避免"旨在、赋能、一站式、高效便捷"等套话
- 截图位置保留可见占位文字：`【截图预留：请在此处插入XXX截图。】`

### 版本管理

```
docs/moli/
├── copyright-v1/         ← 第一版
├── copyright-v2/         ← 修订版
├── 截图/                 ← 所有版本共享
├── 修订历史.md
└── copyright-latest -> copyright-v2
```

每次生成自增版本号。操作手册内的「文档修改记录」表格自动更新。

---

## Step 5: User Review

生成完成后，告知用户：

```
📋 材料已生成到 docs/moli/copyright-v1/
   请 review 并补充：
   1. 操作手册截图 → 放入 截图/ 目录
   2. 检查内容是否准确
   3. 修改完成后运行 validate 检查合规
```

## Step 6: Validate

用户修改完成后，告知用户如何运行验证：

```bash
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-v1/正式资料 \
  --software-name "xxx软件" \
  --version V1.0
```

输出示例：

```
  ✅ R-SC-01 源代码PDF文件存在
  ✅ R-SC-02 源代码PDF页数 = 60
  ❌ R-SC-03 页眉包含软件名称和版本号
        软件名称: ❌
        版本号: ✅
        页眉预览: xxx软件 V1.0 源代码
        问题: 页眉包含"源代码"字样，应去掉
  
  总计: 19 | ✅ 通过: 17 | ❌ 错误: 2
```

## Step 7: Fix

根据 validate 报告中的 ❌ 错误，逐条修复：

```bash
# 修复后重新验证
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --workdir docs/moli/copyright-v2/正式资料 \
  --software-name "xxx软件" \
  --version V1.0
```

**直到所有 ❌ 修复为 ✅，材料方可提交。**

---

## Appendix: 辅助脚本

路径：`scripts/`

| 脚本 | 用途 |
|---|---|
| `validate_materials.py` | 33 条规则合规验证 |
| `build_docx_from_md.py` | Markdown → 正式 DOCX |
| `extract_code_material.py` | 抽取代码并排版 |
| `check_environment.py` | 环境检测 |

所有脚本通过 `MOLI_SKILLS_DIR` 环境变量定位，或通过 `Path(__file__).parents[1]` 自动发现。

## Appendix: 规范文档

路径：`references/`

| 文件 | 内容 |
|---|---|
| `validation_rules_compendium.md` | 33 条综合校验规则大全 |
| `copyright_material_rules.md` | 源代码页眉、页数、行数规则 |
| `code_selection_rules.md` | 代码抽取优先级和排除项 |
| `manual_structure.md` | 操作手册章节结构和写作规范 |
| `application_fields.md` | 申请表各字段说明和字数限制 |
| `business_understanding_rules.md` | 业务理解规范 |
