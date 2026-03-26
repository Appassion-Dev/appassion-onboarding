Write-Host "=== AI-Assisted Development Stack Verification ===" -ForegroundColor Cyan
Write-Host ""

# Track installation status
$tools = @()

# Git
Write-Host "Git:" -ForegroundColor Green
try {
    $gitVersion = git --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host $gitVersion
        $tools += @{ name = "Git"; status = "✅"; version = $gitVersion }
    } else {
        Write-Host "❌ Not found" -ForegroundColor Red
        $tools += @{ name = "Git"; status = "❌"; version = "Not installed" }
    }
} catch {
    Write-Host "❌ Command failed" -ForegroundColor Red
    $tools += @{ name = "Git"; status = "❌"; version = "Error" }
}
Write-Host ""

# GitHub SSH Connection
Write-Host "GitHub SSH Connection:" -ForegroundColor Green
try {
    $sshOutput = ssh -T git@github.com 2>&1
    # SSH to GitHub returns "Hi username! ... but GitHub does not provide shell access" which is success
    if ($sshOutput -match "successfully authenticated" -or $sshOutput -match "You've successfully authenticated") {
        Write-Host $sshOutput
        $tools += @{ name = "GitHub SSH"; status = "✅"; version = "Connected" }
    } else {
        Write-Host "❌ Not connected" -ForegroundColor Red
        $tools += @{ name = "GitHub SSH"; status = "❌"; version = "Not connected" }
    }
} catch {
    Write-Host "❌ Connection failed" -ForegroundColor Red
    $tools += @{ name = "GitHub SSH"; status = "❌"; version = "Error" }
}
Write-Host ""

# Node & npm
Write-Host "Node & npm:" -ForegroundColor Green
try {
    $nodeVersion = node --version 2>&1
    $npmVersion = npm --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host $nodeVersion
        Write-Host $npmVersion
        $tools += @{ name = "Node"; status = "✅"; version = $nodeVersion }
        $tools += @{ name = "npm"; status = "✅"; version = $npmVersion }
    } else {
        Write-Host "❌ Not found" -ForegroundColor Red
        $tools += @{ name = "Node"; status = "❌"; version = "Not installed" }
        $tools += @{ name = "npm"; status = "❌"; version = "Not installed" }
    }
} catch {
    Write-Host "❌ Command failed" -ForegroundColor Red
    $tools += @{ name = "Node"; status = "❌"; version = "Error" }
    $tools += @{ name = "npm"; status = "❌"; version = "Error" }
}
Write-Host ""

# VS Code
Write-Host "VS Code:" -ForegroundColor Green
try {
    $codeVersion = code.cmd --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host $codeVersion
        $tools += @{ name = "VS Code"; status = "✅"; version = ($codeVersion -split "`n" | Select-Object -First 1) }
    } else {
        Write-Host "❌ Not found" -ForegroundColor Red
        $tools += @{ name = "VS Code"; status = "❌"; version = "Not installed" }
    }
} catch {
    Write-Host "❌ Command failed" -ForegroundColor Red
    $tools += @{ name = "VS Code"; status = "❌"; version = "Error" }
}
Write-Host ""

# GitHub CLI
Write-Host "GitHub CLI:" -ForegroundColor Green
try {
    $ghVersion = gh --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host $ghVersion
        $tools += @{ name = "GitHub CLI"; status = "✅"; version = ($ghVersion -split "`n" | Select-Object -First 1) }
    } else {
        Write-Host "❌ Not found" -ForegroundColor Red
        $tools += @{ name = "GitHub CLI"; status = "❌"; version = "Not installed" }
    }
} catch {
    Write-Host "❌ Command failed" -ForegroundColor Red
    $tools += @{ name = "GitHub CLI"; status = "❌"; version = "Error" }
}
Write-Host ""

# GitHub Copilot CLI
Write-Host "GitHub Copilot CLI:" -ForegroundColor Green
try {
    $copilotHelp = gh copilot --help 2>&1 | Select-Object -First 3
    if ($LASTEXITCODE -eq 0) {
        Write-Host $copilotHelp
        $tools += @{ name = "GitHub Copilot CLI"; status = "✅"; version = "Installed" }
    } else {
        Write-Host "❌ Not found" -ForegroundColor Red
        $tools += @{ name = "GitHub Copilot CLI"; status = "❌"; version = "Not installed" }
    }
} catch {
    Write-Host "❌ Command failed" -ForegroundColor Red
    $tools += @{ name = "GitHub Copilot CLI"; status = "❌"; version = "Error" }
}
Write-Host ""

# Docker
Write-Host "Docker:" -ForegroundColor Green
try {
    $dockerVersion = docker --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host $dockerVersion
        $tools += @{ name = "Docker"; status = "✅"; version = ($dockerVersion -split "," | Select-Object -First 1) }
    } else {
        Write-Host "❌ Not found" -ForegroundColor Red
        $tools += @{ name = "Docker"; status = "❌"; version = "Not installed" }
    }
} catch {
    Write-Host "❌ Command failed" -ForegroundColor Red
    $tools += @{ name = "Docker"; status = "❌"; version = "Error" }
}
Write-Host ""

# Vercel CLI
Write-Host "Vercel CLI:" -ForegroundColor Green
try {
    $vercelVersion = vercel --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host $vercelVersion
        $tools += @{ name = "Vercel CLI"; status = "✅"; version = ($vercelVersion -split "`n" | Select-Object -First 1) }
    } else {
        Write-Host "❌ Not found" -ForegroundColor Red
        $tools += @{ name = "Vercel CLI"; status = "❌"; version = "Not installed" }
    }
} catch {
    Write-Host "❌ Command failed" -ForegroundColor Red
    $tools += @{ name = "Vercel CLI"; status = "❌"; version = "Error" }
}
Write-Host ""

# Supabase CLI
Write-Host "Supabase CLI:" -ForegroundColor Green
try {
    $supabaseVersion = supabase --version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host $supabaseVersion
        $tools += @{ name = "Supabase CLI"; status = "✅"; version = ($supabaseVersion -split "`n" | Select-Object -First 1) }
    } else {
        Write-Host "❌ Not found" -ForegroundColor Red
        $tools += @{ name = "Supabase CLI"; status = "❌"; version = "Not installed" }
    }
} catch {
    Write-Host "❌ Command failed" -ForegroundColor Red
    $tools += @{ name = "Supabase CLI"; status = "❌"; version = "Error" }
}
Write-Host ""

# Summary
Write-Host "=== Verification Summary ===" -ForegroundColor Cyan
Write-Host ""
$tools | ForEach-Object {
    Write-Host "$($_.status) $($_.name): $($_.version)"
}
Write-Host ""

# Check if all required tools are installed
$requiredTools = @("Git", "GitHub SSH", "Node", "npm", "VS Code", "GitHub CLI", "GitHub Copilot CLI", "Docker", "Vercel CLI", "Supabase CLI")
$installedRequired = ($tools | Where-Object { $_.name -in $requiredTools -and $_.status -eq "✅" }).Count
$totalRequired = $requiredTools.Count

Write-Host "=== Verification Complete! ===" -ForegroundColor Cyan
Write-Host ""
if ($installedRequired -eq $totalRequired) {
    Write-Host "✅ All required tools are installed and accessible!" -ForegroundColor Green
} else {
    Write-Host "⚠️  $installedRequired of $totalRequired required tools are installed" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Missing tools:" -ForegroundColor Yellow
    $tools | Where-Object { $_.name -in $requiredTools -and $_.status -ne "✅" } | ForEach-Object {
        Write-Host "  - $($_.name)" -ForegroundColor Yellow
    }
}
