# 墨吏 moli-skills Windows 安装脚本
# 以管理员身份运行，或确保有权限创建符号链接

$Repo = "geek-fun/moli-skills"
$InstallDir = if ($env:MOLI_SKILLS_DIR) { $env:MOLI_SKILLS_DIR } else { "$HOME\.moli-skills" }

Write-Host "━━━ 墨吏 moli-skills 安装 ━━━" -ForegroundColor Blue

# ── 1. 检测 Python ──
$python = $null
foreach ($cmd in @("python3", "python")) {
    try {
        $ver = & $cmd --version 2>&1
        if ($ver -match "(\d+)\.(\d+)") {
            $major = [int]$Matches[1]
            $minor = [int]$Matches[2]
            if ($major -gt 3 -or ($major -eq 3 -and $minor -ge 10)) {
                $python = $cmd
                break
            }
        }
    } catch {}
}

if (-not $python) {
    Write-Host "⚠ Python 3.10+ 未找到。请安装：" -ForegroundColor Yellow
    Write-Host "  https://www.python.org/downloads/"
    Write-Host "  安装时勾选 'Add Python to PATH'"
    exit 1
}
Write-Host "  ✅ Python: $(& $python --version)" -ForegroundColor Green

# ── 2. 下载最新 Release ──
if (Test-Path $InstallDir) {
    Remove-Item -Recurse -Force $InstallDir
}
New-Item -ItemType Directory -Force -Path $InstallDir | Out-Null

Write-Host "  ℹ 获取最新 Release..." -ForegroundColor Blue
try {
    $apiUrl = "https://api.github.com/repos/$Repo/releases/latest"
    $release = Invoke-RestMethod -Uri $apiUrl -Headers @{ "Accept" = "application/json" }
    $version = $release.tag_name
    Write-Host "  ✅ 下载: $version" -ForegroundColor Green

    $tarball = "https://github.com/$Repo/archive/refs/tags/$version.tar.gz"
    $tarballPath = "$env:TEMP\moli-skills.tar.gz"

    Invoke-WebRequest -Uri $tarball -OutFile $tarballPath
    tar -xzf $tarballPath -C $InstallDir --strip-components=1
    Remove-Item $tarballPath -Force
} catch {
    Write-Host "  ⚠ 获取 Release 失败: $_" -ForegroundColor Yellow
    Write-Host "  请检查网络连接后重试"
    exit 1
}

# ── 3. 安装依赖 ──
Write-Host "  ℹ 安装 python-docx..." -ForegroundColor Blue
try {
    & $python -m pip install python-docx --quiet
    Write-Host "  ✅ python-docx" -ForegroundColor Green
} catch {
    Write-Host "  ⚠ python-docx 安装失败，DOCX 生成将降级" -ForegroundColor Yellow
}

# ── 4. 注册到各平台 ──
# OpenCode: copy to ~\.agents\skills\moli-cn-copyright\
$agDir = "$HOME\.agents\skills\moli-cn-copyright"
if (-not (Test-Path "$agDir\SKILL.md")) {
    New-Item -ItemType Directory -Force -Path $agDir | Out-Null
    Copy-Item -Recurse -Force "$InstallDir\opencode\*" $agDir
    Write-Host "  ✅ OpenCode: /moli-cn-copyright" -ForegroundColor Green
}

# OpenCode validate command
$agValDir = "$HOME\.agents\skills\moli-cn-copyright-validate"
if (-not (Test-Path "$agValDir\SKILL.md")) {
    New-Item -ItemType Directory -Force -Path $agValDir | Out-Null
    Copy-Item -Recurse -Force "$InstallDir\opencode\validate\*" $agValDir
    Write-Host "  ✅ OpenCode: /moli-cn-copyright-validate" -ForegroundColor Green
}

# OpenCode (alt): copy to ~\.config\opencode\skills\moli-cn-copyright\
$ocDir = "$HOME\.config\opencode\skills\moli-cn-copyright"
if (-not (Test-Path "$ocDir\SKILL.md")) {
    New-Item -ItemType Directory -Force -Path $ocDir | Out-Null
    Copy-Item -Recurse -Force "$InstallDir\opencode\*" $ocDir
    Write-Host "  ✅ OpenCode (alt): $ocDir" -ForegroundColor Green
}

# Claude Code: copy to ~\.claude\plugins\moli-skills\
$ccDir = "$HOME\.claude\plugins\moli-skills"
if (-not (Test-Path "$ccDir\.claude-plugin\plugin.json")) {
    New-Item -ItemType Directory -Force -Path $ccDir | Out-Null
    Copy-Item -Recurse -Force "$InstallDir\claude\*" $ccDir
    Write-Host "  ✅ Claude Code: /moli-skills:copyright" -ForegroundColor Green
}

# ── 5. 环境变量 ──
$envLine = [Environment]::GetEnvironmentVariable("MOLI_SKILLS_DIR", "User")
if (-not $envLine) {
    [Environment]::SetEnvironmentVariable("MOLI_SKILLS_DIR", $InstallDir, "User")
    Write-Host "  ✅ 环境变量 MOLI_SKILLS_DIR 已设置" -ForegroundColor Green
} else {
    Write-Host "  ✅ 环境变量已配置" -ForegroundColor Green
}

# ── 完成 ──
Write-Host ""
Write-Host "━━━ 安装完成 ━━━" -ForegroundColor Green
Write-Host ""
Write-Host "使用方法："
Write-Host "  OpenCode:  /moli-cn-copyright"
Write-Host "  Claude:    claude --plugin $ccDir"
Write-Host "  Cursor:    复制 cursor/rules/ 到项目 .cursor/rules/"
Write-Host ""
Write-Host "验证："
Write-Host "  python3 `$env:MOLI_SKILLS_DIR\moli-cn-copyright\scripts\validate_materials.py --help"
