import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/forms/lib_activity_log/submit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/custom_appbar.dart';
import '../../../components/custom_labeltext.dart';
import '../../../components/custom_textField.dart';
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
  String _conductedBy = '';
  List<String> _availableGrades = [];
  bool _isLoadingGrades = true;

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
      final response = await http.get(Uri.parse(AppUrls.getGradeApi));
      if (response.statusCode == 200 && mounted) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data['error'] == false) {
          List<dynamic> messageList = data['message'];
          setState(() {
            _availableGrades = messageList.map((item) => item['grade'].toString()).toList();
          });
        } else {
          throw Exception('Failed to load grades: Invalid data format');
        }
      } else {
        throw Exception('Server error while fetching grades');
      }
    } catch (e) {
      if (mounted) {
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
    final url = Uri.parse(AppUrls.getBooksApi);
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
  //   print("Submit button pressed. Validating form...");
  //
  //   if (!_formKey.currentState!.validate()) {
  //     print("Form validation failed.");
  //     return;
  //   }
  //
  //   if (_selectedDate == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please select a date.'),
  //         backgroundColor: AppColors.error,
  //       ),
  //     );
  //     return;
  //   }
  //
  //   if (_books.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please add at least one book detail.'),
  //         backgroundColor: AppColors.error,
  //       ),
  //     );
  //     return;
  //   }
  //
  //   if (_participatingGrades.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please select at least one participating grade.'),
  //         backgroundColor: AppColors.error,
  //       ),
  //     );
  //     return;
  //   }
  //
  //   if (selectedImages.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Please select at least one image.'),
  //         backgroundColor: AppColors.error,
  //       ),
  //     );
  //     return;
  //   }
  //
  //   print("Total images uploading: ${selectedImages.length}");
  //
  //   widget.setSubmitting(true);
  //
  //   final List<Map<String, dynamic>> bookDetailsJson = _books.map((book) {
  //     return {
  //       'book_code': book.isbn,
  //       'book_title': book.title,
  //       'genre': book.genre,
  //       'language': book.language,
  //     };
  //   }).toList();
  //
  //   try {
  //     var uri = Uri.parse(AppUrls.insertFormApi);
  //
  //     var request = http.MultipartRequest("POST", uri);
  //
  //     request.fields['created_by'] = _userId!;
  //     request.fields['school'] = _school!;
  //     request.fields['date'] =
  //         DateFormat('yyyy-MM-dd').format(_selectedDate!);
  //     request.fields['activity_name'] = _activityName;
  //     request.fields['activity_description'] = _description;
  //     request.fields['participants_number'] = _totalParticipants;
  //     request.fields['conducted_by'] = _conductedBy;
  //     request.fields['participants_grades'] =
  //     "[${_participatingGrades.join(',')}]";
  //     request.fields['book_details'] = jsonEncode(bookDetailsJson);
  //
  //     /// IMAGE UPLOAD
  //     if (selectedImages.isNotEmpty) {
  //       for (var image in selectedImages) {
  //         request.files.add(
  //           await http.MultipartFile.fromPath(
  //             'photo[]',
  //             image.path,
  //           ),
  //         );
  //       }
  //     }
  //
  //     print("Submitting with fields: ${request.fields}");
  //
  //     var response = await request.send();
  //
  //     var responseData = await response.stream.bytesToString();
  //
  //     print("API Response Status: ${response.statusCode}");
  //     print("API Response Body: $responseData");
  //
  //     if (response.statusCode == 200 && mounted) {
  //       final decoded = json.decode(responseData);
  //
  //       if (decoded['error'] == false) {
  //         ScaffoldMessenger.of(context)
  //           ..hideCurrentSnackBar()
  //           ..showSnackBar(
  //             const SnackBar(
  //               content: Text('Activity Logged Successfully!'),
  //               backgroundColor: AppColors.primary,
  //             ),
  //           );
  //
  //         _formKey.currentState?.reset();
  //
  //         setState(() {
  //           _selectedDate = null;
  //           _activityName = '';
  //           _description = '';
  //           _books = [];
  //           _participatingGrades = [];
  //           _totalParticipants = '';
  //           _conductedBy = '';
  //           selectedImages = [];
  //         });
  //
  //         Navigator.pushNamed(context, '/dashboard');
  //       } else {
  //         throw Exception(decoded['message'] ?? 'API returned an error.');
  //       }
  //     } else {
  //       throw Exception('Server returned error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context)
  //         ..hideCurrentSnackBar()
  //         ..showSnackBar(
  //           SnackBar(
  //             content: Text('Submission Failed: ${e.toString()}'),
  //             backgroundColor: AppColors.error,
  //           ),
  //         );
  //     }
  //   } finally {
  //     widget.setSubmitting(false);
  //   }
  // }
  // Future<void> _submitForm() async {
  //   // 1. Basic Form Validation (Textfields)
  //   if (!_formKey.currentState!.validate()) {
  //     return;
  //   }
  //
  //   // 2. Custom Validations with SnackBars
  //   String? errorMessage;
  //
  //   if (_selectedDate == null) {
  //     errorMessage = 'Please select a date.';
  //   } else if (_activityName.trim().isEmpty) {
  //     errorMessage = 'Please enter an activity name.';
  //   } else if (_description.trim().length < 25) {
  //     errorMessage = 'Description must be at least 25 characters.';
  //   } else if (selectedImages.isEmpty) {
  //     errorMessage = 'Please upload at least one image.';
  //   } else if (_books.isEmpty) {
  //     errorMessage = 'Please scan at least one book.';
  //   } else if (_participatingGrades.isEmpty) {
  //     errorMessage = 'Please select participating grades.';
  //   } else if (_totalParticipants.trim().isEmpty) {
  //     errorMessage = 'Please enter total participants.';
  //   } else if (_conductedBy.trim().isEmpty) {
  //     errorMessage = 'Please enter who conducted the activity.';
  //   }
  //
  //   if (errorMessage != null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(errorMessage),
  //         backgroundColor: AppColors.error,
  //         behavior: SnackBarBehavior.floating,
  //       ),
  //     );
  //     return;
  //   }
  //   // if (errorMessage != null) {
  //   //   Fluttertoast.showToast(
  //   //     msg: errorMessage,
  //   //     toastLength: Toast.LENGTH_SHORT,
  //   //     gravity: ToastGravity.BOTTOM,
  //   //     backgroundColor: AppColors.error,
  //   //     textColor: Colors.white,
  //   //     fontSize: 14.0,
  //   //   );
  //   //   return;
  //   // }
  //
  //   // 3. Proceed with Submission
  //   widget.setSubmitting(true);
  //
  //   try {
  //     var uri = Uri.parse(AppUrls.insertFormApi);
  //     var request = http.MultipartRequest("POST", uri);
  //
  //     // Prepare book details
  //     final List<Map<String, dynamic>> bookDetailsJson = _books.map((book) => {
  //       'book_code': book.isbn,
  //       'book_title': book.title,
  //       'genre': book.genre,
  //       'language': book.language,
  //     }).toList();
  //
  //     request.fields.addAll({
  //       'created_by': _userId ?? '',
  //       'school': _school ?? '',
  //       'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
  //       'activity_name': _activityName,
  //       'activity_description': _description,
  //       'participants_number': _totalParticipants,
  //       'conducted_by': _conductedBy,
  //       'participants_grades': "[${_participatingGrades.join(',')}]",
  //       'book_details': jsonEncode(bookDetailsJson),
  //     });
  //
  //     for (var image in selectedImages) {
  //       request.files.add(await http.MultipartFile.fromPath('photo[]', image.path));
  //     }
  //
  //     var response = await request.send();
  //     var responseData = await response.stream.bytesToString();
  //
  //     if (response.statusCode == 200 && mounted) {
  //       final decoded = json.decode(responseData);
  //       if (decoded['error'] == false) {
  //
  //         // --- KEY FIX FOR SNACKBAR VISIBILITY ---
  //         // Use the root ScaffoldMessenger so it persists across navigation
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             content: Text('Activity Logged Successfully!'),
  //             backgroundColor: AppColors.primary,
  //             duration: Duration(seconds: 2),
  //           ),
  //         );
  //
  //         // Delay navigation slightly so they see the success message
  //         await Future.delayed(const Duration(milliseconds: 500));
  //
  //         if (mounted) {
  //           Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
  //         }
  //       } else {
  //         throw Exception(decoded['message'] ?? 'API Error');
  //       }
  //     } else {
  //       throw Exception('Server Error: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Submission Failed: $e'),
  //           backgroundColor: AppColors.error,
  //         ),
  //       );
  //     }
  //   } finally {
  //     widget.setSubmitting(false);
  //   }
  // }
  Future<void> _submitForm() async {
    // 1. Run standard form validation (for red error text under fields)
    bool isFormValid = _formKey.currentState!.validate();

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
    } else if (_totalParticipants.trim().isEmpty) {
      errorMessage = 'Total participants field is empty.';
    } else if (_conductedBy.trim().isEmpty) {
      errorMessage = 'Conducted by field is empty.';
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

    // 3. Proceed with API Submission
    widget.setSubmitting(true);

    try {
      final List<Map<String, dynamic>> bookDetailsJson = _books.map((book) => {
        'book_code': book.isbn,
        'book_title': book.title,
        'genre': book.genre,
        'language': book.language,
      }).toList();

      var uri = Uri.parse(AppUrls.insertFormApi);
      var request = http.MultipartRequest("POST", uri);

      request.fields.addAll({
        'created_by': _userId ?? '',
        'school': _school ?? '',
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'activity_name': _activityName,
        'activity_description': _description,
        'participants_number': _totalParticipants,
        'conducted_by': _conductedBy,
        'participants_grades': "[${_participatingGrades.join(',')}]",
        'book_details': jsonEncode(bookDetailsJson),
      });

      for (var image in selectedImages) {
        request.files.add(await http.MultipartFile.fromPath('photo[]', image.path));
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = json.decode(responseData);
        if (decoded['error'] == false) {
          Fluttertoast.showToast(
            msg: "Activity Logged Successfully!",
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
          );

          if (mounted) {
            // Use pushNamedAndRemoveUntil to clear stack and ensure fresh state
            Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
          }
        } else {
          throw Exception(decoded['message'] ?? 'Submission failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
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
            LabelText(label: "Activity Description"),
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
            const SizedBox(height: 22),
            BookScannerSection(onScan: _scanISBN),
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
            TotalParticipantsInput(onChanged: (value) => _totalParticipants = value),
            const SizedBox(height: 22),
            ConductedByInput(onChanged: (value) => _conductedBy = value),
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