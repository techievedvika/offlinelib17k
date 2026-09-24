// lib/librarian/librarian_registration_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_button.dart';
import '../components/custom_textField.dart';
import '../configs/color/color.dart';
import '../configs/helper/responsive_helper.dart';
import '../configs/routes/routes_name.dart';
import 'librarian_repository.dart';

class LibrarianRegistrationScreen extends StatefulWidget {
  const LibrarianRegistrationScreen({super.key});

  @override
  State<LibrarianRegistrationScreen> createState() => _LibrarianRegistrationScreenState();
}

class _LibrarianRegistrationScreenState extends State<LibrarianRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _schoolIdController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _repository = LibrarianRepository();
  bool _isLoading = false;
  String? _errorMessage;
  bool passwordVisible = true;

  bool _isCheckingSchool = false;
  bool? _isUdiseValid;
  String? _schoolName;
  String? _udiseErrorMessage;

  Future<void> _showSchoolNotFoundDialog([String? message]) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.school_outlined, color: AppColors.error),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'School Not Found',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
                ),
              ),
            ],
          ),
          content: Text.rich(
            TextSpan(
              style: const TextStyle(color: AppColors.onSurface),
              children: [
                TextSpan(
                  text: message ?? 'School details are not available in database. Please contact team to add school first.',
                ),
                const TextSpan(
                  text: '\n\nContact\n',
                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary),
                ),
                const TextSpan(
                  text: 'team@vedvika.com\n',
                  style: TextStyle(color: AppColors.tertiary, fontWeight: FontWeight.w600),
                ),
                const TextSpan(text: '0124 4255966'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _checkUdiseCode(String udiseCode) async {
    final code = udiseCode.trim();
    if (code.isEmpty) {
      setState(() {
        _isUdiseValid = null;
        _schoolName = null;
        _udiseErrorMessage = null;
      });
      return false;
    }

    setState(() {
      _isCheckingSchool = true;
      _udiseErrorMessage = null;
      _schoolName = null;
    });

    try {
      final response = await _repository.getSchoolDetail(code);

      bool isAvailable = false;
      String? foundSchoolName;

      if (response is Map) {
        final status = response['status'];
        final success = response['success'];
        final error = response['error'];
        final data = response['data'];

        if (status == 1 || status == '1' || status == true || status == 200 || success == true) {
          isAvailable = true;
        } else if (error == false && data != null) {
          isAvailable = true;
        } else if (data != null && status != 0 && status != '0' && error != true) {
          isAvailable = true;
        } else if (response['SCHOOL_NAME'] != null || response['school'] != null) {
          isAvailable = true;
        }

        if (data is Map) {
          foundSchoolName = data['SCHOOL_NAME']?.toString() ??
              data['SCHOOL_NAME_new']?.toString() ??
              data['school']?.toString();
        } else if (data is List && data.isNotEmpty && data[0] is Map) {
          foundSchoolName = data[0]['SCHOOL_NAME']?.toString() ??
              data[0]['SCHOOL_NAME_new']?.toString() ??
              data[0]['school']?.toString();
        } else if (response['SCHOOL_NAME'] != null) {
          foundSchoolName = response['SCHOOL_NAME']?.toString();
        } else if (response['school'] != null) {
          foundSchoolName = response['school']?.toString();
        }
      } else if (response is List) {
        if (response.isNotEmpty) {
          isAvailable = true;
          if (response[0] is Map) {
            foundSchoolName = response[0]['SCHOOL_NAME']?.toString() ??
                response[0]['SCHOOL_NAME_new']?.toString() ??
                response[0]['school']?.toString();
          }
        }
      }

      if (isAvailable) {
        setState(() {
          _isUdiseValid = true;
          _schoolName = foundSchoolName;
          _udiseErrorMessage = null;
        });
        return true;
      } else {
        String msg = 'UDISE Code is not available in database';
        if (response is Map && response['message'] != null && response['message'].toString().isNotEmpty) {
          msg = response['message'].toString();
        }
        setState(() {
          _isUdiseValid = false;
          _schoolName = null;
          _udiseErrorMessage = msg;
        });
        if (mounted) {
          await _showSchoolNotFoundDialog(msg);
        }
        return false;
      }
    } catch (e) {
      final errorMsg = 'Error checking UDISE Code: $e';
      setState(() {
        _isUdiseValid = false;
        _schoolName = null;
        _udiseErrorMessage = errorMsg;
      });
      if (mounted) {
        await _showSchoolNotFoundDialog(errorMsg);
      }
      return false;
    } finally {
      if (mounted) {
        setState(() => _isCheckingSchool = false);
      }
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = 'Passwords do not match');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Check if UDISE code is available in DB using getSchoolDetail API
      final isUdiseAvailable = await _checkUdiseCode(_schoolIdController.text.trim());
      if (!isUdiseAvailable) {
        setState(() {
          _isLoading = false;
          _errorMessage = _udiseErrorMessage ?? 'UDISE Code is not available in database';
        });
        return;
      }

      final result = await _repository.registerLibrarian(
        name: _nameController.text.trim(),
        number: _numberController.text.trim(),
        schoolId: _schoolIdController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      if (result['status'] == 1) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('librarianRegistered', true);

        if (mounted) {
          // Proceed straight to License Activation, carrying the same credentials forward
          Navigator.pushReplacementNamed(
            context,
            RoutesName.licenseActivationScreen,
            arguments: {
              'prefillUsername': _usernameController.text.trim(),
              'prefillPassword': _passwordController.text,
            },
          );
        }
      } else {
        setState(() => _errorMessage = result['message']?.toString() ?? 'Registration failed');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 222, 192),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, right: 40, left: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo_17k.png',
                  height: responsive.responsiveValue(
                      small: 200.0, medium: 220.0, large: 100.0),
                  width: responsive.responsiveValue(
                      small: 200.0, medium: 330.0, large: 250.0),
                ),
                SizedBox(
                  height: responsive.responsiveValue(
                      small: 10.0, medium: 15.0, large: 20.0),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Register',
                    style: AppStyles.heading1(context, AppColors.secondary),
                  ),
                ),
                SizedBox(
                  height: responsive.responsiveValue(
                      small: 20.0, medium: 30.0, large: 40.0),
                ),
                CustomTextFormField(
                  textController: _nameController,
                  labelText: 'Name',
                  hintText: 'Enter Name',
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(
                  height: responsive.responsiveValue(
                      small: 20.0, medium: 30.0, large: 10.0),
                ),
                CustomTextFormField(
                  textController: _numberController,
                  textInputType: TextInputType.phone,
                  labelText: 'Number',
                  hintText: 'Enter Mobile Number',
                  maxlength: 10,
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(
                  height: responsive.responsiveValue(
                      small: 20.0, medium: 30.0, large: 10.0),
                ),
                CustomTextFormField(
                  textController: _schoolIdController,
                  labelText: 'UDISE Code',
                  hintText: 'Enter school UDISE Code',
                  textInputType: TextInputType.number,
                  maxlength: 11,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (_isUdiseValid == false) {
                      return _udiseErrorMessage ?? 'UDISE Code is not available in database';
                    }
                    return null;
                  },
                  onChanged: (v) {
                    if (_isUdiseValid != null || _udiseErrorMessage != null || _schoolName != null) {
                      setState(() {
                        _isUdiseValid = null;
                        _schoolName = null;
                        _udiseErrorMessage = null;
                      });
                    }
                  },
                  onEditingComplete: () {
                    final code = _schoolIdController.text.trim();
                    if (code.isNotEmpty) {
                      _checkUdiseCode(code);
                    }
                  },
                ),
                if (_isCheckingSchool) ...[
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Verifying UDISE Code...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ] else if (_schoolName != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'School: $_schoolName',
                          style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ] else if (_udiseErrorMessage != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.error, color: Colors.red, size: 16),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          _udiseErrorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
                SizedBox(
                  height: responsive.responsiveValue(
                      small: 20.0, medium: 30.0, large: 10.0),
                ),
                CustomTextFormField(
                  textController: _usernameController,
                  labelText: 'Username',
                  hintText: 'Choose a Username',
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                SizedBox(
                  height: responsive.responsiveValue(
                      small: 20.0, medium: 30.0, large: 10.0),
                ),
                CustomTextFormField(
                  textController: _passwordController,
                  obscureText: passwordVisible,
                  labelText: 'Password',
                  hintText: 'Enter Password',
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  validator: (v) => v == null || v.length < 6 ? 'At least 6 characters' : null,
                ),
                SizedBox(
                  height: responsive.responsiveValue(
                      small: 20.0, medium: 30.0, large: 10.0),
                ),
                CustomTextFormField(
                  textController: _confirmPasswordController,
                  obscureText: passwordVisible,
                  labelText: 'Confirm Password',
                  hintText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(passwordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                ],
                SizedBox(
                  height: responsive.responsiveValue(
                      small: 20.0, medium: 30.0, large: 10.0),
                ),
                CustomButton(
                  onPressedButton: _isLoading ? null : _register,
                  title: _isLoading ? 'Loading...' : 'Register',
                ),
                SizedBox(
                  height: responsive.responsiveValue(
                      small: 2.0, medium: 5.0, large: 5.0),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already Registered?',
                      ),
                      TextButton(
                        onPressed: () async {
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, RoutesName.licenseActivationScreen);
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}