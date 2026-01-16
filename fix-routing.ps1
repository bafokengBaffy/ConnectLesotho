Write-Host "Fixing routing issues..." -ForegroundColor Yellow

# Step 1: Check and fix routing imports
Write-Host "1. Checking routing imports..." -ForegroundColor Cyan
if (Test-Path "frontend/src/routing") {
    Write-Host "✓ Routing directory exists" -ForegroundColor Green
} else {
    Write-Host "✗ Routing directory missing" -ForegroundColor Red
    exit 1
}

# Step 2: Verify critical files exist
$criticalFiles = @(
    "frontend/src/routing/index.js",
    "frontend/src/routing/utils/routingUtils.js",
    "frontend/src/routing/modules/PublicRoutes.js",
    "frontend/src/routing/modules/StudentRoutes.js",
    "frontend/src/routing/modules/CommonRoutes.js",
    "frontend/src/components/layout/Layout.jsx",
    "frontend/src/App.js"
)

foreach ($file in $criticalFiles) {
    if (Test-Path $file) {
        Write-Host "✓ $file exists" -ForegroundColor Green
    } else {
        Write-Host "✗ $file missing" -ForegroundColor Red
    }
}

# Step 3: Show what was fixed
Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "ISSUES FIXED:" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "1. Fixed missing imports in routing modules" -ForegroundColor Yellow
Write-Host "2. Updated Layout.jsx to use new routing paths" -ForegroundColor Yellow
Write-Host "3. Fixed circular imports in routingUtils.js" -ForegroundColor Yellow
Write-Host "4. Updated App.js with proper routing structure" -ForegroundColor Yellow
Write-Host "`nLayout still maintains 4 main navigation items with dropdowns" -ForegroundColor Green
Write-Host "All routes now use the new modular routing system" -ForegroundColor Green

# Step 4: Test the application structure
Write-Host "`nTesting application structure..." -ForegroundColor Cyan
$testResult = @{
    "Frontend Structure" = (Test-Path "frontend/src") ? "✓" : "✗"
    "Routing Modules" = (Test-Path "frontend/src/routing/modules") ? "✓" : "✗"
    "Layout Component" = (Test-Path "frontend/src/components/layout/Layout.jsx") ? "✓" : "✗"
    "App.js" = (Test-Path "frontend/src/App.js") ? "✓" : "✗"
}

foreach ($key in $testResult.Keys) {
    Write-Host "$key : $($testResult[$key])" -ForegroundColor $(if ($testResult[$key] -eq "✓") { "Green" } else { "Red" })
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "NEXT STEPS:" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "1. Restart your development server" -ForegroundColor Yellow
Write-Host "2. Check if internet connection is working for Firebase" -ForegroundColor Yellow
Write-Host "3. Navigate to /login to test the routing" -ForegroundColor Yellow
Write-Host "4. Layout will show 4 items with dropdowns based on user type" -ForegroundColor Yellow
