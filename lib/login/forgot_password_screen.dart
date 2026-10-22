import 'dart:async';
import 'package:flutter/material.dart';
import '../components/app_feedback.dart';
import '../components/custom_appbar.dart';
import '../components/custom_button.dart';
import '../components/custom_textField.dart';
import '../configs/color/color.dart';
import '../configs/helper/responsive_helper.dart';
import '../librarian/librarian_repository.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _repository = LibrarianRepository();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmController = TextEditingController();
  final _mobileKey = GlobalKey<FormState>();
  final _resetKey = GlobalKey<FormState>();

  static final _mobileRegex = RegExp(r'^[6-9][0-9]{9}$');

  bool _otpSent = false;
  bool _isBusy = false;
  bool _hidePass = true;
  bool _hideConfirm = true;
  int _resendSeconds = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _mobileController.dispose();
    _otpController.dispose();
    _passController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _startCountdown(int seconds) {
    _timer?.cancel();
    setState(() => _resendSeconds = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      if (_resendSeconds <= 1) {
        t.cancel();
        setState(() => _resendSeconds = 0);
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  Future<void> _sendOtp() async {
    if (!_mobileKey.currentState!.validate()) return;
    setState(() => _isBusy = true);
    try {
      final res = await _repository.sendForgotPasswordOtp(_mobileController.text.trim());
      print("RESPOSE : $res");
      if (!mounted) return;
      if (res['status'] == 1) {
        setState(() => _otpSent = true);
        _otpController.clear();
        _startCountdown(int.tryParse('${res['resend_after']}') ?? 60);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res['message'].toString()), backgroundColor: Colors.green,));
      } else {
        if (res['http_code'] == 429) {
          // an OTP was requested a moment ago - let the user continue with it
          setState(() => _otpSent = true);
          _startCountdown(int.tryParse('${res['resend_after']}') ?? 60);
        }
        await AppFeedback.showError(context,
            title: 'Could Not Send OTP', message: res['message'].toString());
      }
    } catch (_) {
      if (mounted) {
        await AppFeedback.showError(context,
            title: 'Could Not Send OTP',
            message: 'Please check your internet connection and try again.');
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!_resetKey.currentState!.validate()) return;
    setState(() => _isBusy = true);
    try {
      final res = await _repository.resetPassword(
        _mobileController.text.trim(),
        _otpController.text.trim(),
        _passController.text,
      );
      if (!mounted) return;
      if (res['status'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(res['message'].toString())));
        if (mounted) Navigator.pop(context);
      } else {
        if (res['http_code'] == 429) {
          // too many wrong attempts - a new OTP is needed
          _timer?.cancel();
          setState(() => _resendSeconds = 0);
        }
        _otpController.clear();
        await AppFeedback.showError(context,
            title: 'Reset Failed', message: res['message'].toString());
      }
    } catch (_) {
      if (mounted) {
        await AppFeedback.showError(context,
            title: 'Reset Failed',
            message: 'Please check your internet connection and try again.');
      }
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  void _changeNumber() {
    _timer?.cancel();
    setState(() {
      _otpSent = false;
      _resendSeconds = 0;
      _otpController.clear();
      _passController.clear();
      _confirmController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 222, 192),
      appBar: const CustomAppbar(
        title: 'Forgot Password',
        studentAdd: false,
        backbutton: true,
      ),
      body: Center(
        child: Container(
          width: responsive.responsiveValue(
              small: size.width * 0.9, medium: size.width * 0.7, large: size.width * 0.7),
          constraints: BoxConstraints(maxHeight: size.height * 0.85),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 238, 222, 192),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset('assets/logo_17k.png',
                    height: size.height * 0.12, width: size.width * 0.7),
                SizedBox(height: size.height * 0.02),
                Form(
                  key: _mobileKey,
                  child: CustomTextFormField(
                    textController: _mobileController,
                    textInputType: TextInputType.phone,
                    labelText: 'Registered Mobile Number',
                    hintText: 'Enter Mobile Number',
                    maxlength: 10,
                    prefixText: '+91 ',
                    readOnly: _otpSent || _isBusy,
                    validator: (v) {
                      final n = v?.trim() ?? '';
                      if (n.isEmpty) return 'Required';
                      if (!_mobileRegex.hasMatch(n)) return 'Enter a valid 10-digit mobile number';
                      return null;
                    },
                  ),
                ),
                SizedBox(height: size.height * 0.015),
                if (!_otpSent)
                  CustomButton(
                    onPressedButton: _isBusy ? null : _sendOtp,
                    title: _isBusy ? 'Sending...' : 'Send OTP',
                  )
                else
                  Form(
                    key: _resetKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextFormField(
                          textController: _otpController,
                          textInputType: TextInputType.number,
                          labelText: 'Enter 6-digit OTP',
                          hintText: 'Enter OTP',
                          maxlength: 6,
                          validator: (v) {
                            final o = v?.trim() ?? '';
                            if (o.length != 6 || int.tryParse(o) == null) {
                              return 'Enter the 6-digit OTP';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.015),
                        CustomTextFormField(
                          textController: _passController,
                          labelText: 'New Password',
                          hintText: 'At least 8 characters',
                          obscureText: _hidePass,
                          suffixIcon: IconButton(
                            icon: Icon(_hidePass ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _hidePass = !_hidePass),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (v.length < 8) return 'Minimum 8 characters';
                            return null;
                          },
                        ),
                        SizedBox(height: size.height * 0.015),
                        CustomTextFormField(
                          textController: _confirmController,
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter new password',
                          obscureText: _hideConfirm,
                          suffixIcon: IconButton(
                            icon: Icon(_hideConfirm ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _hideConfirm = !_hideConfirm),
                          ),
                          validator: (v) =>
                          v != _passController.text ? 'Passwords do not match' : null,
                        ),
                        SizedBox(height: size.height * 0.02),
                        CustomButton(
                          onPressedButton: _isBusy ? null : _resetPassword,
                          title: _isBusy ? 'Please wait...' : 'Reset Password',
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: _isBusy ? null : _changeNumber,
                              child: const Text('Change number'),
                            ),
                            TextButton(
                              onPressed: (_isBusy || _resendSeconds > 0) ? null : _sendOtp,
                              child: Text(_resendSeconds > 0
                                  ? 'Resend OTP in ${_resendSeconds}s'
                                  : 'Resend OTP'),
                            ),
                          ],
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