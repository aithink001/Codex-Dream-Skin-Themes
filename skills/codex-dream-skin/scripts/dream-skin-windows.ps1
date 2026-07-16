[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('source', 'install', 'start', 'start-authorized', 'verify', 'restore', 'restore-authorized', 'recover-config', 'uninstall', 'test')]
  [string]$Action,
  [int]$Port = 9335,
  [string]$ScreenshotPath,
  [switch]$NoShortcuts,
  [string]$ProfilePath,
  [switch]$ForegroundInjector,
  [switch]$NoRelaunch
)

$ErrorActionPreference = 'Stop'
$UpstreamRepository = 'https://github.com/Fei-Away/Codex-Dream-Skin.git'
$UpstreamCommit = '26c6c410e0e0bfc053356474620e17f934f483fc'
$CacheParent = if ($env:CODEX_DREAM_SKIN_CACHE_DIR) {
  $env:CODEX_DREAM_SKIN_CACHE_DIR
} else {
  Join-Path $env:LOCALAPPDATA 'CodexDreamSkinSkill'
}
$SourceRoot = Join-Path $CacheParent "source-$UpstreamCommit"

function Invoke-GitChecked {
  param([Parameter(ValueFromRemainingArguments = $true)][string[]]$Arguments)
  & git @Arguments
  if ($LASTEXITCODE -ne 0) { throw "git failed with exit code $LASTEXITCODE" }
}

function Initialize-PinnedSource {
  if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw 'git is required to download the pinned runtime.'
  }
  New-Item -ItemType Directory -Force -Path $CacheParent | Out-Null
  if (-not (Test-Path -LiteralPath $SourceRoot)) {
    Invoke-GitChecked -Arguments @('clone', '--filter=blob:none', '--no-checkout', $UpstreamRepository, $SourceRoot)
  }
  if (-not (Test-Path -LiteralPath (Join-Path $SourceRoot '.git'))) {
    throw "Cache path exists but is not a Git repository: $SourceRoot"
  }
  $origin = (& git -C $SourceRoot remote get-url origin).Trim()
  if ($LASTEXITCODE -ne 0 -or $origin -cne $UpstreamRepository) {
    throw "Cached runtime has an unexpected origin: $origin"
  }
  & git -C $SourceRoot cat-file -e "$UpstreamCommit`^{commit}" 2>$null
  if ($LASTEXITCODE -ne 0) {
    Invoke-GitChecked -Arguments @('-C', $SourceRoot, 'fetch', '--depth', '1', 'origin', $UpstreamCommit)
  }
  Invoke-GitChecked -Arguments @('-C', $SourceRoot, 'checkout', '--quiet', '--detach', $UpstreamCommit)
  $actual = (& git -C $SourceRoot rev-parse HEAD).Trim()
  if ($LASTEXITCODE -ne 0 -or $actual -cne $UpstreamCommit) {
    throw "Runtime commit verification failed: $actual"
  }
}

function Invoke-RuntimeScript {
  param([string]$Name, [object[]]$Arguments = @())
  $script = Join-Path $SourceRoot "windows\scripts\$Name"
  if (-not (Test-Path -LiteralPath $script)) { throw "Runtime script is missing: $script" }
  & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $script @Arguments
  if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Initialize-PinnedSource

switch ($Action) {
  'source' {
    Write-Host "Pinned Codex Dream Skin runtime ready: $UpstreamCommit"
  }
  'install' {
    $arguments = @('-Port', $Port)
    if ($NoShortcuts) { $arguments += '-NoShortcuts' }
    Invoke-RuntimeScript 'install-dream-skin.ps1' $arguments
  }
  'start' {
    $arguments = @('-Port', $Port, '-PromptRestart')
    if ($ProfilePath) { $arguments += @('-ProfilePath', $ProfilePath) }
    if ($ForegroundInjector) { $arguments += '-ForegroundInjector' }
    Invoke-RuntimeScript 'start-dream-skin.ps1' $arguments
  }
  'start-authorized' {
    $arguments = @('-Port', $Port, '-RestartExisting')
    if ($ProfilePath) { $arguments += @('-ProfilePath', $ProfilePath) }
    if ($ForegroundInjector) { $arguments += '-ForegroundInjector' }
    Invoke-RuntimeScript 'start-dream-skin.ps1' $arguments
  }
  'verify' {
    $arguments = @('-Port', $Port)
    if ($ScreenshotPath) { $arguments += @('-ScreenshotPath', $ScreenshotPath) }
    Invoke-RuntimeScript 'verify-dream-skin.ps1' $arguments
  }
  'restore' {
    $arguments = @('-Port', $Port, '-RestoreBaseTheme', '-PromptRestart')
    if ($NoRelaunch) { $arguments += '-NoRelaunch' }
    Invoke-RuntimeScript 'restore-dream-skin.ps1' $arguments
  }
  'restore-authorized' {
    $arguments = @('-Port', $Port, '-RestoreBaseTheme', '-ForceRestart')
    if ($NoRelaunch) { $arguments += '-NoRelaunch' }
    Invoke-RuntimeScript 'restore-dream-skin.ps1' $arguments
  }
  'recover-config' {
    $arguments = @('-Port', $Port, '-RecoverConfigBackup', '-PromptRestart')
    if ($NoRelaunch) { $arguments += '-NoRelaunch' }
    Invoke-RuntimeScript 'restore-dream-skin.ps1' $arguments
  }
  'uninstall' {
    $arguments = @('-Port', $Port, '-RestoreBaseTheme', '-PromptRestart', '-Uninstall')
    if ($NoRelaunch) { $arguments += '-NoRelaunch' }
    Invoke-RuntimeScript 'restore-dream-skin.ps1' $arguments
  }
  'test' {
    $testScript = Join-Path $SourceRoot 'windows\tests\run-tests.ps1'
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $testScript
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  }
}
