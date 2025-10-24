# Add project specific ProGuard rules here

# Keep missing classes that cause R8 errors
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
-dontwarn com.itgsa.opensdk.mediaunit.**
-dontwarn java.beans.**
-dontwarn org.w3c.dom.bootstrap.**

# Fix Kotlin compatibility issues
-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-keep class org.jetbrains.** { *; }

# Keep plugin implementations
-keep class com.ryanheise.** { *; }
-keep class io.flutter.plugins.** { *; }

# Agora RTC plugin rules
-keep class io.agora.** { *; }
-dontwarn io.agora.**
-keep class io.agora.agora_rtc_ng.** { *; }
-dontwarn io.agora.agora_rtc_ng.**

# Keep Agora RTC plugin registration
-keep class io.agora.agora_rtc_ng.AgoraRtcNgPlugin { *; }

# General Flutter plugin rules
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Flutter engine classes
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.view.** { *; }

# Google Play Core rules for split install and deferred components
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Flutter deferred components
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }
-dontwarn io.flutter.embedding.engine.deferredcomponents.**

# Keep Play Store split functionality
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }

# Flutter Play Store Split Application
-keep class io.flutter.embedding.android.FlutterPlayStoreSplitApplication { *; }

# Google Play Services
-keep class com.google.android.gms.** { *; }
-dontwarn com.google.android.gms.**

# Firebase (if used)
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Additional Flutter plugin protection
-keep class io.flutter.plugins.firebase.** { *; }
-keep class io.flutter.plugins.google.** { *; }

# Keep all classes with native methods
-keepclasseswithmembernames,includedescriptorclasses class * {
    native <methods>;
}

# Keep serialization classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    !static !transient <fields>;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}