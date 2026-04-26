# 🎯 دليل تحضير تطبيق FIT90 للرفع على Google Play Store

## ✅ ما تم إنجازه

### 1. تحديث الأيقونة (Icon)
- ✓ تم استبدال الأيقونة بـ FIT90 الجديدة
- ✓ تم تحديث `flutter_launcher_icons.yaml` لدعم جميع المنصات
- ✓ تم توليد الأيقونات التالية:
  - Android (Launcher Icons + Adaptive Icons)
  - iOS (App Icons)
  - Web (Web Icons)
  - Windows (App Icons)
  - macOS (App Icons)

### 2. تحديث الإعدادات
- ✓ تصحيح اسم التطبيق على iOS (من "Noamany" إلى "fit90")
- ✓ التحقق من جودة الأيقونة (خالية من قنوات ألفا على iOS)
- ✓ تحديث الألوان والثيمات

## 📋 معلومات التطبيق الحالية

| العنصر | القيمة |
|--------|--------|
| **اسم التطبيق** | fit90 Gym |
| **معرف الحزمة (Bundle ID)** | com.metacodecx.fit90 |
| **الإصدار** | 3.1.0+4 |
| **الحد الأدنى لـ Android** | 21 (Android 5.0) |
| **الهدف لـ Android** | 35 (Android 15) |
| **الحد الأدنى لـ iOS** | 12.0 |

## 🔧 متطلبات البناء والرفع

### 1. المتطلبات الأساسية

```bash
# تحديث Flutter والحصول على الحزم
flutter pub get

# تنظيف المشروع
flutter clean
```

### 2. بناء تطبيق Android AAB (متطلب لـ Google Play)

```bash
# بناء AAB release
flutter build appbundle --release \
  --build-name=3.1.0 \
  --build-number=4
```

**النتيجة:** `build/app/outputs/bundle/release/app-release.aab`

### 3. بناء تطبيق Android APK (اختياري - للاختبار)

```bash
# بناء APK release
flutter build apk --release \
  --build-name=3.1.0 \
  --build-number=4
```

**النتيجة:** `build/app/outputs/apk/release/app-release.apk`

### 4. بناء تطبيق iOS (اختياري)

```bash
# بناء IPA release
flutter build ios --release \
  --build-name=3.1.0 \
  --build-number=4
```

## 📱 خطوات الرفع على Google Play Store

### الخطوة 1: إعداد Google Play Console

1. اذهب إلى [Google Play Console](https://play.google.com/console)
2. سجل دخول باستخدام حسابك
3. انقر على "تطبيق جديد" (New App)
4. أدخل معلومات التطبيق:
   - **الاسم:** fit90 Gym
   - **اللغة الافتراضية:** Arabic (العربية)
   - **النوع:** تطبيق
   - **الفئة:** صحة واللياقة البدنية

### الخطوة 2: إعداد تفاصيل التطبيق

#### أ. معلومات المتجر (Store Listing)
- [ ] العنوان القصير: "fit90 Gym"
- [ ] الوصف المختصر (80 حرف): نطبيق لياقة بدنية متقدم للتدريب والمتابعة
- [ ] الوصف الكامل: اكتب وصفاً شاملاً عن ميزات التطبيق
- [ ] لقطات الشاشة (أقل 4، أقصى 8):
  - الدقة الموصى بها: 1080×1920 بكسل
  - صيغة PNG أو JPEG
- [ ] صورة المميزات:
  - الحجم: 1024×500 بكسل
  - صيغة PNG أو JPEG
- [ ] رمز التطبيق:
  - الحجم: 512×512 بكسل
  - ✓ تم إعداده بالفعل
- [ ] صور الخلفية (اختياري):
  - الحجم: 1024×500 بكسل

#### ب. التصنيف والمحتوى (Content Rating)
- [ ] ملء استبيان التصنيف
- [ ] حدد الفئة العمرية المناسبة

#### ج. الأسعار والتوزيع (Pricing & Distribution)
- [ ] حدد الدول المستهدفة
- [ ] اختر نموذج التسعير (مجاني/مدفوع)
- [ ] وافق على سياسات Google Play

### الخطوة 3: إنشاء أول إصدار

1. اذهب إلى "الإصدارات" (Testing) أو "الإنتاج" (Production)
2. انقر على "إنشاء إصدار" (Create Release)
3. اختر "Google Play App Signing" أو استخدم توقيعك الخاص
4. رفع ملف AAB:
   - اذهب إلى `build/app/outputs/bundle/release/`
   - اختر `app-release.aab`

### الخطوة 4: ملء معلومات الإصدار

- [ ] ملاحظات الإصدار (Release Notes)
- [ ] اختبر الإصدار على الأجهزة الفعلية
- [ ] تأكد من عدم وجود تنبيهات الأمان

### الخطوة 5: الموافقة والنشر

1. اضغط على "مراجعة"
2. تحقق من جميع البيانات
3. اضغط على "نشر" (Publish)

## ⚠️ متطلبات الأمان والخصوصية

تأكد من:

- [ ] **سياسة الخصوصية:**
  - رابط صحيح وسهل الوصول
  - توضح كيفية جمع واستخدام بيانات المستخدمين
  
- [ ] **الأذونات:**
  - تم إعلان جميع الأذونات في `AndroidManifest.xml`
  - كل أذن لها سبب واضح
  
- [ ] **الأمان:**
  - استخدم HTTPS فقط للطلبات الخارجية
  - لا تخزن كلمات المرور بشكل مباشر
  - استخدم Firebase Auth المستخدم بالفعل

## 🔐 إدارة المفاتيح والتوقيع

### معلومات التوقيع الحالية

```properties
keyAlias: {موجود في android/key.properties}
storeFile: {موجود في android/key.properties}
storePassword: {موجود في android/key.properties}
keyPassword: {موجود في android/key.properties}
```

### التحقق من صحة المفتاح

```bash
# عرض بصمة SHA1
keytool -list -v -keystore android/app/keys/upload-keystore.jks
```

## 📊 الأذونات المُعلنة

التطبيق يستخدم الأذونات التالية:

```xml
<!-- الإنترنت والشبكة -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

<!-- الكاميرا -->
<uses-permission android:name="android.permission.CAMERA"/>

<!-- الملفات والصور -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>

<!-- الموقع الجغرافي -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

<!-- الإشعارات -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
```

**ملاحظة:** تأكد من شرح سبب كل أذن في قسم "تصريح الأذونات" في Play Store.

## ✨ ميزات مدعومة

- ✓ Firebase Authentication
- ✓ Firebase Messaging (Push Notifications)
- ✓ اللغات المدعومة: العربية والإنجليزية
- ✓ تصميم ديناميكي (Flutter ScreenUtil)
- ✓ Local Storage (Hive)
- ✓ معالجة الملفات (File Picker)

## 🧪 قبل النشر: قائمة التدقيق الأخيرة

```bash
# 1. تنظيف المشروع
flutter clean

# 2. الحصول على التحديثات
flutter pub get

# 3. تحليل الأخطاء
flutter analyze

# 4. اختبار الأداء
flutter build appbundle --profile \
  --build-name=3.1.0 \
  --build-number=4

# 5. بناء Release النهائي
flutter build appbundle --release \
  --build-name=3.1.0 \
  --build-number=4
```

## 🔍 ملاحظات مهمة

1. **الإصدار الأول:** قد تستغرق الموافقة من Google Play 24-48 ساعة
2. **التحديثات:** يجب زيادة رقم الإصدار (versionCode) في كل تحديث
3. **الاختبار:** اختبر التطبيق على أجهزة حقيقية قبل الرفع
4. **النسخ الاحتياطية:** احفظ المفتاح الخاص بك بأمان
5. **الإحصائيات:** ستتمكن من متابعة التنزيلات والتقييمات من Dashboard

## 📞 دعم إضافي

- [دليل Flutter للنشر](https://docs.flutter.dev/deployment)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [متطلبات Google Play الأساسية](https://play.google.com/about/developer-content-policy/)

---

**آخر تحديث:** 21 أبريل 2026
**الإصدار:** 3.1.0+4
