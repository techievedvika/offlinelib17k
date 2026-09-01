// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/components/component.dart';
import 'package:lib17000ft/components/custom_appbar.dart';
import 'dart:convert';
import 'package:lib17000ft/forms/book_issue/book_issue_cubit.dart';
import 'package:lib17000ft/forms/book_issue/book_issue_state.dart';
import 'package:lib17000ft/forms/dashboard/dash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/custom_image_picker.dart';
import '../../components/info_dialog.dart';
import '../../components/school_tag.dart';
import '../../configs/app_urls.dart';
import '../../models/student_registration/student_model.dart';
import '../lib_activity_log/widget/ocr_reader_button.dart';

class BookIssue extends StatefulWidget {
  final String? student;
  const BookIssue({super.key, this.student});

  @override
  State<BookIssue> createState() => _BookIssueState();
}

class _BookIssueState extends State<BookIssue> {
  // Controllers for Student Info
  final TextEditingController studentIdController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController studentClassController = TextEditingController();

  // Controllers for Book Info
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController bookTitleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController languageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _radioKey = GlobalKey<ResettableRadioState>(); // Key for resetting
  final _idKey = GlobalKey<ResettableRadioState>(); // Key for resetting

  bool isScanning = false;  
  String? userId;
  String? libSchool;
  String? idValue; // Stores the value of the 'For Reading only?' radio button
  String? growValue; // Stores the value of the 'G-R-O-W level' radio button
  String? isbnValue;
  String? userIdValue;
  bool bookInDb = true;

  File? bookImage;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    print("Student Details: ${widget.student}");
    populateStudentFields(widget.student);
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        userId = prefs.getString('userId');
        libSchool = prefs.getString('school');
      });
    }
  }

  // Future<void> scanStudentQR() async {
  //   try {
  //     setState(() => isScanning = true);
  //     String scannedData = await FlutterBarcodeScanner.scanBarcode(
  //         '#ff6666', 'Cancel', true, ScanMode.QR);
  //
  //     if (scannedData == '-1' || !mounted) return;
  //
  //     try {
  //       Map<String, dynamic> studentDetails = jsonDecode(scannedData);
  //
  //       if (studentDetails['id'] == null) {
  //         throw const FormatException("Invalid QR: Missing ID");
  //       }
  //
  //       setState(() {
  //         idController.text = studentDetails['id']?.toString() ?? '';
  //         studentNameController.text = studentDetails['name']?.toString() ?? '';
  //         studentClassController.text = studentDetails['class']?.toString() ?? '';
  //         studentIdController.text = studentDetails['rollno']?.toString() ?? '';
  //       });
  //
  //
  //       final List<StudentModel> students = await context
  //           .read<BookIssueCubit>()
  //           .fetchStudentByRollno(studentIdController.text);
  //
  //       if (students.isEmpty) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text("Student not found in database. Please check Roll No."),
  //             backgroundColor: AppColors.error,
  //           ),
  //         );
  //         return;
  //       }
  //
  //       print('Student School: ${students.first.school}');
  //
  //       if(students.first.school != libSchool){
  //         await showDialog(
  //           context: context,
  //           barrierDismissible: false,
  //           builder: (context) => Dialog(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(20),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Container(
  //                         width: 40,
  //                         height: 40,
  //                         decoration: const BoxDecoration(
  //                           color: AppColors.primary,
  //                           shape: BoxShape.circle,
  //                         ),
  //                         child: const Icon(
  //                           Icons.warning_amber_rounded,
  //                           color: AppColors.onPrimary,
  //                           size: 22,
  //                         ),
  //                       ),
  //                       const SizedBox(width: 12),
  //                       const Expanded(
  //                         child: Text(
  //                           'Different school detected',
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   const SizedBox(height: 20),
  //                   Text(
  //                     'This student belongs to',
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.grey.shade600,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 6),
  //                   SchoolTag(
  //                     name: students.first.school,
  //                     accentColor: AppColors.onPrimary,
  //                   ),
  //                   const SizedBox(height: 12),
  //                   Text(
  //                     'Please scan a student from',
  //                     style: TextStyle(
  //                       fontSize: 13,
  //                       color: Colors.grey.shade600,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 6),
  //                   SchoolTag(
  //                     name: libSchool,
  //                     accentColor: AppColors.onPrimary,
  //                   ),
  //                   const SizedBox(height: 24),
  //                   Align(
  //                     alignment: Alignment.centerRight,
  //                     child: FilledButton(
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         resetForm();
  //                       },
  //                       style: FilledButton.styleFrom(
  //                         backgroundColor: AppColors.primary,
  //                         padding: const EdgeInsets.symmetric(
  //                           horizontal: 28,
  //                           vertical: 12,
  //                         ),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(10),
  //                         ),
  //                       ),
  //                       child: const Text('Got it',style: TextStyle(color: AppColors.onPrimary,fontWeight: FontWeight.bold)),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //         return;
  //       }
  //
  //     } on FormatException {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text("Invalid QR Code format."),
  //             backgroundColor: AppColors.error),
  //       );
  //     } catch (e) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text("Error: ${e.toString()}"), backgroundColor: AppColors.error),
  //       );
  //     }
  //   } finally {
  //     if (mounted) setState(() => isScanning = false);
  //   }
  // }

  void populateStudentFields(String? studentData) {
    if (studentData == null || studentData.isEmpty) return;

    try {
      // Decode the JSON string into a Map
      final Map<String, dynamic> studentDetails = jsonDecode(studentData);

      setState(() {

        studentIdController.text = studentDetails['rollno']?.toString() ?? '';

        studentNameController.text = studentDetails['name']?.toString() ?? '';

        studentClassController.text = studentDetails['class']?.toString() ?? '';

        idController.text = studentDetails['id']?.toString() ?? '';
      });
    } catch (e) {
      debugPrint("Error parsing student data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to parse student information")),
      );
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
            languageController.text = bookDetails['language'] ?? 'Unknown';
            growValue = bookDetails['level'];
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
    final url = Uri.parse(AppUrls.getBookApi);
    //final url = Uri.parse(AppUrls.testGetBooksApi);
    try {
      final response = await http.post(url, body: {"isbn": isbn});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Book detail = $data");
        if (data['book'] != null && data['book'].isNotEmpty) {

          if(data['book'][0]['title'] == 'Unknown'){
            if(mounted){
              setState(() {
                bookInDb = false;
              });
            }
          } else{
            if(mounted){
              setState(() {
                bookInDb = true;
              });
            }
          }

          return {
            'title': data['book'][0]['title'] ?? 'Unknown',
            'author': data['book'][0]['author'] ?? 'Unknown',
            'isbn': data['book'][0]['isbn'].toString(),
            'publisher': data['book'][0]['publisher'] ?? 'Unknown',
            'level': data['book'][0]['level'] ?? '',
            'language': data['book'][0]['language'] ?? 'Unknown',
            'cover_page': data['book'][0]['cover_page'] ?? '',
          };
        }
        // if(data['book'][0]['title'] == 'Unknown'){
        //   setState(() {
        //     bookInDb = false;
        //   });
        // }
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
    languageController.clear();
    _radioKey.currentState?.resetSelection();
    _idKey.currentState?.resetSelection();
    setState(() {
      idValue = null;
      userIdValue = null;
      growValue = null;
      isbnValue = null;
      //bookInDb = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                    // LabelText(label: 'Scan Student QR'),
                    // // ElevatedButton.icon(
                    // //   onPressed: isScanning ? null : scanStudentQR,
                    // //   icon: const Icon(Icons.qr_code_scanner),
                    // //   label: const Text('Scan Student QR Code'),
                    // // ),
                    // ///This is to match UI design
                    // CustomButton(
                    //   onPressedButton: isScanning ? null : scanStudentQR,
                    //   icon: Icons.qr_code_scanner,
                    //   title: 'Scan QR',
                    // ),
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


                    // LabelText(label: 'Scan Book Barcode'),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     CustomButton(
                    //       onPressedButton: isScanning ? null : scanISBN,
                    //       icon: Icons.barcode_reader,
                    //       title: 'Scan ISBN',
                    //     ),
                    //     SizedBox(width: size.width* 0.01),
                    //     CustomButton(
                    //       onPressedButton : isScanning ? null : () async {
                    //
                    //         final image = await captureImage();
                    //
                    //         if (image != null) {
                    //           final isbn = await extractISBN(image.path);
                    //
                    //           if (isbn != null) {
                    //             isbnController.text = isbn;
                    //             print("ISBN Found: $isbn");
                    //           } else {
                    //             print("No ISBN detected");
                    //           }
                    //         }
                    //
                    //         if (isbnController.text.isEmpty) return;
                    //
                    //         setState(() => isScanning = true); // Visual feedback
                    //         try {
                    //           final bookDetails = await fetchBookDetails(isbnController.text);
                    //           if (mounted) {
                    //             if (bookDetails.isNotEmpty && bookDetails['title'] != 'NA') {
                    //               setState(() {
                    //                 bookTitleController.text = bookDetails['title'] ?? 'No Title';
                    //                 // Use 'author' if 'publisher' is empty
                    //                 authorController.text = bookDetails['publisher'] ?? bookDetails['author'] ?? 'No Publisher';
                    //                 growValue = bookDetails['level'];
                    //               });
                    //               print('Book Details: $bookDetails');
                    //               print('Book level: $growValue');
                    //             } else {
                    //               setState(() {
                    //                 bookTitleController.text = bookDetails['title'] ?? 'No Title';
                    //                 // Use 'author' if 'publisher' is empty
                    //                 authorController.text = bookDetails['publisher'] ?? bookDetails['author'] ?? 'No Publisher';
                    //                 growValue = bookDetails['level'];
                    //               });
                    //               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    //                   content: Text('Book details not found.'),
                    //                   backgroundColor: AppColors.primary));
                    //             }
                    //           }
                    //         } catch (e) {
                    //           ScaffoldMessenger.of(context).showSnackBar(
                    //             SnackBar(content: Text("Search failed: $e")),
                    //           );
                    //         } finally {
                    //           if (mounted) setState(() => isScanning = false);
                    //         }
                    //       },
                    //       // onPressedButton: () async{
                    //       //   final image = await captureImage();
                    //       //
                    //       //   if (image != null) {
                    //       //     final isbn = await extractISBN(image.path);
                    //       //
                    //       //     if (isbn != null) {
                    //       //       print("ISBN Found: $isbn");
                    //       //     } else {
                    //       //       print("No ISBN detected");
                    //       //     }
                    //       //   }
                    //       // },
                    //       icon: Icons.barcode_reader,
                    //       title: 'Scan ISBN',
                    //     ),
                    //   ],
                    // ),
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
                            try {
                              final bookDetails = await fetchBookDetails(isbn);
                              if (mounted) {
                                if (bookDetails.isNotEmpty && bookDetails['title'] != 'NA') {
                                  setState(() {
                                    bookTitleController.text = bookDetails['title'] ?? 'No Title';
                                    // Use 'author' if 'publisher' is empty
                                    authorController.text = bookDetails['publisher'] ?? bookDetails['author'] ?? 'No Publisher';
                                    languageController.text = bookDetails['language'] ?? 'Unknown';
                                    growValue = bookDetails['level'];
                                  });
                                  print('Book Details: $bookDetails');
                                } else {
                                  setState(() {
                                    bookTitleController.text = bookDetails['title'] ?? 'No Title';
                                    authorController.text = bookDetails['publisher'] ?? bookDetails['author'] ?? 'No Publisher';
                                    languageController.text = bookDetails['language'] ?? 'Unknown';
                                    growValue = bookDetails['level'];
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                      content: Text('Book details not found.'),
                                      backgroundColor: AppColors.primary));
                                }
                              }
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Search failed: $e")),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => isScanning = false);
                            }
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
                          try {
                            final bookDetails = await fetchBookDetails(isbnController.text);
                            if (mounted) {
                              if (bookDetails.isNotEmpty && bookDetails['title'] != 'NA') {
                                setState(() {
                                  bookTitleController.text = bookDetails['title'] ?? 'No Title';
                                  // Use 'author' if 'publisher' is empty
                                  authorController.text = bookDetails['publisher'] ?? bookDetails['author'] ?? 'No Publisher';
                                  languageController.text = bookDetails['language'] ?? 'Unknown';
                                  growValue = bookDetails['level'];
                                });
                                print('Book Details: $bookDetails');
                                print('Book level: $growValue');
                              } else {
                                setState(() {
                                  bookTitleController.text = bookDetails['title'] ?? 'No Title';
                                  // Use 'author' if 'publisher' is empty
                                  authorController.text = bookDetails['publisher'] ?? bookDetails['author'] ?? 'No Publisher';
                                  languageController.text = bookDetails['language'] ?? 'Unknown';
                                  growValue = bookDetails['level'];
                                });
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text('Book details not found.'),
                                    backgroundColor: AppColors.primary));
                              }
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Search failed: $e",style: const TextStyle(color: AppColors.tertiary))),
                            );
                          } finally {
                            if (mounted) setState(() => isScanning = false);
                          }
                        },
                        icon: isScanning
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.search, color: AppColors.primary),
                      ),
                    ),
                    if(bookInDb != true)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          LabelText(label: 'Book Cover Image', astrick: true),
                          const SizedBox(height: 10),
                          // CustomImagePicker(
                          //   // validator: (value) => value == null ? 'Please capture an image of the book Cover Page' : null,
                          //   // onSaved: (value) => bookImage = value,
                          //   validator: (value) => (bookTitleController.text == 'Unknown' && value == null)
                          //       ? 'Please capture an image of the book Cover Page'
                          //       : null,
                          //   onSaved: (value) => bookImage = value,
                          //   // If your CustomImagePicker supports it, you can pass a controller or handle change
                          //   onChanged: (file) => setState(() => bookImage = file),
                          // ),
                          CustomImagePicker(
                            onChanged: (File? file) {
                              setState(() {
                                bookImage = file;
                              });
                            },
                            validator: (value) => value == null ? "Please capture book image" : null,
                          ),
                        ],
                      ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Book Title', astrick: true),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      textController: bookTitleController,
                      readOnly: false,
                      validator: (value) => value == 'Unknown' || value!.isEmpty ? 'Please enter book name.' : null,
                    ),

                    const SizedBox(height: 10),
                    LabelText(label: 'Book Language', astrick: true),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      //hintText: languageController.text,
                      textController: languageController,
                      readOnly: false,
                      validator: (value) => value == 'Unknown' || value!.isEmpty ? 'Please enter book language.' : null,
                    ),
                    const SizedBox(height: 10),
                    LabelText(label: 'Book Publisher'),
                    const SizedBox(height: 10),
                    CustomTextFormField(
                      //hintText: authorController.text,
                      textController: authorController,
                      readOnly: authorController.text != 'Unknown' ? false : true,
                    ),



                    const SizedBox(height: 20),
                    LabelText(label: 'G-R-O-W level ', astrick: true),
                    ResettableRadio(
                      key: _radioKey,
                      selectedOption: growValue,
                        options: const ['Green', 'Red', 'Orange','White', 'Other'],
                      layout: RadioLayout.grid,
                      gridCount: 3,
                      onChanged: (value) => setState(() => growValue = value),
                      validator: (value) => growValue == null ? 'Please select an option.' : null,
                      isEnabled: growValue == null || growValue!.isEmpty,
                    ),


                    const SizedBox(height: 20),
                    LabelText(label: 'Book issued for?', astrick: true),
                    const SizedBox(height: 10),
                    ResettableRadio(
                      key: _idKey,
                      options: const ['Home', 'School'],
                      layout: RadioLayout.grid,
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
                              SnackBar(content: Text(state.message,style: const TextStyle(color: AppColors.tertiary),), backgroundColor: AppColors.primary),
                            );
                            // Refresh dashboard data
                            context.read<DashCubit>().dashData(adminId: userId!);

                            // If "reading only", initiate the delayed return.
                            // Otherwise, just reset the form for a normal issue.
                            if (idValue == 'School') {
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
                                // Save the form data
                                //_formKey.currentState!.save();

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
                                  'level' : growValue,
                                  'language' : languageController.text,
                                  'cover_page' : bookImage?.path ?? '',
                                };
                                // Always call with 'Issued' first
                                context.read<BookIssueCubit>().bookIssueReturn(bookIssuePayload, 'Issued');
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
        'language' : languageController.text,
        'status': 'Returned',
        'level' : growValue,
      };
      // Pass 'Returned' to distinguish this call
      context.read<BookIssueCubit>().bookIssueReturn(bookReturnPayload, 'Returned');
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
