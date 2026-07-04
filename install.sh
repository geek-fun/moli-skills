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
        VER=$("$cmd" --version 2>&1 | grep -oP '\d+\.\d+')
        if awk "BEGIN {exit !($VER >= 3.10)}" 2>/dev/null; then
            PYTHON="$cmd"
            break
        fi
    fi
done

if [ -z "$PYTHON" ]; then
    echo -e "${YELLOW}⚠ Python 3.10+ 未找到。请先安装：${NC}"
    echo "  macOS: brew install python@3.11"
    echo "  Ubuntu: sudo apt install python3 python3-pip"
    echo "  或访问 https://www.python.org/downloads/"
    exit 1
fi
echo -e "  ${GREEN}✅${NC} Python: $($PYTHON --version)"

# ── 2. 克隆 / 更新 ──
if [ -d "$INSTALL_DIR/.git" ]; then
    echo -e "  ${BLUE}ℹ${NC} 更新已有安装: $INSTALL_DIR"
    git -C "$INSTALL_DIR" pull --ff-only origin "$BRANCH" 2>/dev/null || true
else
    echo -e "  ${BLUE}ℹ${NC} 克隆到: $INSTALL_DIR"
    git clone --depth=1 --branch "$BRANCH" "https://github.com/$REPO.git" "$INSTALL_DIR"
fi

# ── 3. 安装 Python 依赖 ──
echo -e "  ${BLUE}ℹ${NC} 安装 Python 依赖..."
$PYTHON -m pip install python-docx --quiet 2>/dev/null && \
    echo -e "  ${GREEN}✅${NC} python-docx" || \
    echo -e "  ${YELLOW}⚠${NC} python-docx 安装失败，DOCX 生成将降级"

# ── 4. 写入环境配置 ──
SHELL_RC="${HOME}/.$(basename "${SHELL:-bash}")rc"
if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
    SHELL_RC="${HOME}/.zshrc"
fi

LINE="export MOLI_SKILLS_DIR=\"$INSTALL_DIR\""
if ! grep -q "MOLI_SKILLS_DIR" "$SHELL_RC" 2>/dev/null; then
    echo "$LINE" >> "$SHELL_RC"
    echo -e "  ${GREEN}✅${NC} 已写入 $SHELL_RC"
else
    echo -e "  ${GREEN}✅${NC} MOLI_SKILLS_DIR 已配置"
fi

# ── 5. 完成 ──
echo ""
echo -e "${GREEN}━━━ 安装完成 ━━━${NC}"
echo ""
echo "在 OpenCode 中使用："
echo "  task({"
echo "    load_skills: [\"moli-cn-copyright\"],"
echo "    prompt: \"为当前项目生成软著申请材料\""
echo "  })"
echo ""
echo "或直接说："
echo "  \"用 moli-cn-copyright 生成软著材料\""
echo ""
echo "附：手动验证"
echo "  cd \$MOLI_SKILLS_DIR && python3 moli-cn-copyright/scripts/validate_materials.py --help"
