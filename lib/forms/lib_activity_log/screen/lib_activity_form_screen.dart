import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/forms/lib_activity_log/submit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/custom_button.dart';
import '../../../components/custom_labeltext.dart';
import '../../../components/custom_textField.dart';
import '../../../components/info_dialog.dart';
import '../../../configs/app_urls.dart';
import '../../../configs/color/color.dart';
import '../../../configs/helper/responsive_helper.dart';
import '../../../models/book/book_model.dart';

import '../activity_name.dart';
import '../book_scanner_section.dart';
import '../conducted_by.dart';
import '../description.dart';
import '../grade_selection.dart';
import '../total_participants.dart';
import '../upload_activity_img.dart';
import '../widget/ocr_reader_button.dart';

class LibActivityFormScreen extends StatelessWidget {
  const LibActivityFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LibActivityFormView();
  }
}

class LibActivityFormView extends StatefulWidget {
  const LibActivityFormView({super.key});

  @override
  State<LibActivityFormView> createState() => _LibActivityFormViewState();
}

class _LibActivityFormViewState extends State<LibActivityFormView> {
  // Local state to control the visibility of the loading overlay.
  bool _isSubmitting = false;

  void _setSubmitting(bool isSubmitting) {
    if (mounted) {
      setState(() {
        _isSubmitting = isSubmitting;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Log New Activity',
        backbutton: true,
      ),
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // The form now takes a callback to control the parent's state.
          LibActivityForm(setSubmitting: _setSubmitting),
          // Loading overlay controlled by local state.
          if (_isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }
}

class LibActivityForm extends StatefulWidget {
  // Callback to update the loading state in the parent widget.
  final Function(bool) setSubmitting;
  const LibActivityForm({super.key, required this.setSubmitting});

  @override
  State<LibActivityForm> createState() => _LibActivityFormState();
}

class _LibActivityFormState extends State<LibActivityForm> {
  final _formKey = GlobalKey<FormState>();

  // --- All state previously in BLoC is now managed here ---
  String? _userId;
  String? _school;
  DateTime? _selectedDate;
  List<File> selectedImages = [];
  String _activityName = '';
  String _description = '';
  List<Book> _books = [];
  List<String> _participatingGrades = [];
  String _totalParticipants = '';
  List<GradeParticipant> _gradeParticipants = [];
  String _conductedBy = '';
  List<String> _availableGrades = [];
  bool _isLoadingGrades = true;

  final TextEditingController _isbnController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadUserData();
    await _fetchGrades();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _userId = prefs.getString('userId');
        _school = prefs.getString('school');
      });
    }
  }

  Future<void> _fetchGrades() async {
    if (mounted) {
      setState(() => _isLoadingGrades = true);
    }
    try {
      final response = await http.post(Uri.parse(AppUrls.getGradeApi));
      print("Grade API Response: ${response.body}");
      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data['error'] == false) {
          List<dynamic> messageList = data['message'];
          setState(() {
            _availableGrades = messageList.map((item) => item.toString()).toList();

            _gradeParticipants = _availableGrades.map((g) => GradeParticipant(grade: g)).toList();
          });
        } else {
          throw Exception('Failed to load grades: Invalid data format');
        }
      } else {
        throw Exception('Server error while fetching grades');
      }
    } catch (e) {
      if (mounted) {
        print("Error fetching grades: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching grades: $e"), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingGrades = false);
      }
    }
  }

  Future<void> _scanISBN() async {
    try {
      String isbn = await FlutterBarcodeScanner.scanBarcode('#981B1E', 'Cancel', true, ScanMode.BARCODE);
      if (isbn == '-1' || !mounted) return;

      widget.setSubmitting(true);
      final bookDetails = await _fetchBookDetails(isbn);
      widget.setSubmitting(false);

      if (mounted) {
        if (bookDetails != null) {
          setState(() => _books.add(bookDetails));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book details not found.'), backgroundColor: AppColors.error),
          );
        }
      }
    } catch (e) {
      widget.setSubmitting(false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error scanning book: $e")));
      }
    }
  }

  Future<Book?> _fetchBookDetails(String isbn) async {
    // final url = Uri.parse(AppUrls.getBooksApi);
    final url = Uri.parse(AppUrls.getBookApi);
    try {
      final response = await http.post(url, body: {"isbn": isbn});
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['book'] != null && data['book'].isNotEmpty) {
          return Book.fromJson(data['book'][0]);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching book details: $e');
    }
  }

  // Future<void> _submitForm() async {
  //   // 1. Run standard form validation (for red error text under fields)
  //   bool isFormValid = _formKey.currentState!.validate();
  //
  //   final selectedData = _gradeParticipants
  //       .where((p) => _participatingGrades.contains(p.grade))
  //       .toList();
  //
  //   int totalCount = selectedData.fold(0, (sum, p) => sum + p.total);
  //
  //   // 2. Custom Validation Logic with Toasts
  //   String? errorMessage;
  //
  //   if (_selectedDate == null) {
  //     errorMessage = 'Please select a date.';
  //   } else if (_activityName.trim().isEmpty) {
  //     errorMessage = 'Activity Name cannot be empty.';
  //   } else if (_description.trim().isEmpty) {
  //     errorMessage = 'Description cannot be empty.';
  //   } else if (_description.trim().length < 25) {
  //     errorMessage = 'Description must be at least 25 characters.';
  //   } else if (selectedImages.isEmpty) {
  //     errorMessage = 'Please upload at least one image.';
  //   } else if (_books.isEmpty) {
  //     errorMessage = 'Please scan at least one book.';
  //   } else if (_participatingGrades.isEmpty) {
  //     errorMessage = 'Please select participating grades.';
  //   }
  //   // else if (_totalParticipants.trim().isEmpty) {
  //   //   errorMessage = 'Total participants field is empty.';
  //   // }
  //   else if (_conductedBy.trim().isEmpty) {
  //     errorMessage = 'Conducted by field is empty.';
  //   } else if (totalCount <= 0) {
  //     errorMessage = 'Total participants must be greater than 0.';
  //   }
  //
  //   // If form is invalid or custom validation fails, show Toast and stop
  //   if (!isFormValid || errorMessage != null) {
  //     Fluttertoast.showToast(
  //       msg: errorMessage ?? "Please fix errors in the form",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.BOTTOM,
  //       backgroundColor: AppColors.error,
  //       textColor: Colors.white,
  //     );
  //     return;
  //   }
  //
  //   // 3. Proceed with API Submission
  //   widget.setSubmitting(true);
  //
  //   try {
  //     final List<Map<String, dynamic>> bookDetailsJson = _books.map((book) => {
  //       'book_code': book.isbn,
  //       'book_title': book.title,
  //       'genre': book.genre,
  //       'language': book.language,
  //     }).toList();
  //
  //     var uri = Uri.parse(AppUrls.insertFormApi);
  //     var request = http.MultipartRequest("POST", uri);
  //
  //     request.fields.addAll({
  //       'created_by': _userId ?? '',
  //       'school': _school ?? '',
  //       'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
  //       'activity_name': _activityName,
  //       'activity_description': _description,
  //       //'participants_number': _totalParticipants,
  //       'conducted_by': _conductedBy,
  //       'participants_grades': "[${_participatingGrades.join(',')}]",
  //       'book_details': jsonEncode(bookDetailsJson),
  //       'participants_number': jsonEncode(selectedData.map((e) => {
  //         'grade': e.grade,
  //         'boys': e.boys,
  //         'girls': e.girls,
  //         'total': e.total // Including total per grade just in case
  //       }).toList()),
  //     });
  //
  //
  //     for (var image in selectedImages) {
  //       request.files.add(await http.MultipartFile.fromPath('photo[]', image.path));
  //     }
  //
  //     var response = await request.send();
  //     var responseData = await response.stream.bytesToString();
  //
  //     if (response.statusCode == 200) {
  //       final decoded = json.decode(responseData);
  //       if (decoded['error'] == false) {
  //         Fluttertoast.showToast(
  //           msg: "Activity Logged Successfully!",
  //           backgroundColor: AppColors.primary,
  //           textColor: Colors.white,
  //         );
  //
  //         if (mounted) {
  //           // Use pushNamedAndRemoveUntil to clear stack and ensure fresh state
  //           Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  //         }
  //       } else {
  //         throw Exception(decoded['message'] ?? 'Submission failed');
  //       }
  //     } else {
  //       throw Exception('Server error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(
  //       msg: "Error: ${e.toString()}",
  //       backgroundColor: AppColors.error,
  //       textColor: Colors.white,
  //     );
  //   } finally {
  //     widget.setSubmitting(false);
  //   }
  // }
  Future<void> _submitForm() async {
    // 1. Run standard form validation (for red error text under fields)
    bool isFormValid = _formKey.currentState!.validate();

    final selectedData = _gradeParticipants
        .where((p) => _participatingGrades.contains(p.grade))
        .toList();

    int totalCount = selectedData.fold(0, (sum, p) => sum + p.total);

    // 2. Custom Validation Logic with Toasts
    String? errorMessage;

    if (_selectedDate == null) {
      errorMessage = 'Please select a date.';
    } else if (_activityName.trim().isEmpty) {
      errorMessage = 'Activity Name cannot be empty.';
    } else if (_description.trim().isEmpty) {
      errorMessage = 'Description cannot be empty.';
    } else if (_description.trim().length < 25) {
      errorMessage = 'Description must be at least 25 characters.';
    } else if (selectedImages.isEmpty) {
      errorMessage = 'Please upload at least one image.';
    } else if (_books.isEmpty) {
      errorMessage = 'Please scan at least one book.';
    } else if (_participatingGrades.isEmpty) {
      errorMessage = 'Please select participating grades.';
    } else if (_conductedBy.trim().isEmpty) {
      errorMessage = 'Conducted by field is empty.';
    } else if (totalCount <= 0) {
      errorMessage = 'Total participants must be greater than 0.';
    }

    // If form is invalid or custom validation fails, show Toast and stop
    if (!isFormValid || errorMessage != null) {
      Fluttertoast.showToast(
        msg: errorMessage ?? "Please fix errors in the form",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.error,
        textColor: Colors.white,
      );
      return;
    }

    // ================= DEBUG PRINTS =================

    print("\n========== LIB ACTIVITY FORM DATA ==========");

    print("User ID: $_userId");
    print("School: $_school");

    print(
      "Selected Date: ${_selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : 'NULL'}",
    );

    print("Activity Name: $_activityName");

    print("Description:");
    print(_description);

    print("Conducted By: $_conductedBy");

    print("\n========== SELECTED GRADES ==========");
    print(_participatingGrades);

    print("\n========== GRADE PARTICIPANTS ==========");

    for (var participant in selectedData) {
      print({
        'grade': participant.grade,
        'boys': participant.boys,
        'girls': participant.girls,
        'total': participant.total,
      });
    }

    print("Total Participants Count: $totalCount");

    print("\n========== BOOK DETAILS ==========");

    for (var book in _books) {
      print({
        'isbn': book.isbn,
        'title': book.title,
        'genre': book.genre,
        'language': book.language,
      });
    }

    print("\n========== SELECTED IMAGES ==========");

    for (var image in selectedImages) {
      print("Image Path: ${image.path}");
    }

    print("Total Images: ${selectedImages.length}");

    print("============================================\n");

    // ================= API SUBMISSION =================

    widget.setSubmitting(true);

    try {
      final List<Map<String, dynamic>> bookDetailsJson = _books
          .map(
            (book) => {
          'book_code': book.isbn,
          'book_title': book.title,
          'genre': book.genre,
          'language': book.language,
        },
      )
          .toList();

      // var uri = Uri.parse(AppUrls.insertFormApi);
      var uri = Uri.parse(AppUrls.insertLibFormApi);

      var request = http.MultipartRequest("POST", uri);

      request.fields.addAll({
        'created_by': _userId ?? '',
        'school': _school ?? '',
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'activity_name': _activityName,
        'activity_description': _description,
        'conducted_by': _conductedBy,
        'participants_grades':
        "[${_participatingGrades.join(',')}]",
        'book_details': jsonEncode(bookDetailsJson),
        'participants_number': jsonEncode(
          selectedData
              .map(
                (e) => {
              'grade': e.grade,
              'boys': e.boys,
              'girls': e.girls,
              'total': e.total,
            },
          )
              .toList(),
        ),
      });

      // Add Images
      for (var image in selectedImages) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo[]',
            image.path,
          ),
        );
      }

      // ================= REQUEST DEBUG =================

      print("\n========== API REQUEST FIELDS ==========");
      request.fields.forEach((key, value) {
        print("$key : $value");
      });

      print("\n========== API REQUEST FILES ==========");

      for (var file in request.files) {
        print("File Name: ${file.filename}");
      }

      print("========================================\n");

      // ================= SEND REQUEST =================

      var response = await request.send();

      var responseData = await response.stream.bytesToString();

      // ================= RESPONSE DEBUG =================

      print("\n========== API RESPONSE ==========");
      print("Status Code: ${response.statusCode}");
      print("Response Body:");
      print(responseData);
      print("==================================\n");

      if (response.statusCode == 200) {
        final decoded = json.decode(responseData);

        if (decoded['error'] == false) {
          Fluttertoast.showToast(
            msg: "Activity Logged Successfully!",
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
          );

          if (mounted) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/dashboard',
                  (route) => false,
            );
          }
        } else {
          throw Exception(
            decoded['message'] ?? 'Submission failed',
          );
        }
      } else {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }
    } catch (e) {
      print("\n========== SUBMIT ERROR ==========");
      print(e.toString());
      print("==================================\n");

      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}",
        backgroundColor: AppColors.error,
        textColor: Colors.white,
      );
    } finally {
      widget.setSubmitting(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return SingleChildScrollView(
      padding: responsive.responsivePadding(16, 24, 32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LabelText(label: "Activity Date"),
            const SizedBox(height: 10),
            CustomTextFormField(
              readOnly: true,
              //labelText: 'Activity Date',
              hintText: 'Activity Date',
              textController: TextEditingController(
                text: _selectedDate != null
                    ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                    : '',
              ),
              prefixIcon: Icons.calendar_today,
              onTap: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),

                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a date';
                }
                return null;
              },
            ),

            const SizedBox(height: 22),
            ActivityNameInput(onChanged: (value) => _activityName = value),

            const SizedBox(height: 22),
            Row(
              children: [
                BookScannerSection(onScan: _scanISBN),
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
            SizedBox(height: 22,child:  LabelText(label: 'OR')),

            Row(
              children: [
                OcrReaderButton(  onLoading: (isLoading) => widget.setSubmitting(isLoading),
                  onIsbnDetected: (isbn) async {
                    // Re-use your existing fetch logic
                    final bookDetails = await _fetchBookDetails(isbn);
                    if (mounted) {
                      if (bookDetails != null) {
                        setState(() {
                          // Prevent duplicates
                          if (!_books.any((b) => b.isbn == bookDetails.isbn)) {
                            _books.add(bookDetails);
                          }
                        });
                        Fluttertoast.showToast(msg: "Book added: ${bookDetails.title}");
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Book not found in database.'), backgroundColor: AppColors.error),
                        );
                      }
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
            //SizedBox(height: 22,child:  LabelText(label: 'OR')),
            LabelText(label: "ISBN "),
            const SizedBox(height: 8),
            CustomTextFormField(
              textController: _isbnController,
              hintText: "Fill ISBN Manually",
               validator: (value) => null,
              suffixIcon: IconButton(
                onPressed: () async{
                  print("Book ISBN : ${_isbnController.text}");
                  final bookDetails = await _fetchBookDetails(_isbnController.text);
                  if (mounted) {
                    if (bookDetails != null) {
                      setState(() {
                        // Prevent duplicates
                        if (!_books.any((b) => b.isbn == bookDetails.isbn)) {
                          _books.add(bookDetails);
                        }
                        _isbnController.clear();
                      });
                      Fluttertoast.showToast(msg: "Book added: ${bookDetails.title}");
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Book not found in database.'), backgroundColor: AppColors.error),
                      );
                    }
                  }
                }  ,
                icon: const Icon(Icons.search, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 10),
            BookList(
              books: _books,
              onBookRemoved: (book) => setState(() => _books.remove(book)),
            ),
            const SizedBox(height: 16),
            GradesSelection(
              isLoading: _isLoadingGrades,
              availableGrades: _availableGrades,
              selectedGrades: _participatingGrades,
              onGradesChanged: (newSelection) {
                setState(() {
                  _participatingGrades = newSelection;
                });
              },
            ),
            const SizedBox(height: 22),
            // TotalParticipantsInput(onChanged: (value) => _totalParticipants = value),
            TotalParticipantsInput(
              // Filter the list to show only selected grades
              participants: _gradeParticipants
                  .where((p) => _participatingGrades.contains(p.grade))
                  .toList(),
              onUpdate: () => setState(() {}),
            ),
            const SizedBox(height: 22),
            ConductedByInput(onChanged: (value) => _conductedBy = value),
            const SizedBox(height: 22),
            DescriptionInput(onChanged: (value) => _description = value),
            const SizedBox(height: 22),
            UploadActivityImg(
              selectedImages: selectedImages,
              // onImagesSelected: (images) {
              //   setState(() {
              //     selectedImages.addAll(images);
              //   });
              // },
              onImagesSelected: (updatedImages) {
                setState(() {
                  selectedImages = updatedImages;
                });
              },
            ),
            const SizedBox(height: 32),
            SafeArea(
              child:SubmitButton(onPressed: _submitForm),

            ),
          ],
        ),
      ),
    );
  }
}