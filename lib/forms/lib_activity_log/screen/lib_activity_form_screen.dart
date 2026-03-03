import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/forms/lib_activity_log/submit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../components/custom_appbar.dart';
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
  //String _date = '';
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

  Future<void> _submitForm() async {
    print("Submit button pressed. Validating form...");

    if (!_formKey.currentState!.validate()) {
      print("Form validation failed.");
      return;
    }
    print("Form validation successful.");

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_books.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one book detail.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_participatingGrades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one participating grade.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }


    widget.setSubmitting(true);

    final List<Map<String, dynamic>> bookDetailsJson = _books.map((book) {
      return {
        'book_code': book.isbn,
        'book_title': book.title,
        'genre': book.genre,
        'language': book.language,
      };
    }).toList();

    final body = {
      'created_by': _userId,
      'school': _school,
      'date': DateFormat('yyyy-MM-dd').format(_selectedDate!), // ✅ formatted string
      'activity_name': _activityName,
      'activity_description': _description,
      'participants_number': _totalParticipants,
      'conducted_by': _conductedBy,
      'participants_grades':"[${_participatingGrades.join(',')}]", // list → string
      //'book_details': _books.map((book) => book.isbn).toList().join(','), // list → string
      'book_details': jsonEncode(bookDetailsJson),
    };

    print("Submitting with body: $body");

    try {
      final response = await http.post(
        Uri.parse(AppUrls.insertFormApi),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: body,
      );

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200 && mounted) {
        final responseData = json.decode(response.body);

        if (responseData['error'] == false) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('Activity Logged Successfully!'),
                backgroundColor: AppColors.primary,
              ),
            );

          // ✅ Reset form & clear states
          _formKey.currentState?.reset();
          setState(() {
            _selectedDate = null;
            _activityName = '';
            _description = '';
            _books = [];
            _participatingGrades = [];
            _totalParticipants = '';
            _conductedBy = '';
          });

          Navigator.pushNamed(
            context,
            '/dashboard',
          );
        } else {
          throw Exception(responseData['message'] ?? 'API returned an error.');
        }
      } else {
        throw Exception('Server returned an error: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text('Submission Failed: ${e.toString()}'),
              backgroundColor: AppColors.error,
            ),
          );
      }
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
            const SizedBox(height: 16),

            // 📅 Inline Date Picker Field
            CustomTextFormField(
              readOnly: true,
              labelText: 'Activity Date',
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

            const SizedBox(height: 16),
            ActivityNameInput(onChanged: (value) => _activityName = value),
            const SizedBox(height: 16),
            DescriptionInput(onChanged: (value) => _description = value),
            const SizedBox(height: 24),
            BookScannerSection(onScan: _scanISBN),
            BookList(
              books: _books,
              onBookRemoved: (book) => setState(() => _books.remove(book)),
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 16),
            TotalParticipantsInput(onChanged: (value) => _totalParticipants = value),
            const SizedBox(height: 16),
            ConductedByInput(onChanged: (value) => _conductedBy = value),
            const SizedBox(height: 32),
            SubmitButton(onPressed: _submitForm),
          ],
        ),
      ),
    );
  }
}