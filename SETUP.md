# دليل الإعداد والتشغيل - Setup Guide

## المتطلبات الأساسية

### 1. تثبيت Flutter
```bash
# تحميل Flutter SDK
# https://docs.flutter.dev/get-started/install

# التحقق من التثبيت
flutter doctor
```

### 2. تثبيت الأدوات
- Android Studio أو VS Code
- Android SDK (API 21+)
- محاكي Android أو جهاز حقيقي

## خطوات الإعداد

### 1. استنساخ المشروع
```bash
git clone https://github.com/talal6600/delivery-management-app.git
cd delivery-management-app
```

### 2. تثبيت الحزم
```bash
flutter pub get
```

### 3. توليد ملفات Hive
```bash
# توليد ملفات الـ adapters للنماذج
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. التشغيل على المحاكي/الجهاز
```bash
# عرض الأجهزة المتاحة
flutter devices

# تشغيل التطبيق
flutter run

# أو اختيار جهاز محدد
flutter run -d <device-id>
```

## الإعداد الاختياري

### Firebase (للمزامنة السحابية)

#### 1. إنشاء مشروع Firebase
1. اذهب إلى [Firebase Console](https://console.firebase.google.com/)
2. أنشئ مشروع جديد
3. فعّل Authentication و Firestore

#### 2. Android Setup
```bash
# تحميل google-services.json من Firebase Console
# نسخه إلى: android/app/google-services.json
```

في ملف `android/app/build.gradle`، أضف:
```gradle
dependencies {
    // ...
    classpath 'com.google.gms:google-services:4.3.15'
}
```

وفي نهاية الملف نفسه:
```gradle
apply plugin: 'com.google.gms.google-services'
```

#### 3. iOS Setup
```bash
# تحميل GoogleService-Info.plist من Firebase Console
# نسخه إلى: ios/Runner/GoogleService-Info.plist
```

#### 4. تفعيل Firebase في التطبيق
في ملف `lib/main.dart`، ألغِ التعليق عن:
```dart
// await Firebase.initializeApp();
```

## البناء للإصدار

### Android APK
```bash
flutter build apk --release
# الملف سيكون في: build/app/outputs/flutter-apk/app-release.apk
```

### Android App Bundle (للنشر في Play Store)
```bash
flutter build appbundle --release
# الملف سيكون في: build/app/outputs/bundle/release/app-release.aab
```

### iOS
```bash
flutter build ios --release
# يتطلب macOS و Xcode
```

## المشاكل الشائعة والحلول

### مشكلة: "Hive not initialized"
**الحل**: تأكد من استدعاء `LocalStorageService.init()` في `main.dart`

### مشكلة: "Build runner failed"
```bash
# حذف الملفات المولدة وإعادة البناء
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### مشكلة: "Gradle build failed"
```bash
# في مجلد android
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### مشكلة: "Firebase connection"
- تأكد من ملفات الإعداد في المكان الصحيح
- تحقق من تفعيل الخدمات في Firebase Console
- تأكد من صحة package name في Firebase

## اختبار التطبيق

### 1. تسجيل الدخول
```
اسم المستخدم: admin
كلمة المرور: admin123
```

### 2. السيناريوهات الأساسية
1. تسجيل توصيلات مختلفة
2. مشاهدة الهدف الأسبوعي
3. التنقل بين التواريخ
4. عرض السجل اليومي

## الصيانة

### تحديث الحزم
```bash
flutter pub upgrade
```

### تحديث Flutter
```bash
flutter upgrade
```

### فحص المشاريع
```bash
flutter doctor -v
```

## موارد إضافية

- [Flutter Documentation](https://docs.flutter.dev/)
- [Hive Documentation](https://docs.hivedb.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Documentation](https://pub.dev/packages/provider)

## الدعم

للمساعدة والاستفسارات:
- افتح Issue في GitHub
- راجع ملف DOCUMENTATION.md
- تحقق من README.md

---

تم التحديث: ديسمبر 2024
