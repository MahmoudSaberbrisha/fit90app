# 🔐 دليل إنشاء Keystore للتطبيق

## المشكلة: keytool غير معروف

`keytool` يأتي مع JDK (Java Development Kit). إذا لم يكن في PATH، استخدم المسار الكامل.

## الحلول

### الحل 1: استخدام keytool من Flutter SDK

عادة Flutter SDK يحتوي على JDK. جرب:

```powershell
# ابحث عن keytool في Flutter SDK
$flutterPath = flutter doctor -v | Select-String "Flutter SDK" | ForEach-Object { $_.Line.Split(" ")[-1] }
$jdkPath = Join-Path $flutterPath "jre\bin\keytool.exe"

# إذا وجدت، استخدمه
& $jdkPath -genkey -v -keystore app\fit90gym-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fit90gym
```

### الحل 2: استخدام keytool من Android Studio

```powershell
# عادة في:
$keytoolPath = "$env:LOCALAPPDATA\Android\Sdk\jbr\bin\keytool.exe"

# أو
$keytoolPath = "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"

# استخدمه
& $keytoolPath -genkey -v -keystore app\fit90gym-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fit90gym
```

### الحل 3: تثبيت JDK

1. حمّل JDK من [Oracle](https://www.oracle.com/java/technologies/downloads/) أو [Adoptium](https://adoptium.net/)
2. ثبت JDK
3. أضف JDK إلى PATH:
   ```powershell
   # أضف إلى PATH:
   # C:\Program Files\Java\jdk-XX\bin
   ```

### الحل 4: استخدام Java المثبت مسبقاً

```powershell
# ابحث عن Java
where.exe java

# ثم استخدم keytool من نفس المجلد
# مثلاً إذا كان Java في: C:\Program Files\Java\jdk-17\bin\java.exe
# فـ keytool سيكون في: C:\Program Files\Java\jdk-17\bin\keytool.exe
```

## إنشاء Keystore

بعد العثور على keytool:

```powershell
# انتقل إلى مجلد android/app
cd android\app

# استخدم keytool (استبدل المسار بالمسار الصحيح)
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -genkey -v -keystore fit90gym-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fit90gym
```

ستحتاج إلى إدخال:
- كلمة مرور keystore (احفظها!)
- معلومات عن الشركة/المطور
- كلمة مرور الـ key (يمكن أن تكون نفس كلمة مرور keystore)

## إعداد key.properties

```powershell
# من مجلد android
cd ..

# انسخ الملف المثال
Copy-Item key.properties.example key.properties

# ثم عدّل الملف واملأ القيم:
# storeFile=app\fit90gym-release-key.jks
# keyAlias=fit90gym
# storePassword=كلمة_المرور_التي_أدخلتها
# keyPassword=كلمة_المرور_التي_أدخلتها
```

## نصيحة: استخدام Flutter لإنشاء Keystore

يمكنك أيضاً استخدام Flutter مباشرة:

```powershell
cd fit90_gym_main
flutter build appbundle --release
```

إذا لم يكن keystore موجوداً، Flutter سيسألك عن إنشاء واحد جديد.

