# دليل إعداد Taskaty

هذا الدليل سيساعدك في إعداد مشروع Taskaty مع نظام المصادقة الشامل.

## الخطوة 1: إعداد Firebase

### 1.1 إنشاء مشروع Firebase

1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. انقر على "إنشاء مشروع"
3. أدخل اسم المشروع: `taskaty`
4. اختر "تمكين Google Analytics" (اختياري)
5. انقر على "إنشاء مشروع"

### 1.2 تفعيل Authentication

1. في Firebase Console، اذهب إلى "Authentication"
2. انقر على "Get started"
3. فعّل طرق المصادقة التالية:

#### Email/Password
- انقر على "Email/Password"
- فعّل "Email/Password"
- فعّل "Email link (passwordless sign-in)" (اختياري)

#### Google Sign-In
- انقر على "Google"
- فعّل "Google"
- أدخل اسم المشروع العام
- احفظ التكوين

#### Apple Sign-In (للـ iOS فقط)
- انقر على "Apple"
- فعّل "Apple"
- أدخل Service ID و Team ID
- احفظ التكوين

## الخطوة 2: إعداد Android

### 2.1 إضافة تطبيق Android

1. في Firebase Console، اذهب إلى "Project settings"
2. في قسم "Your apps"، انقر على "Add app"
3. اختر "Android"
4. أدخل:
   - Android package name: `com.example.taskaty`
   - App nickname: `Taskaty Android`
   - Debug signing certificate SHA-1: (اختياري)
5. انقر على "Register app"

### 2.2 تحميل ملف التكوين

1. حمل ملف `google-services.json`
2. ضعه في مجلد `android/app/`

### 2.3 تحديث ملفات التكوين

الملفات محدثة بالفعل في المشروع:
- `android/app/build.gradle.kts`
- `android/build.gradle.kts`

## الخطوة 3: إعداد iOS

### 3.1 إضافة تطبيق iOS

1. في Firebase Console، اذهب إلى "Project settings"
2. في قسم "Your apps"، انقر على "Add app"
3. اختر "iOS"
4. أدخل:
   - iOS bundle ID: `com.example.taskaty`
   - App nickname: `Taskaty iOS`
5. انقر على "Register app"

### 3.2 تحميل ملف التكوين

1. حمل ملف `GoogleService-Info.plist`
2. ضعه في مجلد `ios/Runner/`

### 3.3 تحديث Info.plist

الملف محدث بالفعل في المشروع:
- `ios/Runner/Info.plist`

## الخطوة 4: إعداد Web

### 4.1 إضافة تطبيق Web

1. في Firebase Console، اذهب إلى "Project settings"
2. في قسم "Your apps"، انقر على "Add app"
3. اختر "Web"
4. أدخل:
   - App nickname: `Taskaty Web`
5. انقر على "Register app"

### 4.2 تحديث ملف index.html

الملف محدث بالفعل في المشروع:
- `web/index.html`

## الخطوة 5: تحديث ملفات التكوين

### 5.1 تحديث firebase_options.dart

1. انسخ محتوى `lib/firebase_options.dart.example`
2. استبدل `lib/firebase_options.dart`
3. استبدل القيم بـ القيم الحقيقية من Firebase Console:

```dart
static const FirebaseOptions web = FirebaseOptions(
  apiKey: 'YOUR-ACTUAL-WEB-API-KEY',
  appId: 'YOUR-ACTUAL-WEB-APP-ID',
  messagingSenderId: 'YOUR-ACTUAL-SENDER-ID',
  projectId: 'YOUR-ACTUAL-PROJECT-ID',
  authDomain: 'YOUR-ACTUAL-AUTH-DOMAIN',
  storageBucket: 'YOUR-ACTUAL-STORAGE-BUCKET',
  measurementId: 'YOUR-ACTUAL-MEASUREMENT-ID',
);
```

### 5.2 تحديث google-services.json

1. انسخ محتوى `android/app/google-services.json.example`
2. استبدل `android/app/google-services.json`
3. استبدل القيم بـ القيم الحقيقية من Firebase Console

### 5.3 تحديث GoogleService-Info.plist

1. انسخ محتوى `ios/Runner/GoogleService-Info.plist.example`
2. استبدل `ios/Runner/GoogleService-Info.plist`
3. استبدل القيم بـ القيم الحقيقية من Firebase Console

## الخطوة 6: تثبيت التبعيات

```bash
flutter pub get
```

## الخطوة 7: توليد الكود

```bash
dart run build_runner build --delete-conflicting-outputs
```

## الخطوة 8: تشغيل التطبيق

```bash
flutter run
```

## استكشاف الأخطاء

### مشكلة: "Firebase not initialized"

**الحل**: تأكد من تحديث `firebase_options.dart` بالقيم الصحيحة.

### مشكلة: "Google Sign-In failed"

**الحل**: 
1. تأكد من تفعيل Google Sign-In في Firebase Console
2. تأكد من إضافة SHA-1 fingerprint في Firebase Console
3. تأكد من تحديث `google-services.json`

### مشكلة: "Apple Sign-In failed"

**الحل**:
1. تأكد من تفعيل Apple Sign-In في Firebase Console
2. تأكد من إعداد Apple Developer Account
3. تأكد من تحديث `GoogleService-Info.plist`

### مشكلة: "Build failed"

**الحل**:
1. تأكد من تثبيت جميع التبعيات: `flutter pub get`
2. تأكد من توليد الكود: `dart run build_runner build`
3. تأكد من تحديث جميع ملفات التكوين

## ملاحظات مهمة

1. **الأمان**: لا تشارك ملفات التكوين الحساسة في Git
2. **الإنتاج**: استخدم ملفات تكوين منفصلة للإنتاج
3. **الاختبار**: اختبر جميع طرق المصادقة قبل النشر
4. **التحديثات**: حافظ على تحديث مكتبات Firebase

## الدعم

إذا واجهت أي مشاكل:
1. راجع [Firebase Documentation](https://firebase.google.com/docs)
2. راجع [FlutterFire Documentation](https://firebase.flutter.dev/)
3. افتح issue في GitHub

---

**ملاحظة**: تأكد من إعداد Firebase بشكل صحيح قبل تشغيل التطبيق.
