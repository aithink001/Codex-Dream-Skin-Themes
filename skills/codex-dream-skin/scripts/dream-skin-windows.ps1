[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)]
  [ValidateSet('source', 'install', 'start', 'verify', 'restore', 'uninstall', 'test')]
  [string]$Action,
  [int]$Port = 9335,
  [string]$ScreenshotPath
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
    Invoke-RuntimeScript 'install-dream-skin.ps1' @('-Port', $Port)
  }
  'start' {
    Invoke-RuntimeScript 'start-dream-skin.ps1' @('-Port', $Port, '-PromptRestart')
  }
  'verify' {
    $arguments = @('-Port', $Port)
    if ($ScreenshotPath) { $arguments += @('-ScreenshotPath', $ScreenshotPath) }
    Invoke-RuntimeScript 'verify-dream-skin.ps1' $arguments
  }
  'restore' {
    Invoke-RuntimeScript 'restore-dream-skin.ps1' @('-Port', $Port, '-RestoreBaseTheme', '-PromptRestart')
  }
  'uninstall' {
    Invoke-RuntimeScript 'restore-dream-skin.ps1' @('-Port', $Port, '-RestoreBaseTheme', '-PromptRestart', '-Uninstall')
  }
  'test' {
    $testScript = Join-Path $SourceRoot 'windows\tests\run-tests.ps1'
    & powershell.exe -NoProfile -ExecutionPolicy Bypass -File $testScript
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
  }
}
