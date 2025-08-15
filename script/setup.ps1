# =============================================================================
# 実行方法
# 1. VSCodeを「管理者として実行」で開いてください。
# 2. VSCodeでこのファイルを開き、画面右上の▷(Run)で実行してください。
# =============================================================================

# 開始メッセージ
$startMsg = @"
環境構築を開始します。
'環境構築が完了しました。'の表示が出るまでお待ちください。
"@
Write-Host $startMsg -ForegroundColor Cyan

# Python 3.11 のインストール
Write-Host "Python 3.11 のインストールを開始します..."
$python = winget list --name "Python 3.11" | Select-String "3\.11"
if ($python) {
    Write-Host "Python 3.11 はすでにインストールされています。スキップします。"
} else {
    Write-Host "Python 3.11 をインストールします..."
    winget install --id Python.Python.3.11 --scope machine --accept-package-agreements --accept-source-agreements
}
Write-Host "Python 3.11 のインストールを終了します。"

# Node.js 22.17 のインストール
Write-Host "Node.js 22.17 のインストールを開始します..."
$node = winget list --name "Node.js" | Select-String "22\.17"
if ($node) {
    Write-Host "Node.js 22.17 はすでにインストールされています。スキップします。"
} else {
    Write-Host "Node.js 22.17 をインストールします。"
    winget install --id OpenJS.NodeJS.LTS --version 22.17.0 --scope machine --accept-package-agreements --accept-source-agreements
}
Write-Host "Node.js 22.17 のインストールを終了します。"

# Azure functions Core Tools のインストール
Write-Host "Azure functions Core Tools のインストールを開始します..."
if (Get-Command func -ErrorAction SilentlyContinue) {
  Write-Host "Azure Functions Core Tools はすでにインストールされています。スキップします。"
} else {
  Write-Host "Azure Functions Core Tools をインストールします…"
  npm install -g azure-functions-core-tools@4 --unsafe-perm true
}
Write-Host "Azure functions Core Tools のインストールを終了します。"

# Azure Static Web Apps CLI のインストール
Write-Host "Azure Static Web Apps CLI のインストールを開始します..."
if (Get-Command swa -ErrorAction SilentlyContinue) {
  Write-Host "Azure Static Web Apps CLI はすでにインストールされています。スキップします。"
} else {
  Write-Host "Azure Static Web Apps CLI をインストールします…"
  npm install -g @azure/static-web-apps-cli
}
Write-Host "Azure Static Web Apps CLI のインストールを終了します。"

# Azurite のインストール
Write-Host "Azurite のインストールを開始します..."
if (Get-Command azurite -ErrorAction SilentlyContinue) {
  Write-Host "Azurite はすでにインストールされています。スキップします。"
} else {
  Write-Host "Azurite をインストールします…"
  npm install -g azurite
}
Write-Host "Azurite のインストールを終了します。"

# Azurite の初期設定
Write-Host "Azurite の初期設定を開始します..."
$azuriteArgs = @(
  "--blobPort","10000",
  "--queuePort","10001",
  "--tablePort","10002",
  "--location","/_azurite",
  "--debug","./_azurite/debug.log"
)
$p = Start-Process -FilePath "azurite" -ArgumentList $azuriteArgs -WindowStyle Hidden -PassThru
Start-Sleep -Milliseconds 1500
Stop-Process -Id $p.Id -Force
Write-Host "Azuriteの初期設定を終了します。"

# プロジェクトルートとAPIディレクトリの設定
$rootDir = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$apiDir = Join-Path $rootDir "api"

# 仮想環境の作成
Write-Host "仮想環境を作成しています..."
try {
    Set-Location $apiDir
    & py -3.11 -m venv .venv
    Write-Host "仮想環境の作成が完了しました。"
} catch {
    throw "仮想環境の作成中にエラーが発生しました: $_"
}

# 仮想環境にライブラリをインストール
Write-Host "仮想環境にライブラリをインストールしています..."
try {
    Set-Location $apiDir
    & ".venv\Scripts\pip.exe" install -r "requirements.txt"
    Write-Host "ライブラリのインストールが完了しました。"
} catch {
    throw "ライブラリのインストール中にエラーが発生しました: $_"
}

# 終了メッセージ
$endMsg = @"
環境構築が完了しました。
別ウィンドウで開かれたターミナルを閉じてください。
"@
Write-Host $endMsg -ForegroundColor Green