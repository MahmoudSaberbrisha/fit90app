# Script to kill processes that might be locking build files
# Run this if you get "Unable to delete directory" errors

Write-Host "Killing processes that might lock build files..." -ForegroundColor Cyan
Write-Host ""

# Kill Java processes (Gradle uses Java)
$javaProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue
if ($javaProcesses) {
    Write-Host "Found Java processes, killing them..." -ForegroundColor Yellow
    $javaProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "   Done: Java processes killed" -ForegroundColor Green
} else {
    Write-Host "   No Java processes found" -ForegroundColor Green
}

# Kill Gradle daemon processes
$gradleProcesses = Get-Process | Where-Object { $_.ProcessName -like "*gradle*" -or $_.CommandLine -like "*gradle*" } -ErrorAction SilentlyContinue
if ($gradleProcesses) {
    Write-Host "Found Gradle processes, killing them..." -ForegroundColor Yellow
    $gradleProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "   Done: Gradle processes killed" -ForegroundColor Green
} else {
    Write-Host "   No Gradle processes found" -ForegroundColor Green
}

# Kill Flutter processes
$flutterProcesses = Get-Process -Name "flutter" -ErrorAction SilentlyContinue
if ($flutterProcesses) {
    Write-Host "Found Flutter processes, killing them..." -ForegroundColor Yellow
    $flutterProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "   Done: Flutter processes killed" -ForegroundColor Green
} else {
    Write-Host "   No Flutter processes found" -ForegroundColor Green
}

# Kill Dart processes
$dartProcesses = Get-Process -Name "dart" -ErrorAction SilentlyContinue
if ($dartProcesses) {
    Write-Host "Found Dart processes, killing them..." -ForegroundColor Yellow
    $dartProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Host "   Done: Dart processes killed" -ForegroundColor Green
} else {
    Write-Host "   No Dart processes found" -ForegroundColor Green
}

Write-Host ""
Write-Host "Done! Processes killed." -ForegroundColor Green
Write-Host ""
Write-Host "Now try:" -ForegroundColor Cyan
Write-Host "  flutter clean" -ForegroundColor White
Write-Host "  flutter pub get" -ForegroundColor White
Write-Host "  flutter run" -ForegroundColor White
Write-Host ""

