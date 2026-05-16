# setup_flutter_project.ps1
# Use this script from the repository root to create a Flutter app folder
# and move the existing loose Dart files into a proper lib/ directory.

$projectName = 'khela_hobe_app'
$root = Get-Location
$projectRoot = Join-Path $root $projectName
$libFolder = Join-Path $projectRoot 'lib'

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
    Write-Error 'Flutter is not installed or not on PATH. Install Flutter and try again.'
    exit 1
}

if (-not (Test-Path $projectRoot)) {
    Write-Host "Creating Flutter project folder $projectName..."
    flutter create $projectName
} else {
    Write-Host "Flutter project folder already exists: $projectName"
}

if (-not (Test-Path $libFolder)) {
    Write-Host 'Creating lib directory...'
    New-Item -ItemType Directory -Path $libFolder | Out-Null
}

Write-Host 'Moving Dart source files into lib/ ...'
Get-ChildItem -Path $root -Filter '*.dart' | ForEach-Object {
    $destination = Join-Path $libFolder $_.Name
    Move-Item -Path $_.FullName -Destination $destination -Force
}

$originalMain = Join-Path $libFolder 'flutter_main.dart'
$targetMain = Join-Path $libFolder 'main.dart'
if (Test-Path $originalMain) {
    Write-Host 'Renaming flutter_main.dart to main.dart...'
    Move-Item -Path $originalMain -Destination $targetMain -Force
}

Write-Host 'Done!'
Write-Host "Review imports in $projectName/lib if any file paths changed."
Write-Host "Then run:"
Write-Host "  cd $projectName"
Write-Host '  flutter pub get'
Write-Host '  flutter build apk --release'
