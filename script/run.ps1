# エラーで停止
$ErrorActionPreference = "Stop"

# プロジェクトルート
$rootDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$apiDir = Join-Path $rootDir "api"

# Azuriteのデータ保存場所
$azuriteData = Join-Path $rootDir "_azurite"
if (-not (Test-Path $azuriteData)) {
    New-Item -ItemType Directory -Path $azuriteData | Out-Null
}

# --- Azuriteを別プロセスで起動 ---
Write-Host "Azurite を起動します…" -ForegroundColor Cyan
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "azurite --blobPort 10000 --queuePort 10001 --tablePort 10002 --location `"$azuriteData`" --debug `"$azuriteData\debug.log`""
) -WorkingDirectory $rootDir
Write-Host "Azurite をバックグラウンドで起動しました。" -ForegroundColor Green
Write-Host "Blob:   http://127.0.0.1:10000/"
Write-Host "Queue:  http://127.0.0.1:10001/"
Write-Host "Table:  http://127.0.0.1:10002/"

# --- SWAを別プロセスで起動 ---
Write-Host "Static Web Apps CLI を起動します…" -ForegroundColor Cyan
Set-Location $apiDir
.venv/Scripts/activate
Start-Process powershell -ArgumentList @(
    "-NoExit",
    "-Command",
    "& swa start src --api-location api"
) -WorkingDirectory $rootDir

# 完了メッセージ
$endMsg = @"
AzuriteとStatic Web Apps CLIの起動を新規ウィンドウで開始しました。
停止するには各ウィンドウでCtrl+Cを押下してください。
"@
Write-Host $endMsg -ForegroundColor Green
