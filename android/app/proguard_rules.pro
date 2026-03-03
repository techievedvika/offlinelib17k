# Keep Retrofit interfaces
-keep interface * { *; }

# Keep model classes used in JSON parsing
-keep class org.ft17000.lib17000ft.model.** { *; }

# Keep annotations
-keepattributes *Annotation*

# Keep Dio (if used via Flutter plugin)
-keep class * extends dio.** { *; }