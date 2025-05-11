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