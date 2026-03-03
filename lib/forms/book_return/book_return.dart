// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/components/component.dart';
import 'package:lib17000ft/components/custom_appbar.dart';
import 'dart:convert';
import 'package:lib17000ft/components/custom_textField.dart';
import 'package:lib17000ft/forms/book_issue/book_issue_cubit.dart';
import 'package:lib17000ft/forms/book_issue/book_issue_state.dart';
import 'package:lib17000ft/forms/dashboard/dash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/app_urls.dart';

class BookReturn extends StatefulWidget {
  const BookReturn({super.key});

  @override
  State<BookReturn> createState() => _BookReturnState();
}

class _BookReturnState extends State<BookReturn> {
  // Controllers for Student Info
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController studentClassController = TextEditingController();

  // Controllers for Book Info
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController bookTitleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isScanning = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> scanStudentQR() async {
    try {
      setState(() => isScanning = true);

      String scannedData = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      if (scannedData == '-1' || !mounted) {
        // User canceled scan or widget is no longer in the tree
        return;
      }

      try {
        Map<String, dynamic> studentDetails = jsonDecode(scannedData);

        if (!studentDetails.containsKey('rollno') ||
            !studentDetails.containsKey('name')) {
          throw const FormatException("Invalid student QR code");
        }

        setState(() {
          studentIdController.text = studentDetails['rollno'] ?? 'ID Not Found';
          studentNameController.text = studentDetails['name'] ?? 'No Name';
          studentClassController.text = studentDetails['class'] ?? 'Unknown';
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Invalid QR Code scanned. Please scan a valid student QR."),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching student details: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isScanning = false);
      }
    }
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        userId = prefs.getString('userId');
      });
    }
    print("this is the user id $userId");
  }

  /// Scan Book ISBN and Fetch Details
  Future<void> scanISBN() async {
    try {
      setState(() => isScanning = true);

      String isbn = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      if (isbn == '-1' || !mounted) {
        // User canceled the scan
        return;
      }

      // Validate if ISBN is either 10 or 13 digits and starts with 978 or 979 (for ISBN-13)
      if (!(RegExp(r'^\d{10}$').hasMatch(isbn) ||
          (RegExp(r'^97[89]\d{10}$').hasMatch(isbn)))) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid ISBN scanned. Please scan a valid ISBN.'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      // Assign scanned ISBN to the text field
      isbnController.text = isbn;

      // Fetch book details
      final bookDetails = await fetchBookDetails(isbn);

      if (!mounted) return;

      if (bookDetails.isNotEmpty) {
        setState(() {
          bookTitleController.text = bookDetails['title'] ?? 'No Title';
          authorController.text = bookDetails['publisher'] ?? 'No Publisher';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book details not found. Please try another ISBN.'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching book details: $e")),
      );
    } finally {
      if (mounted) {
        setState(() => isScanning = false);
      }
    }
  }

  /// Fetch Book Details from Server
  Future<Map<String, String>> fetchBookDetails(String isbn) async {
    //final url = Uri.parse('https://mis.17000ft.org/Library/apis/getBook.php');


    //final url = Uri.parse(AppUrls.getBooksApi);
    final url = Uri.parse(AppUrls.testGetBooksApi);

    try {
      final response = await http.post(
        url,
        body: {
          "isbn": isbn,
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['book'] != null && data['book'].isNotEmpty) {
          return {
            'title': data['book'][0]['title'] ?? 'Unknown',
            'author': data['book'][0]['author'] ?? 'Unknown',
            'isbn': data['book'][0]['isbn']
                .toString(), // Convert ISBN to String (if needed)
            'publisher': data['book'][0]['publisher'] ?? 'Unknown',
            'cover_page': data['book'][0]['cover_page'] ??
                '', // Add cover image URL if needed
          };
        }
        return {}; // Return empty if book array is null or empty
      } else {
        throw Exception('Failed to fetch book details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching book details: $e');
    }
  }

  /// Function to reset form fields
  void resetForm() {
    studentIdController.clear();
    studentNameController.clear();
    studentClassController.clear();
    isbnController.clear();
    bookTitleController.clear();
    authorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _showExitConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: const CustomAppbar(
          title: 'Book Return',
          backbutton: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(label: 'Scan Student QR'),
                    // Student QR Code Scan Section
                    // ElevatedButton.icon(
                    //   onPressed: isScanning ? null : scanStudentQR,
                    //   icon: const Icon(Icons.qr_code_scanner),
                    //   label: const Text('Scan Student QR Code'),
                    // ),
                    ///This is to match UI design
                    CustomButton(
                      onPressedButton: isScanning ? null : scanStudentQR,
                      icon: Icons.qr_code_scanner,
                      title: 'Scan QR',
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Student Id'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textController: studentIdController,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please scan a student QR code.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Student Name'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textController: studentNameController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Student Grade'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textController: studentClassController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    LabelText(label: 'Scan Book Barcode'),

                    // // Book ISBN Scan Section
                    // ElevatedButton.icon(
                    //   onPressed: isScanning ? null : scanISBN,
                    //   icon: const Icon(Icons.qr_code_scanner),
                    //   label: const Text('Scan Book ISBN'),
                    // ),
                    ///This is to match UI design
                    CustomButton(
                      onPressedButton: isScanning ? null : scanISBN,
                      icon: Icons.qr_code_scanner,
                      title: 'Scan ISBN',
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Book ISBN'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textController: isbnController,
                      readOnly: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please scan a book ISBN.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Book Title'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textController: bookTitleController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Book Author'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textController: authorController,
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),

                    BlocConsumer<BookIssueCubit, BookIssueState>(
                      listener: (context, state) {
                        if (state is BookIssueSuccess) {
                          if (state.status == 'Returned') {
                            context.read<DashCubit>().dashData(adminId: userId!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                            resetForm();
                          }
                        }
                        if (state is BookIssueFailure) {
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
                          return const Center(
                            child: CircularProgressIndicator(
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onPressedButton: () {
                              if (_formKey.currentState!.validate()) {
                                final dynamic bookIssue = {
                                  'student_id': studentIdController.text,
                                  'isbn': isbnController.text,
                                  'created_by': userId,
                                  'title': bookTitleController.text,
                                  'status': 'Returned'
                                };
                                //  CORRECTED LINE
                                context
                                    .read<BookIssueCubit>()
                                    .bookIssue(bookIssue, 'Returned');
                              }
                            },
                            title: "Return Book",
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // student registration
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you want to Exit?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false if user cancels
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if user confirms
              },
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
