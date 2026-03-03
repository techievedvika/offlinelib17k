// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/components/component.dart';
import 'package:lib17000ft/components/custom_appbar.dart';
import 'dart:convert';
import 'package:lib17000ft/forms/book_issue/book_issue_cubit.dart';
import 'package:lib17000ft/forms/book_issue/book_issue_state.dart';
import 'package:lib17000ft/forms/dashboard/dash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/app_urls.dart';

class BookIssue extends StatefulWidget {
  const BookIssue({super.key});

  @override
  State<BookIssue> createState() => _BookIssueState();
}

class _BookIssueState extends State<BookIssue> {
  // Controllers for Student Info
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController studentClassController = TextEditingController();

  // Controllers for Book Info
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController bookTitleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _radioKey = GlobalKey<ResettableRadioState>(); // Key for resetting
  final _idKey = GlobalKey<ResettableRadioState>(); // Key for resetting

  bool isScanning = false;  
  String? userId;
  String? idValue; // Stores the value of the 'For Reading only?' radio button
  String? isbnValue;
  String? userIdValue;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        userId = prefs.getString('userId');
      });
    }
  }

  Future<void> scanStudentQR() async {
    try {
      setState(() => isScanning = true);
      String scannedData = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);

      if (scannedData == '-1' || !mounted) return;

      try {
        Map<String, dynamic> studentDetails = jsonDecode(scannedData);
        if (!studentDetails.containsKey('rollno') || !studentDetails.containsKey('name')) {
          throw const FormatException("Invalid student QR code");
        }
        setState(() {
          studentIdController.text = studentDetails['rollno'] ?? 'ID Not Found';
          studentNameController.text = studentDetails['name'] ?? 'No Name';
          studentClassController.text = studentDetails['class'] ?? 'Unknown';
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Invalid QR Code. Please scan a valid student QR."),
              backgroundColor: AppColors.error),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error during scan: $e")),
      );
    } finally {
      if (mounted) setState(() => isScanning = false);
    }
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

      final bookDetails = await fetchBookDetails(isbn);
      if (mounted) {
        if (bookDetails.isNotEmpty) {
          setState(() {
            bookTitleController.text = bookDetails['title'] ?? 'No Title';
            authorController.text = bookDetails['publisher'] ?? 'No Publisher';
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Book details not found.'),
              backgroundColor: AppColors.primary));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching book details: $e")),
      );
    } finally {
      if (mounted) setState(() => isScanning = false);
    }
  }

  Future<Map<String, String>> fetchBookDetails(String isbn) async {
    //final url = Uri.parse('https://mis.17000ft.org/Library/apis/getBook.php');
    //final url = Uri.parse(AppUrls.getBooksApi);
    final url = Uri.parse(AppUrls.testGetBooksApi);
    try {
      final response = await http.post(url, body: {"isbn": isbn});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['book'] != null && data['book'].isNotEmpty) {
          return {
            'title': data['book'][0]['title'] ?? 'Unknown',
            'author': data['book'][0]['author'] ?? 'Unknown',
            'isbn': data['book'][0]['isbn'].toString(),
            'publisher': data['book'][0]['publisher'] ?? 'Unknown',
            'cover_page': data['book'][0]['cover_page'] ?? '',
          };
        }
        return {}; // Return empty if book not found in response
      } else {
        throw Exception('Failed to fetch book details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching book details: $e');
    }
  }

  void resetForm() {
    _formKey.currentState?.reset();
    studentIdController.clear();
    studentNameController.clear();
    studentClassController.clear();
    isbnController.clear();
    bookTitleController.clear();
    authorController.clear();
    _radioKey.currentState?.resetSelection();
    _idKey.currentState?.resetSelection();
    setState(() {
      idValue = null;
      userIdValue = null;
      isbnValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _showExitConfirmationDialog(context),
      child: Scaffold(
        appBar: const CustomAppbar(title: 'Book Issue', backbutton: true),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: SafeArea(
            child:SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabelText(label: 'Scan Student QR'),
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
                      validator: (value) => value == null || value.isEmpty ? 'Please scan a student QR code.' : null,
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Student Name'),
                    const SizedBox(height: 10),
                    CustomTextFormField(textController: studentNameController, readOnly: true),
                    const SizedBox(height: 10),
                    LabelText(label: 'Student Grade'),
                    const SizedBox(height: 10),
                    CustomTextFormField(textController: studentClassController, readOnly: true),
                    const SizedBox(height: 20),


                    LabelText(label: 'Scan Book Barcode'),
                    // ElevatedButton.icon(
                    //   onPressed: isScanning ? null : scanISBN,
                    //   icon: const Icon(Icons.qr_code_scanner),
                    //   label: const Text('Scan Book ISBN'),
                    // ),
                    ///This is to match UI design
                    CustomButton(
                      onPressedButton: isScanning ? null : scanISBN,
                      icon: Icons.barcode_reader,
                      title: 'Scan ISBN',
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Book ISBN'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textController: isbnController,
                      readOnly: true,
                      validator: (value) => value == null || value.isEmpty ? 'Please scan a book ISBN.' : null,
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Book Title'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textController: bookTitleController,
                      readOnly: false,
                      validator: (value) => value == 'NA' || value!.isEmpty ? 'Please enter book name.' : null,
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Book Publisher'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textController: authorController,
                      readOnly: authorController.text == 'NA' ? false : true,
                    ),


                    const SizedBox(height: 20),
                    LabelText(label: 'For Reading only?', astrick: true),
                    const SizedBox(height: 10),
                    ResettableRadio(
                      key: _idKey,
                      options: const ['Yes', 'No'],
                      onChanged: (value) => setState(() => idValue = value),
                      validator: (value) => idValue == null ? 'Please select an option.' : null,
                    ),
                    const SizedBox(height: 20),

                    BlocConsumer<BookIssueCubit, BookIssueState>(
                      listener: (context, state) async {
                        if (state is BookIssueSuccess) {
                          // Show snackbar ONLY on the initial "Issued" success
                          if (state.status == 'Issued') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message), backgroundColor: AppColors.primary),
                            );
                            // Refresh dashboard data
                            context.read<DashCubit>().dashData(adminId: userId!);

                            // If "reading only", initiate the delayed return.
                            // Otherwise, just reset the form for a normal issue.
                            if (idValue == 'Yes') {
                              await _initiateDelayedReturn(context);
                            } else {
                              resetForm();
                            }
                          } else if (state.status == 'Returned') {
                            // After the "Returned" call succeeds, reset the form.
                            resetForm();
                          }
                        } else if (state is BookIssueFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
                          );
                        }
                      },
                      builder: (context, state) {
                        if (state is BookIssueLoading) {
                          return const Center(
                            child: CircularProgressIndicator(backgroundColor: AppColors.primary),
                          );
                        }
                        return SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            onPressedButton: () {
                              if (_formKey.currentState!.validate()) {
                                // Store values to ensure they persist for the delayed call
                                userIdValue = studentIdController.text;
                                isbnValue = isbnController.text;

                                final bookIssuePayload = {
                                  'student_id': userIdValue,
                                  'isbn': isbnValue,
                                  'created_by': userId,
                                  'status': 'Issued',
                                  'publisher': authorController.text,
                                  'title': bookTitleController.text,
                                };
                                // Always call with 'Issued' first
                                context.read<BookIssueCubit>().bookIssue(bookIssuePayload, 'Issued');
                              }
                            },
                            title: "Issue Book",
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

  /// Initiates a delayed book return for "Reading only"
  Future<void> _initiateDelayedReturn(BuildContext context) async {
    // Wait for a short duration
    await Future.delayed(const Duration(seconds: 1));

    // Check if the widget is still mounted before proceeding
    if (mounted) {
      final bookReturnPayload = {
        'student_id': userIdValue,
        'isbn': isbnValue,
        'created_by': userId,
        'title': bookTitleController.text,
        'status': 'Returned',
      };
      // Pass 'Returned' to distinguish this call
      context.read<BookIssueCubit>().bookIssue(bookReturnPayload, 'Returned');
    }
  }

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
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
