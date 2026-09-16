// lib/license/license_activation_screen.dart
import 'package:flutter/material.dart';
import 'package:lib17000ft/components/component.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/custom_appbar.dart';
import '../configs/color/color.dart';
import '../configs/routes/routes_name.dart';
import 'license_repository.dart';

class LicenseActivationScreen extends StatefulWidget {
  const LicenseActivationScreen({super.key});

  @override
  State<LicenseActivationScreen> createState() => _LicenseActivationScreenState();
}

class _LicenseActivationScreenState extends State<LicenseActivationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _licenseKeyController = TextEditingController();
  final _repository = LicenseRepository();
  bool _isLoading = false;
  String? _errorMessage;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _checkActivationStatus();
  }

  Future<void> _checkActivationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isActivated = prefs.getBool('licenseActivated') ?? false;
    if (isActivated && mounted) {
      Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
    }
  }

  Future<void> _activate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _repository.activateLicense(
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
        licenseKey: _licenseKeyController.text.trim(),
      );

      if (result['status'] == 1) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('licenseActivated', true);
        await prefs.setString('licenseKey', _licenseKeyController.text.trim());
        await prefs.setString('licenseSchoolUdise', result['license']['school_udise']?.toString() ?? '');
        await prefs.setString('licenseValidUntil', result['license']['valid_until']?.toString() ?? '');

        if (mounted) {
          // CHANGED — simple navigation to normal login, no prefill/auto-submit
          Navigator.pushReplacementNamed(context, RoutesName.loginScreen);
        }
      } else {
        setState(() => _errorMessage = result['message']?.toString() ?? 'Activation failed');
      }
    } catch (e) {
      setState(() => _errorMessage = 'Activation error: $e');
      print("Error : $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      // appBar: AppBar(title: const Text('Activate License')),
      appBar: const CustomAppbar(
        title: "License Activation",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset('assets/logo_17k.png', width: 200, height: 200),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        LabelText(label: 'Username'),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          textController: _usernameController,
                          hintText: "Enter Username",
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        LabelText(label: 'Password'),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          textController: _passwordController,
                          hintText: "Enter Password",
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
                          obscureText: passwordVisible,
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        LabelText(label: 'License Key'),
                        const SizedBox(height: 8),
                        CustomTextFormField(
                          textController: _licenseKeyController,
                          hintText: "Enter License Key",
                          validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        if (_errorMessage != null) ...[
                          const SizedBox(height: 12),
                          Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                        ],
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _activate,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: _isLoading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Activate', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                        SizedBox(height: size.height * 0.04),
                        const Text(
                          'This device needs to be activated once before use.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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