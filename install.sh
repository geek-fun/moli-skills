#!/usr/bin/env bash
set -euo pipefail

REPO="geek-fun/moli-skills"
BRANCH="master"
INSTALL_DIR="${MOLI_SKILLS_DIR:-$HOME/.moli-skills}"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}━━━ 墨吏 moli-skills 安装 ━━━${NC}"

# ── 1. 检测 Python ──
PYTHON=""
for cmd in python3 python; do
    if command -v "$cmd" &>/dev/null; then
        VER=$("$cmd" --version 2>&1 | grep -oP '\d+\.\d+' | head -1)
        if awk "BEGIN {exit !($VER >= 3.10)}" 2>/dev/null; then
            PYTHON="$cmd"
            break
        fi
    fi
done

if [ -z "$PYTHON" ]; then
    echo -e "${YELLOW}⚠ Python 3.10+ 未找到。请安装：${NC}"
    echo "  macOS: brew install python@3.11"
    echo "  或 https://www.python.org/downloads/"
    exit 1
fi
echo -e "  ${GREEN}✅${NC} Python: $($PYTHON --version)"

# ── 2. 克隆 / 更新 ──
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "  ${BLUE}ℹ${NC} 更新: $INSTALL_DIR"
    git -C "$INSTALL_DIR" pull --ff-only origin "$BRANCH" 2>/dev/null || true
else
    echo -e "  ${BLUE}ℹ${NC} 克隆到: $INSTALL_DIR"
    git clone --depth=1 --branch "$BRANCH" "https://github.com/$REPO.git" "$INSTALL_DIR"
fi

# ── 3. 安装依赖 ──
echo -e "  ${BLUE}ℹ${NC} 安装 python-docx..."
$PYTHON -m pip install python-docx --quiet 2>/dev/null && \
    echo -e "  ${GREEN}✅${NC} python-docx" || \
    echo -e "  ${YELLOW}⚠${NC} python-docx 安装失败，DOCX 生成将降级"

# ── 4. 注册到各平台 ──
# OpenCode: symlink to ~/.agents/skills/moli-cn-copyright/ (for /command support)
AG_DIR="$HOME/.agents/skills/moli-cn-copyright"
if [ ! -L "$AG_DIR/SKILL.md" ]; then
    mkdir -p "$(dirname "$AG_DIR")"
    ln -sfn "$INSTALL_DIR/opencode" "$AG_DIR"
    echo -e "  ${GREEN}✅${NC} OpenCode: /moli-cn-copyright"
fi

# OpenCode (alt): symlink to ~/.config/opencode/skills/moli-cn-copyright/
OC_DIR="$HOME/.config/opencode/skills/moli-cn-copyright"
if [ ! -L "$OC_DIR/SKILL.md" ]; then
    mkdir -p "$(dirname "$OC_DIR")"
    ln -sfn "$INSTALL_DIR/opencode" "$OC_DIR"
    echo -e "  ${GREEN}✅${NC} OpenCode (alt): $OC_DIR"
fi

# Claude Code: symlink to ~/.claude/plugins/moli-skills/
CC_DIR="$HOME/.claude/plugins/moli-skills"
if [ ! -L "$CC_DIR" ]; then
    mkdir -p "$(dirname "$CC_DIR")"
    ln -sfn "$INSTALL_DIR/claude" "$CC_DIR"
    echo -e "  ${GREEN}✅${NC} Claude Code: /moli-skills:copyright"
fi

# ── 5. 环境变量 ──
SHELL_RC="${HOME}/.zshrc"
if [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

LINE="export MOLI_SKILLS_DIR=\"$INSTALL_DIR\""
if ! grep -q "MOLI_SKILLS_DIR" "$SHELL_RC" 2>/dev/null; then
    echo "$LINE" >> "$SHELL_RC"
    echo -e "  ${GREEN}✅${NC} 环境变量已写入 $SHELL_RC"
else
    echo -e "  ${GREEN}✅${NC} 环境变量已配置"
fi

# ── 完成 ──
echo ""
echo -e "${GREEN}━━━ 安装完成 ━━━${NC}"
echo ""
echo "使用方法："
echo "  OpenCode:  告诉 agent "帮我用 moli-cn-copyright 生成软著""
echo "  Claude:    claude --plugin ~/.claude/plugins/moli-skills"
echo "  Cursor:    复制 cursor/rules/ 到项目 .cursor/rules/"
echo ""
echo "验证："
echo "  python3 \$MOLI_SKILLS_DIR/moli-cn-copyright/scripts/validate_materials.py --help"
