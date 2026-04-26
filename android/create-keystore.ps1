# سكريبت PowerShell لإنشاء Keystore للتطبيق

Write-Host "🔐 إنشاء Keystore للتطبيق fit90 Gym" -ForegroundColor Cyan
Write-Host ""

# البحث عن keytool
$keytoolPaths = @(
    "$env:LOCALAPPDATA\Android\Sdk\jbr\bin\keytool.exe",
    "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe",
    "C:\Program Files\Java\jdk-*\bin\keytool.exe",
    "$env:JAVA_HOME\bin\keytool.exe"
)

$keytool = $null
foreach ($path in $keytoolPaths) {
    if (Test-Path $path) {
        $keytool = $path
        Write-Host "✅ تم العثور على keytool في: $path" -ForegroundColor Green
        break
    }
}

# إذا لم يتم العثور عليه، ابحث في PATH
if (-not $keytool) {
    $keytoolInPath = Get-Command keytool -ErrorAction SilentlyContinue
    if ($keytoolInPath) {
        $keytool = $keytoolInPath.Source
        Write-Host "✅ تم العثور على keytool في PATH: $keytool" -ForegroundColor Green
    }
}

# إذا لم يتم العثور عليه، اطلب من المستخدم
if (-not $keytool) {
    Write-Host "❌ لم يتم العثور على keytool تلقائياً" -ForegroundColor Red
    Write-Host ""
    Write-Host "الخيارات:" -ForegroundColor Yellow
    Write-Host "1. تثبيت JDK من https://adoptium.net/"
    Write-Host "2. استخدام Android Studio (عادة في: C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe)"
    Write-Host "3. إدخال المسار يدوياً"
    Write-Host ""
    $manualPath = Read-Host "أدخل المسار الكامل لـ keytool.exe (أو اضغط Enter للخروج)"
    
    if ([string]::IsNullOrWhiteSpace($manualPath)) {
        Write-Host "تم الإلغاء" -ForegroundColor Yellow
        exit
    }
    
    if (Test-Path $manualPath) {
        $keytool = $manualPath
    } else {
        Write-Host "❌ المسار غير صحيح" -ForegroundColor Red
        exit
    }
}

Write-Host ""
Write-Host "📝 سيتم إنشاء keystore في: android\app\fit90gym-release-key.jks" -ForegroundColor Cyan
Write-Host ""

# الانتقال إلى مجلد app
$appDir = Join-Path $PSScriptRoot "app"
if (-not (Test-Path $appDir)) {
    Write-Host "❌ مجلد app غير موجود" -ForegroundColor Red
    exit
}

Set-Location $appDir

# إنشاء keystore
Write-Host "سيتم سؤالك عن:" -ForegroundColor Yellow
Write-Host "  - كلمة مرور keystore (احفظها!)"
Write-Host "  - معلومات عن الشركة/المطور"
Write-Host "  - كلمة مرور الـ key"
Write-Host ""

& $keytool -genkey -v -keystore fit90gym-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fit90gym

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ تم إنشاء keystore بنجاح!" -ForegroundColor Green
    Write-Host ""
    Write-Host "الخطوة التالية:" -ForegroundColor Cyan
    Write-Host "1. انسخ key.properties.example إلى key.properties"
    Write-Host "2. عدّل key.properties واملأ كلمات المرور"
    Write-Host ""
    
    # إنشاء key.properties إذا لم يكن موجوداً
    $keyPropsPath = Join-Path $PSScriptRoot "key.properties"
    if (-not (Test-Path $keyPropsPath)) {
        $examplePath = Join-Path $PSScriptRoot "key.properties.example"
        if (Test-Path $examplePath) {
            Copy-Item $examplePath $keyPropsPath
            Write-Host "✅ تم نسخ key.properties.example إلى key.properties" -ForegroundColor Green
            Write-Host "⚠️  تذكر تعديل key.properties وملء كلمات المرور!" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host ""
    Write-Host "❌ فشل إنشاء keystore" -ForegroundColor Red
}

