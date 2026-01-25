# Release shrinker(R8/ProGuard) 대응
# - flutter_local_notifications 내부에서 Gson TypeToken 제네릭 시그니처가 필요합니다.

# Keep generic signatures (TypeToken needs this)
-keepattributes Signature,*Annotation*,InnerClasses,EnclosingMethod

# flutter_local_notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Gson (used internally by some plugins)
-dontwarn com.google.gson.**
-keep class com.google.gson.** { *; }
-keep class com.google.gson.reflect.TypeToken { *; }

# Keep any TypeToken subclasses (their generic supertype signature must survive)
-keep class * extends com.google.gson.reflect.TypeToken { *; }

# Be conservative: avoid optimizing away generic signature usage
-dontoptimize
