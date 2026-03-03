import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib17000ft/components/custom_button.dart';
import 'package:lib17000ft/components/custom_textField.dart';
import 'package:lib17000ft/configs/color/color.dart';
import 'package:lib17000ft/configs/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/helper/responsive_helper.dart';
import 'bloc/login_cubit.dart';
import 'bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool passwordVisible = false;
  bool? login;

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();

    _checkLoginState(); // Check login state on init
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  Future<void> _checkLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      // Use Navigator directly if necessary
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, RoutesName.dashboard);
      } else {
        print('Context is not mounted. Navigation aborted.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 222, 192),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            children: [
              //  const CurvedContainer(),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/logo.png',
                height: responsive.responsiveValue(
                    small: 200.0, medium: 220.0, large: 100.0),
                width: responsive.responsiveValue(
                    small: 200.0, medium: 330.0, large: 250.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Login',
                    style: AppStyles.heading1(context, AppColors.primary),
                  ),
                ),
              ),
              SizedBox(
                height: responsive.responsiveValue(
                    small: 20.0, medium: 30.0, large: 40.0),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                  if (state is LoginSuccess) {
                    _saveLoginState();
                    loginCubit.getToken();
                   
                    Navigator.pushReplacementNamed(
                        context, RoutesName.dashboard);
                  }

                  if (state is LoginLoading) {
                    const CircularProgressIndicator();
                  }
                }, builder: (context, state) {
                  return Form(
                    key: loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextFormField(
                          textController: usernameController,
                          textInputType: TextInputType.text,
                          prefixIcon: Icons.person,
                          hintText: 'Username',
                          labelText: 'Enter username',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                          onChanged: (value) => loginCubit.username = value,
                        ),
                        SizedBox(
                          height: responsive.responsiveValue(
                              small: 30.0, medium: 40.0, large: 20.0),
                        ),
                        CustomTextFormField(
                          textController: passwordController,
                          obscureText: passwordVisible,
                          prefixIcon: Icons.password,
                          hintText: 'Password',
                          labelText: 'Enter  password',
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
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onChanged: (value) => loginCubit.password = value,
                        ),
                        SizedBox(
                          height: responsive.responsiveValue(
                              small: 20.0, medium: 30.0, large: 20.0),
                        ),
                        if (state is LoginLoading)
                          const Center(child: CircularProgressIndicator(color: AppColors.primary,)),
                        if (state is LoginFailure)
                          Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (state is! LoginLoading)
                          CustomButton(
                            title: 'Login',
                            onPressedButton: () {
                              if (loginFormKey.currentState!.validate()) {
                                loginCubit.login(
                                  loginCubit.username,
                                  loginCubit.password,
                                );
                              }
                            },
                          ),
                        SizedBox(
                          height: responsive.responsiveValue(
                              small: 10.0, medium: 20.0, large: 30.0),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

  }
}
