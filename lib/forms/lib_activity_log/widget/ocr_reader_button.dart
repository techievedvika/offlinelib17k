import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../components/custom_button.dart';
import '../../../configs/color/color.dart';

class OcrReaderButton extends StatefulWidget {
  final Function(String isbn) onIsbnDetected;
  final Function(bool) onLoading;

  const OcrReaderButton({
    super.key,
    required this.onIsbnDetected,
    required this.onLoading,
  });

  @override
  State<OcrReaderButton> createState() => _OcrReaderButtonState();
}

class _OcrReaderButtonState extends State<OcrReaderButton> {
  final ImagePicker _picker = ImagePicker();

  // Future<void> _processOcr() async {
  //   try {
  //     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
  //     if (image == null) return;
  //
  //     widget.onLoading(true);
  //
  //     final inputImage = InputImage.fromFilePath(image.path);
  //     // final textRecognizer = TextRecognizer();
  //     final textRecognizer = TextRecognizer(
  //       script: TextRecognitionScript.latin,
  //     );
  //     final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
  //
  //     String? isbn = _findISBN(recognizedText.text);
  //
  //     if (isbn != null) {
  //       widget.onIsbnDetected(isbn);
  //     } else {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text("No valid ISBN detected. Please try again."),
  //             backgroundColor: AppColors.error,
  //           ),
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("OCR Error: $e"), backgroundColor: AppColors.error),
  //       );
  //     }
  //   } finally {
  //     widget.onLoading(false);
  //   }
  // }
  Future<void> _processOcr() async {
    try {
      final XFile? image =
      await _picker.pickImage(source: ImageSource.camera);

      if (image == null) return;

      widget.onLoading(true);

      final inputImage = InputImage.fromFilePath(image.path);

      //  IMPORTANT: use default constructor for v0.13.0
      final textRecognizer = TextRecognizer();

      final RecognizedText recognizedText =
      await textRecognizer.processImage(inputImage);

      await textRecognizer.close();

      final text = recognizedText.text;

      final isbn = _findISBN(text);

      if (isbn != null) {
        widget.onIsbnDetected(isbn);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("No valid ISBN detected."),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("OCR Error: $e"),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      widget.onLoading(false);
    }
  }

  String? _findISBN(String text) {
    // Normalization logic from book_issue.dart
    String cleaned = text.replaceAll('\n', ' ');
    cleaned = cleaned.replaceAll('S', '5').replaceAll('O', '0').replaceAll('B', '8');

    final regex = RegExp(
      r'(?:ISBN(?:-1[03])?:?\s*)?((?:\d[-\s]?){9,12}[\dXx])',
      caseSensitive: false,
    );

    final matches = regex.allMatches(cleaned);
    for (var match in matches) {
      String raw = match.group(1)!;
      String isbn = raw.replaceAll(RegExp(r'[-\s]'), '');

      if (isbn.length == 13 && _isValidISBN13(isbn)) return isbn;
      if (isbn.length == 10 && _isValidISBN10(isbn)) return isbn;
    }
    return null;
  }

  bool _isValidISBN13(String isbn) {
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int digit = int.parse(isbn[i]);
      sum += (i % 2 == 0) ? digit : digit * 3;
    }
    int check = (10 - (sum % 10)) % 10;
    return check == int.parse(isbn[12]);
  }

  bool _isValidISBN10(String isbn) {
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += (i + 1) * int.parse(isbn[i]);
    }
    int last = (isbn[9].toUpperCase() == 'X') ? 10 : int.parse(isbn[9]);
    sum += 10 * last;
    return sum % 11 == 0;
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      onPressedButton: _processOcr,
      //icon: Icons.camera_alt,
      title: 'Scan ISBN Digit',
      width: 230,
    );
  }
}