import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lib17000ft/components/custom_button.dart';
import 'package:lib17000ft/components/custom_textField.dart';
import 'package:lib17000ft/configs/color/color.dart';
import 'package:lib17000ft/configs/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs/helper/responsive_helper.dart';
import '../core/device_id_helper.dart';
import 'bloc/login_cubit.dart';
import 'bloc/login_state.dart';
import '../models/license.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  bool passwordVisible = true;
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
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 222, 192),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //  const CurvedContainer(),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/logo_17k.png',
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
                    style: AppStyles.heading1(context, AppColors.secondary),
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
                            child: Column(
                              children: [
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        if (state is! LoginLoading)
                          // CustomButton(
                          //   title: 'Login',
                          //   onPressedButton: () async {
                          //     if (loginFormKey.currentState!.validate()) {
                          //       final deviceUuid = await DeviceIdHelper.getDeviceUuid();
                          //       final deviceName = await DeviceIdHelper.getDeviceName();
                          //       loginCubit.login(
                          //         loginCubit.username,
                          //         loginCubit.password,
                          //         deviceUuid,
                          //         deviceName,
                          //       );
                          //     }
                          //   },
                          //   width: size.width,
                          // ),
                          ElevatedButton(
                            onPressed: () async {
                              if (loginFormKey.currentState!.validate()) {
                                final deviceUuid = await DeviceIdHelper.getDeviceUuid();
                                final deviceName = await DeviceIdHelper.getDeviceName();

                                loginCubit.login(
                                  loginCubit.username,
                                  loginCubit.password,
                                  deviceUuid,
                                  deviceName,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Log In',
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(
                                  fontSize: responsive.responsiveTextSize(16, 18, 20),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: size.height * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 2,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: responsive.responsiveValue(
                              small: 10.0, medium: 20.0, large: 30.0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.remove('licenseActivated');
                                  await prefs.remove('licenseKey');
                                  await prefs.remove('licenseSchoolUdise');
                                  await prefs.remove('licenseValidUntil');
                                  await prefs.remove('licenseMaxDevices');
                                  await prefs.remove('licenseRegisteredDevices');
                                  await prefs.remove('imageAllowed');
                                  if (context.mounted) {
                                    Navigator.pushNamed(context, RoutesName.licenseActivationScreen);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: size.height * 0.055),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child:Text('Activate License',
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontSize: responsive.responsiveTextSize(16, 18, 20),
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                            ),
                            // SizedBox(
                            //   child: Text(
                            //     'OR',
                            //     style: TextStyle(
                            //       color: Colors.grey.shade400,
                            //       fontSize: 12,
                            //       fontWeight: FontWeight.bold,
                            //     ),
                            //   )
                            // ),

                            ElevatedButton(
                                onPressed: (){
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    RoutesName.librarianRegistrationScreen,
                                        (route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: EdgeInsets.symmetric(vertical: 15,horizontal: size.height * 0.09),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                ),
                                child: Text('Register',
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                      fontSize: responsive.responsiveTextSize(16, 18, 20),
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                            ),
                          ],
                        ),
                        // Center(
                        //   child: TextButton(
                        //     onPressed: () async {
                        //       final prefs = await SharedPreferences.getInstance();
                        //       await prefs.remove('licenseActivated');
                        //       await prefs.remove('licenseKey');
                        //       await prefs.remove('licenseSchoolUdise');
                        //       await prefs.remove('licenseValidUntil');
                        //       await prefs.remove('licenseMaxDevices');
                        //       await prefs.remove('licenseRegisteredDevices');
                        //       await prefs.remove('imageAllowed');
                        //       if (context.mounted) {
                        //         Navigator.pushNamed(context, RoutesName.licenseActivationScreen);
                        //       }
                        //     },
                        //     child: const Text(
                        //       "Activate License",
                        //       style: TextStyle(
                        //         color: AppColors.secondary,
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.bold,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // Center(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       const Text(
                        //         'New user ?',
                        //       ),
                        //       TextButton(
                        //         onPressed: () async {
                        //           if (context.mounted) {
                        //             Navigator.pushReplacementNamed(context, RoutesName.librarianRegistrationScreen);
                        //           }
                        //         },
                        //         child: const Text(
                        //           "Register",
                        //           style: TextStyle(
                        //             color: Colors.blue,
                        //             // fontSize: 16,
                        //             // fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
    await prefs.setBool('initialSyncDone', false); // Mark that initial sync is needed
  }
}
