# 墨吏 Skills

墨吏（moli）是一款面向中文场景的 AI 文书技能集。一条命令，AI 自主完成复杂文书工作。

## 技能清单

| 技能 | 命令 | 说明 | 状态 |
|---|---|---|---|
| 软著申请 | `moli-cn-copyright` | AI 自动分析项目代码，生成全套软著申请材料 | ✅ |
| 专利申请 | `moli-cn-patent` | 生成中国专利申请材料 | 🔜 |
| 文章润色 | `moli-write-polish` | 文章润色与修改 | 🔜 |
| 小红书文案 | `moli-write-xiaohongshu` | 小红书内容创作 | 🔜 |

## 安装

### 方式一：一键安装（推荐）

```bash
curl -sSL https://raw.githubusercontent.com/geek-fun/moli-skills/master/install.sh | bash
```

自动完成：克隆仓库 → 安装依赖 → 配置环境变量。

### 方式二：手动

```bash
git clone --depth=1 https://github.com/geek-fun/moli-skills.git ~/.moli-skills
pip install python-docx
echo 'export MOLI_SKILLS_DIR="$HOME/.moli-skills"' >> ~/.zshrc
```

### 方式三：OpenCode 直接引用

配置 `.opencode/skills.yml` 指向本地路径即可。

## 使用：软著申请

### 在 OpenCode 中使用

```typescript
task({
  load_skills: ["moli-cn-copyright"],
  prompt: "为当前项目生成软著申请材料"
})
// 或直接说： "用 moli-cn-copyright 生成软著"
```

### 独立运行（验证）

```bash
python3 $MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py \
  --software-name "xxx软件" --version V1.0
```

### 一条命令，四步完成

```
① setup check   → 环境检查（缺啥问用户）
② source scan   → AI 自动读源码、理解功能
③ ask unclear   → 最多问 3 个问题
④ generate      → 输出可直接上传的材料
```

### 输出（`docs/moli/copyright-v1/`）

```
docs/moli/
├── copyright-v1/
│   ├── 正式资料/
│   │   ├── xxx_V1.0_源代码.pdf      ← 直接上传版权中心
│   │   └── xxx_V1.0_操作手册.docx   ← 截图后转PDF上传
│   └── 验证报告.md
├── copyright-v2/                    ← 修订版
├── 修订历史.md
└── copyright-latest -> copyright-v2
```

## 架构

```
moli-skills/
├── README.md              # 本文件
├── ARCHITECTURE.md        # 命令体系设计
├── moli-cn-copyright/     # 软著申请（已实现）
│   ├── SKILL.md           # AI 工作流指引
│   ├── references/        # 6 份规范文档
│   ├── scripts/           # 12 个辅助脚本
│   │   └── validate_materials.py  # 33条规则验证器
│   └── vendor/            # DOCX 工具链
├── moli-cn-patent/        # 🔜
└── moli-write-polish/     # 🔜
```

## 设计原则

- **AI 驱动，脚本辅助**：AI 直接阅读源码，脚本只做格式化和验证
- **最少干预**：只问 AI 无法确定的决定
- **版本可追溯**：每次生成保留独立版本，`修订历史.md` 跟踪变更
- **即生即验**：生成完成后自动合规检查

## 许可证

Apache 2.0 © 2026 WENTSEN (Kunming) Technology Co., Ltd.
各子模块保留原作者许可证。
