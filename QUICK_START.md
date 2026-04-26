# 🚀 دليل سريع لبناء ورفع التطبيق

## ✅ ما تم إنجازه

1. ✅ تحديث معلومات التطبيق:
   - Application ID: `com.fit90gym.app`
   - Version: `1.0.0+1`
   - Name: `F I T 9 0`

2. ✅ إضافة الأذونات المطلوبة في AndroidManifest.xml

3. ✅ إنشاء الأيقونات (flutter_launcher_icons)

4. ✅ إنشاء شاشة البداية (flutter_native_splash)

5. ✅ إعداد ProGuard لتحسين الأداء

6. ✅ إضافة ملف key.properties.example

## 📝 الخطوات التالية

### 1. إنشاء Keystore

```bash
cd android/app
keytool -genkey -v -keystore fit90gym-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fit90gym
```

### 2. إعداد key.properties

```bash
# انسخ الملف المثال
cp android/key.properties.example android/key.properties

# ثم عدّل الملف واملأ القيم
```

### 3. بناء ملف AAB

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

### 4. رفع على Google Play

- اذهب إلى [Google Play Console](https://play.google.com/console)
- أنشئ تطبيق جديد
- ارفع ملف `build/app/outputs/bundle/release/app-release.aab`

## 📚 للمزيد من التفاصيل

راجع ملف `GOOGLE_PLAY_SETUP.md` للحصول على دليل شامل.

