# Flutter / Dart
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Firebase (Messaging, Crashlytics)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.firebase.**

# Supabase / OkHttp / Gson (used by plugins)
-dontwarn okhttp3.**
-dontwarn okio.**

# Sign in with Apple / passkeys
-keep class com.aboutyou.dart_packages.sign_in_with_apple.** { *; }
-keep class com.corbado.** { *; }

# Keep annotations and generic signatures (needed for reflection-based JSON)
-keepattributes *Annotation*
-keepattributes Signature
-keepattributes InnerClasses
