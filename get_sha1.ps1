# PowerShell script to get SHA-1 fingerprint for Android
# Run this script from the project root directory

Write-Host "Getting SHA-1 fingerprint for Android..." -ForegroundColor Green

# Check if we're in the right directory
if (-not (Test-Path "android")) {
    Write-Host "Error: android directory not found. Please run this script from the project root." -ForegroundColor Red
    exit 1
}

# Change to android directory
Set-Location android

# Run gradle signing report
Write-Host "Running gradle signing report..." -ForegroundColor Yellow
try {
    $output = & ./gradlew signingReport 2>&1
    
    # Look for SHA-1 values
    $sha1Lines = $output | Select-String "SHA1:"
    
    if ($sha1Lines) {
        Write-Host "`nFound SHA-1 fingerprints:" -ForegroundColor Green
        foreach ($line in $sha1Lines) {
            Write-Host $line -ForegroundColor Cyan
        }
        Write-Host "`nUse the SHA-1 value from 'debugAndroidTest' or 'debug' variant for Firebase configuration." -ForegroundColor Yellow
    } else {
        Write-Host "No SHA-1 fingerprints found in the output." -ForegroundColor Red
        Write-Host "Full output:" -ForegroundColor Gray
        Write-Host $output
    }
} catch {
    Write-Host "Error running gradle command: $_" -ForegroundColor Red
    Write-Host "Make sure you have Java and Android SDK installed." -ForegroundColor Yellow
}

# Return to original directory
Set-Location ..
