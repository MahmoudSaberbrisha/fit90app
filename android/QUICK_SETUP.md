# ⚡ إعداد سريع لـ Keystore

## الطريقة السريعة (موصى بها)

### 1. تشغيل السكريبت

```powershell
# من مجلد android
cd android
.\create-keystore.ps1
```

السكريبت سيقوم بـ:
- البحث عن keytool تلقائياً
- إنشاء keystore
- نسخ key.properties.example إلى key.properties

### 2. تعديل key.properties

افتح `android/key.properties` واملأ:
```properties
storeFile=app/fit90gym-release-key.jks
keyAlias=fit90gym
storePassword=كلمة_المرور_التي_أدخلتها
keyPassword=كلمة_المرور_التي_أدخلتها
```

## الطريقة اليدوية

### 1. العثور على keytool

```powershell
# جرب هذه المسارات:
$env:LOCALAPPDATA\Android\Sdk\jbr\bin\keytool.exe
C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe
```

### 2. إنشاء keystore

```powershell
cd android\app
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore fit90gym-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fit90gym
```

### 3. إنشاء key.properties

```powershell
cd ..
Copy-Item key.properties.example key.properties
# ثم عدّل key.properties
```

## التحقق من الإعداد

```powershell
cd fit90_gym_main
flutter build appbundle --release
```

إذا كان كل شيء صحيحاً، سيتم بناء ملف AAB بنجاح.

