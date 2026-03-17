param(
  [Parameter(Mandatory = $true)]
  [string]$Title,
  [string]$Category = "日常",
  [string[]]$Tags = @("博客"),
  [string]$CoverImage = "/covers/site-cover.jpg",
  [switch]$NoPush,
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function New-Slug {
  param([string]$InputText)
  $slug = $InputText.ToLowerInvariant()
  $slug = [regex]::Replace($slug, "[^a-z0-9\s-]", "")
  $slug = [regex]::Replace($slug, "\s+", "-")
  $slug = [regex]::Replace($slug, "-+", "-")
  $slug = $slug.Trim('-')
  if ([string]::IsNullOrWhiteSpace($slug)) {
    return "post-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
  }
  return $slug
}

$repoRoot = (git rev-parse --show-toplevel).Trim()
if (-not $repoRoot) {
  throw "Not inside a git repository."
}
Set-Location $repoRoot

$slug = New-Slug -InputText $Title
$postPath = Join-Path $repoRoot "content/posts/$slug.md"
if (Test-Path $postPath) {
  throw "Post already exists: $postPath"
}

$offset = (Get-Date).ToString("zzz")
$dateStr = "$(Get-Date -Format 'yyyy-MM-ddTHH:mm:ss')$offset"
$tagsToml = ($Tags | ForEach-Object { '"' + $_ + '"' }) -join ", "

$body = @"
+++
title = "$Title"
date = $dateStr
draft = false
tags = [$tagsToml]
categories = ["$Category"]

[cover]
image = "$CoverImage"
alt = "$Title 封面"
+++

在这里开始写正文。
"@

if ($DryRun) {
  Write-Host "[DryRun] Would create: $postPath"
  Write-Host "[DryRun] Would commit message: 发布：$Title"
  if (-not $NoPush) {
    Write-Host "[DryRun] Would push: origin/main"
  }
  exit 0
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($postPath, $body, $utf8NoBom)

Write-Host "Created: $postPath"

git add $postPath
$commitMsg = "发布：$Title"
git commit -m $commitMsg

if (-not $NoPush) {
  git push origin main
  Write-Host "Pushed to origin/main"
} else {
  Write-Host "Skipped push (--NoPush)."
}

Write-Host "Done."
