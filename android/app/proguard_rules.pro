## ML Kit
#-keep class com.google.mlkit.** { *; }
#-dontwarn com.google.mlkit.**
#
## Google Play Services
#-keep class com.google.android.gms.** { *; }
#-dontwarn com.google.android.gms.**
#
## Ignore optional ML Kit language recognizers
#-dontwarn com.google.mlkit.vision.text.chinese.**
#-dontwarn com.google.mlkit.vision.text.devanagari.**
#-dontwarn com.google.mlkit.vision.text.japanese.**
#-dontwarn com.google.mlkit.vision.text.korean.**





# ML Kit Text Recognition - Keep base classes
-keep class com.google.mlkit.vision.text.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text_common.** { *; }

# Ignore the specific missing language libraries and their inner classes ($)
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**

# Specifically ignore the Options and Builders causing the R8 error
-dontwarn com.google.mlkit.vision.text.chinese.ChineseTextRecognizerOptions*
-dontwarn com.google.mlkit.vision.text.devanagari.DevanagariTextRecognizerOptions*
-dontwarn com.google.mlkit.vision.text.japanese.JapaneseTextRecognizerOptions*
-dontwarn com.google.mlkit.vision.text.korean.KoreanTextRecognizerOptions*

# Google Play Services & Tasks
-keep class com.google.android.gms.tasks.** { *; }
-dontwarn com.google.android.gms.tasks.**
-keep class com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.common.**

# Flutter Generic
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.** { *; }

# Flutter Play Store Split / Deferred Component missing classes
-dontwarn com.google.android.play.core.splitcompat.**
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**
