# Google Sign-In Setup Guide

This guide will help you configure Google Sign-In for your Flutter app.

## Prerequisites

1. A Google Cloud Project
2. Firebase project configured
3. Android/iOS app registered in Firebase

## Step 1: Firebase Configuration

### 1.1 Create/Configure Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing one
3. Add your Android and iOS apps to the project

### 1.2 Download Configuration Files

1. **For Android**: Download `google-services.json` and place it in `android/app/`
2. **For iOS**: Download `GoogleService-Info.plist` and place it in `ios/Runner/`

### 1.3 Generate Firebase Options

Run the following command to generate `firebase_options.dart`:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This will create the `lib/firebase_options.dart` file with your actual configuration.

## Step 2: Google Cloud Console Configuration

### 2.1 Enable Google Sign-In API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Go to "APIs & Services" > "Library"
4. Search for "Google Sign-In API" and enable it

### 2.2 Configure OAuth Consent Screen

1. Go to "APIs & Services" > "OAuth consent screen"
2. Choose "External" user type
3. Fill in the required information:
   - App name
   - User support email
   - Developer contact information
4. Add scopes: `email`, `profile`
5. Add test users if needed

### 2.3 Create OAuth 2.0 Client IDs

#### For Android:
1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth client ID"
3. Choose "Android" as application type
4. Fill in:
   - Package name: `com.example.taskaty`
   - SHA-1 certificate fingerprint (see below for how to get it)

#### For iOS:
1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth client ID"
3. Choose "iOS" as application type
4. Fill in:
   - Bundle ID: `com.example.taskaty`

#### For Web (if needed):
1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth client ID"
3. Choose "Web application" as application type
4. Add authorized origins and redirect URIs

## Step 3: Get SHA-1 Certificate Fingerprint

### For Debug Build:
```bash
cd android
./gradlew signingReport
```

Look for the SHA-1 value under "debugAndroidTest" or "debug" variant.

### For Release Build:
```bash
keytool -list -v -keystore <path-to-your-keystore> -alias <your-key-alias>
```

## Step 4: Update Configuration Files

### 4.1 Update firebase_options.dart

Replace the placeholder values in `lib/firebase_options.dart` with your actual Firebase configuration:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR-ACTUAL-ANDROID-API-KEY',
  appId: 'YOUR-ACTUAL-ANDROID-APP-ID',
  messagingSenderId: 'YOUR-ACTUAL-SENDER-ID',
  projectId: 'YOUR-ACTUAL-PROJECT-ID',
  storageBucket: 'YOUR-ACTUAL-STORAGE-BUCKET',
);
```

### 4.2 Update google-services.json

Replace the placeholder values in `android/app/google-services.json` with your actual values from Firebase.

## Step 5: Firebase Authentication Setup

1. Go to Firebase Console > Authentication
2. Go to "Sign-in method" tab
3. Enable "Google" as a sign-in provider
4. Add your OAuth 2.0 client IDs for each platform
5. Configure authorized domains if needed

## Step 6: Platform-Specific Configuration

### Android Configuration

1. Ensure `google-services.json` is in `android/app/`
2. Verify `build.gradle.kts` has the Google Services plugin:

```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

3. Add dependencies in `android/app/build.gradle.kts`:

```kotlin
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.7.0"))
    implementation("com.google.firebase:firebase-analytics")
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}
```

### iOS Configuration

1. Ensure `GoogleService-Info.plist` is in `ios/Runner/`
2. Add URL schemes to `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>REVERSED_CLIENT_ID</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>YOUR_REVERSED_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

Replace `YOUR_REVERSED_CLIENT_ID` with the value from `GoogleService-Info.plist`.

## Step 7: Testing

1. Clean and rebuild your project:
```bash
flutter clean
flutter pub get
flutter run
```

2. Test Google Sign-In on both debug and release builds

## Common Issues and Solutions

### Issue: "Developer error" or "Invalid client"
- **Solution**: Check that your OAuth client IDs match your package name/bundle ID
- **Solution**: Verify SHA-1 fingerprint is correct and added to Firebase

### Issue: "Network error"
- **Solution**: Check internet connection
- **Solution**: Verify Google Play Services are installed and updated

### Issue: "Sign in failed"
- **Solution**: Check that Google Sign-In API is enabled in Google Cloud Console
- **Solution**: Verify OAuth consent screen is configured properly

### Issue: "Operation not allowed"
- **Solution**: Enable Google Sign-In in Firebase Authentication settings

### Issue: "Popup blocked"
- **Solution**: Allow popups in browser settings
- **Solution**: Check if running in incognito mode

## Security Best Practices

1. **Never commit real API keys to version control**
2. **Use different OAuth client IDs for debug and release builds**
3. **Restrict OAuth consent screen to necessary scopes only**
4. **Regularly rotate API keys**
5. **Monitor authentication logs in Firebase Console**

## Troubleshooting

If you're still having issues:

1. Check Firebase Console logs for authentication errors
2. Verify all configuration files are in the correct locations
3. Ensure all dependencies are up to date
4. Test on a physical device (emulators may have issues with Google Sign-In)
5. Check that your app's package name/bundle ID matches exactly in all configurations

## Support

For additional help:
- [Firebase Documentation](https://firebase.google.com/docs/auth/flutter/google-signin)
- [Google Sign-In Flutter Plugin](https://pub.dev/packages/google_sign_in)
- [Firebase Flutter Plugin](https://pub.dev/packages/firebase_auth)
