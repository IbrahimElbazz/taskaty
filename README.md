# Taskaty - نظام إدارة المهام

تطبيق Flutter لإدارة المهام مع نظام مصادقة شامل يدعم تسجيل الدخول والتسجيل باستخدام البريد الإلكتروني وكلمة المرور، بالإضافة إلى تسجيل الدخول باستخدام Google و Apple.

## المميزات

- ✅ **نظام مصادقة شامل** مع Firebase Authentication
- ✅ **تسجيل الدخول والتسجيل** بالبريد الإلكتروني وكلمة المرور
- ✅ **تسجيل الدخول الاجتماعي** مع Google و Apple
- ✅ **إعادة تعيين كلمة المرور** عبر البريد الإلكتروني
- ✅ **إدارة الحالة** باستخدام Cubit و Freezed
- ✅ **Dependency Injection** باستخدام GetIt و Injectable
- ✅ **Code Generation** مع json_serializable و freezed
- ✅ **واجهة مستخدم جميلة وحديثة** باللغة العربية
- ✅ **تصميم متجاوب** باستخدام flutter_screenutil

## التقنيات المستخدمة

### State Management
- **flutter_bloc**: لإدارة الحالة
- **cubit**: نمط مبسط من BLoC
- **freezed**: لتوليد الكود للـ data classes

### Dependency Injection
- **get_it**: Service locator
- **injectable**: Code generation للـ DI

### Authentication
- **firebase_auth**: مصادقة Firebase
- **google_sign_in**: تسجيل الدخول بـ Google
- **sign_in_with_apple**: تسجيل الدخول بـ Apple

### Code Generation
- **json_serializable**: لتوليد JSON serialization
- **freezed**: لتوليد immutable classes
- **build_runner**: لتشغيل code generators

### UI/UX
- **flutter_screenutil**: للتصميم المتجاوب
- **easy_localization**: للترجمة (جاهز للاستخدام)

## إعداد المشروع

### 1. متطلبات النظام
- Flutter SDK 3.8.1 أو أحدث
- Dart SDK 3.8.1 أو أحدث
- Android Studio / VS Code
- Git

### 2. تثبيت التبعيات
```bash
flutter pub get
```

### 3. إعداد Firebase

#### أ. إنشاء مشروع Firebase
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. أنشئ مشروع جديد
3. فعّل Authentication
4. فعّل طرق المصادقة التالية:
   - Email/Password
   - Google Sign-In
   - Apple Sign-In (للـ iOS)

#### ب. إعداد Android
1. أضف تطبيق Android في Firebase Console
2. حمل ملف `google-services.json`
3. ضعه في `android/app/`
4. أضف التبعيات في `android/app/build.gradle.kts`:
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```
5. أضف في `android/build.gradle.kts`:
```kotlin
dependencies {
    classpath("com.google.gms:google-services:4.4.0")
}
```

#### ج. إعداد iOS
1. أضف تطبيق iOS في Firebase Console
2. حمل ملف `GoogleService-Info.plist`
3. ضعه في `ios/Runner/`
4. أضف في `ios/Runner/Info.plist`:
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

### 4. توليد الكود
```bash
dart run build_runner build --delete-conflicting-outputs
```

### 5. تشغيل التطبيق
```bash
flutter run
```

## بنية المشروع

```
lib/
├── core/
│   ├── app_config.dart          # إعدادات التطبيق
│   ├── constants.dart           # الثوابت
│   ├── translations.dart        # الترجمات
│   └── di/
│       └── injection.dart       # Dependency Injection
├── features/
│   ├── authentication/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── cubit/
│   │       │   ├── auth_cubit.dart
│   │       │   └── auth_states.dart
│   │       └── screens/
│   │           ├── auth_wrapper.dart
│   │           ├── login_screen.dart
│   │           ├── register_screen.dart
│   │           └── forgot_password_screen.dart
│   └── home/
│       └── presentation/
│           └── screens/
│               └── home_screen.dart
└── shared/
    ├── utils/
    │   └── app_utils.dart
    └── widgets/
        ├── custom_button.dart
        └── custom_text_field.dart
```

## الاستخدام

### تسجيل الدخول
- يمكن للمستخدمين تسجيل الدخول باستخدام البريد الإلكتروني وكلمة المرور
- أو باستخدام حسابات Google أو Apple

### إنشاء حساب جديد
- يمكن للمستخدمين إنشاء حساب جديد بالبريد الإلكتروني وكلمة المرور
- أو استخدام حسابات Google أو Apple

### نسيان كلمة المرور
- يمكن للمستخدمين طلب إعادة تعيين كلمة المرور عبر البريد الإلكتروني

### تسجيل الخروج
- يمكن للمستخدمين تسجيل الخروج من خلال القائمة في الشاشة الرئيسية

## الملفات المهمة

### النماذج (Models)
- `user_model.dart`: نموذج المستخدم مع freezed و json_serializable

### إدارة الحالة (State Management)
- `auth_states.dart`: حالات المصادقة باستخدام freezed
- `auth_cubit.dart`: منطق إدارة حالة المصادقة

### Repository
- `auth_repository.dart`: طبقة الوصول للبيانات مع Firebase

### الشاشات (Screens)
- `auth_wrapper.dart`: التحكم في عرض شاشات المصادقة
- `login_screen.dart`: شاشة تسجيل الدخول
- `register_screen.dart`: شاشة إنشاء حساب جديد
- `forgot_password_screen.dart`: شاشة نسيان كلمة المرور
- `home_screen.dart`: الشاشة الرئيسية مع معلومات المستخدم

## التخصيص

### تغيير الألوان
يمكنك تخصيص الألوان في `lib/core/app_config.dart`:

```dart
class AppConfig {
  static const Color primaryColor = Colors.blue;
  static const Color secondaryColor = Colors.blueAccent;
  // ...
}
```

### إضافة لغات جديدة
يمكنك إضافة لغات جديدة في `assets/lang/` وتحديث `lib/core/translations.dart`.

### إضافة طرق مصادقة جديدة
يمكنك إضافة طرق مصادقة جديدة في `auth_repository.dart` و `auth_cubit.dart`.

## المساهمة

نرحب بالمساهمات! يرجى اتباع الخطوات التالية:

1. Fork المشروع
2. أنشئ branch جديد (`git checkout -b feature/amazing-feature`)
3. Commit التغييرات (`git commit -m 'Add some amazing feature'`)
4. Push إلى Branch (`git push origin feature/amazing-feature`)
5. افتح Pull Request

## الترخيص

هذا المشروع مرخص تحت رخصة MIT - انظر ملف [LICENSE](LICENSE) للتفاصيل.

## الدعم

إذا واجهت أي مشاكل أو لديك أسئلة، يرجى فتح issue في GitHub أو التواصل معنا.

---

**ملاحظة**: تأكد من إعداد Firebase بشكل صحيح قبل تشغيل التطبيق.
