import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../../components/custom_button.dart';
import '../../components/custom_image_picker.dart';
import '../../components/custom_labeltext.dart';
import '../../components/custom_textField.dart';
import '../../components/info_dialog.dart';
import '../../configs/color/color.dart';
import '../book_issue/book_issue_cubit.dart';
import '../book_issue/book_issue_state.dart';
import '../lib_activity_log/widget/ocr_reader_button.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({super.key});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController isbnController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController publisherController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController coverPageController = TextEditingController();
  final TextEditingController codeController = TextEditingController();

  bool isScanning = false;
  File? bookImage;

  @override
  void dispose() {
    isbnController.dispose();
    titleController.dispose();
    publisherController.dispose();
    authorController.dispose();
    languageController.dispose();
    genreController.dispose();
    levelController.dispose();
    coverPageController.dispose();
    codeController.dispose();

    super.dispose();
  }

  void insertBook() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bookData = {
      "isbn": isbnController.text.trim(),
      "title": titleController.text.trim(),
      "publisher": publisherController.text.trim(),
      "author": authorController.text.trim(),
      "language": languageController.text.trim(),
      "gener": genreController.text.trim(),
      "level": levelController.text.trim(),
      "cover_page": coverPageController.text.trim(),
      "code": codeController.text.trim(),
    };

    debugPrint("Book Data: $bookData");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Book data ready to insert"),
      ),
    );
  }

  Future<void> scanISBN() async {
    try {
      setState(() => isScanning = true);
      String isbn = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      if (isbn == '-1' || !mounted) return;

      if (!(RegExp(r'^\d{10}$').hasMatch(isbn) || (RegExp(r'^97[89]\d{10}$').hasMatch(isbn)))) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Invalid ISBN scanned. Please scan a valid ISBN.'),
            backgroundColor: AppColors.error));
        return;
      }
      isbnController.text = isbn;

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching book details: $e")),
      );
    } finally {
      if (mounted) setState(() => isScanning = false);
    }
  }


  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: requiredField
            ? (value) {
          if (value == null || value.trim().isEmpty) {
            return "$label is required";
          }
          return null;
        }
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Book"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  CustomButton(
                    onPressedButton: isScanning ? null : scanISBN,
                    //icon: Icons.barcode_reader,
                    title: 'Scan ISBN Barcode',
                    width: size.width * 0.6,
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: AppColors.tertiary),
                    onPressed: (){
                      ImageDialog.show(
                        context,
                        imagePath: 'assets/barcode.png',
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: size.height* 0.03,child:  LabelText(label: 'OR')),

              Row(
                children: [
                  OcrReaderButton(
                    onLoading: (loading) {
                      setState(() {isScanning = loading;
                      });
                    },
                    onIsbnDetected: (isbn) async { // Make this callback async
                      setState(() {
                        isbnController.text = isbn;
                      });

                      if (isbn.isEmpty) return;

                      setState(() => isScanning = true); // Visual feedback
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.info_outline, color: AppColors.tertiary),
                    onPressed: (){
                      ImageDialog.show(
                        context,
                        imagePath: 'assets/digit.png',
                      );
                    },
                  ),
                ],
              ),
              // if(isbnController.text.isEmpty)
              // SizedBox(height: size.height* 0.03,child:  LabelText(label: 'OR')),
              LabelText(label: 'ISBN'),
              const SizedBox(height: 10),
              CustomTextFormField(
                textController: isbnController,
                hintText: "Enter ISBN Manually",
                readOnly: false,
                validator: (value) => value == null || value.isEmpty ? 'Please scan a book ISBN.' : null,
                suffixIcon: IconButton(
                  onPressed: isScanning ? null : () async {
                    if (isbnController.text.isEmpty) return;

                    setState(() => isScanning = true); // Visual feedback
                  },
                  icon: isScanning
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.search, color: AppColors.primary),
                ),
              ),

              const SizedBox(height: 10),

              LabelText(label: 'Title'),
              const SizedBox(height: 10),
              CustomTextFormField(
                textController: titleController,
                hintText: "Enter Title",
                readOnly: false,
                validator: (value) => value == null || value.isEmpty ? 'Please Enter Title.' : null,
              ),

              const SizedBox(height: 10),

              LabelText(label: 'Publisher'),
              const SizedBox(height: 10),
              CustomTextFormField(
                textController: publisherController,
                hintText: "Enter Publisher",
                readOnly: false,
                validator: (value) => value == null || value.isEmpty ? 'Please Enter Publisher.' : null,
              ),

              const SizedBox(height: 10),

              LabelText(label: 'Author'),
              const SizedBox(height: 10),
              CustomTextFormField(
                textController: authorController,
                hintText: "Enter Author",
                readOnly: false,
                validator: (value) => value == null || value.isEmpty ? 'Please Enter Author.' : null,
              ),

              const SizedBox(height: 10),

              LabelText(label: 'Language'),
              const SizedBox(height: 10),
              CustomTextFormField(
                textController: languageController,
                hintText: "Enter Language",
                readOnly: false,
                validator: (value) => value == null || value.isEmpty ? 'Please Enter Language.' : null,
              ),

              const SizedBox(height: 10),

              LabelText(label: 'Genre'),
              const SizedBox(height: 10),
              CustomTextFormField(
                textController: genreController,
                hintText: "Enter Genre",
                readOnly: false,
                validator: (value) => value == null || value.isEmpty ? 'Please Enter Genre.' : null,
              ),

              const SizedBox(height: 10),

              LabelText(label: 'Level'),
              const SizedBox(height: 10),
              CustomTextFormField(
                textController: levelController,
                hintText: "Enter Level",
                readOnly: false,
                validator: (value) => value == null || value.isEmpty ? 'Please Enter Level.' : null,
              ),

              const SizedBox(height: 10),
              LabelText(label: 'Book Cover Image'),
              const SizedBox(height: 10),

              CustomImagePicker(
                onChanged: (File? file) {
                  setState(() {
                    bookImage = file;
                  });
                },
                validator: (value) => value == null ? "Please capture book image" : null,
              ),

              // buildTextField(
              //   label: "Code",
              //   controller: codeController,
              // ),

              const SizedBox(height: 10),

              BlocConsumer<BookIssueCubit, BookIssueState>(
                listener: (context, state) {
                  if (state is BookIssueSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.message,
                          style: const TextStyle(
                            color: AppColors.tertiary,
                          ),
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                    );

                    // Clear the form after successful insertion
                    isbnController.clear();
                    titleController.clear();
                    publisherController.clear();
                    authorController.clear();
                    languageController.clear();
                    genreController.clear();
                    levelController.clear();
                    codeController.clear();
                    coverPageController.clear();

                    setState(() {
                      bookImage = null;
                    });
                  } else if (state is BookIssueFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is BookIssueLoading) {
                    return const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: CustomButton(
                      onPressedButton: () {
                        if (_formKey.currentState!.validate()) {
                          final bookAddPayload = {
                            'isbn': isbnController.text.trim(),
                            'author': authorController.text.trim(),
                            'gener': genreController.text.trim(),
                            'publisher': publisherController.text.trim(),
                            'title': titleController.text.trim(),
                            'level': levelController.text.trim(),
                            'language': languageController.text.trim(),
                            'cover_page': bookImage?.path ?? '',
                            'code': 'NA',
                          };

                          debugPrint('Book Add Payload: $bookAddPayload');

                          context.read<BookIssueCubit>().insertBook(

                            bookAddPayload,
                          );
                        }
                      },
                      title: "Add Book",
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}