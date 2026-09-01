// // ignore_for_file: deprecated_member_use
//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lib17000ft/components/component.dart';
// import 'package:lib17000ft/forms/dashboard/dash_cubit.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../components/custom_appbar.dart';
// import '../../models/student_registration/student_model.dart';
// import 'student_cubit.dart';
//
// class StudentRegistration extends StatefulWidget {
//   const StudentRegistration({super.key});
//
//   @override
//   State<StudentRegistration> createState() => _StudentRegistrationState();
// }
//
// class _StudentRegistrationState extends State<StudentRegistration> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _rollNoController = TextEditingController();
//   final TextEditingController _dynamicIdController = TextEditingController();
//   final TextEditingController _apparController = TextEditingController();
//   final _radioKey = GlobalKey<_ResettableRadioState>(); // Key for resetting
//   final _idKey = GlobalKey<_ResettableRadioState>(); // Key for resetting
//   Key dropdownKey = UniqueKey();
//   String? genderValue;
//   String? gradeValue;
//   String? idValue;
//   String? studentJsonData;
//   String? userId;
//   String? location;
//   bool? verifyStudent = false;
//   //variable for grades
//   List<String> _gradesOptions = [];
//   bool _isLoadingGrades = true;
//
//   // String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserId();
//     //To read(Fetch) list of grades from database
//     context.read<StudentCubit>().fetchGrades();
//   }
//
//   generateQr(String studentdata) {
//     generateIdCard(studentdata);
//   }
//
//   Future<void> _loadUserId() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       userId = prefs.getString('userId');
//       location = prefs.getString('location');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return WillPopScope(
//       onWillPop: () async {
//         return _showExitConfirmationDialog(context);
//       },
//       child: Scaffold(
//         appBar: const CustomAppbar(
//           title: 'Student Registration',
//           backbutton: true,
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 BlocConsumer<StudentCubit, StudentState>(
//                     listener: (context, state) {
//                       //Handle Grade fetching states
//                       if (state is GradesSuccess) {
//                         setState(() {
//                           _gradesOptions = state.grades;
//                           _isLoadingGrades = false; // <<< THIS IS THE FIX
//                         });
//                       }
//                       if (state is GradesFailure) {
//                         setState(() {
//                           _isLoadingGrades = false; // Stop loading on error
//                         });
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(state.message)),
//                         );
//                       }
//
//                       //Handle student ID state
//                   if (state is StudentIdSuccess) {
//                     setState(() {
//                       _dynamicIdController.text = state.studentId;
//                     });
//                   }
//                   if (state is StudentFailure) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(state.message),
//                         backgroundColor: AppColors.primary,
//                       ),
//                     );
//                   }
//                 }, builder: (context, state) {
//                   return Form(
//                     key: _formKey,
//                     child: Column(children: [
//                       LabelText(
//                         label: 'Does student have unique ID?',
//                         astrick: true,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       ResettableRadio(
//                         options: const ['Yes', 'No'],
//                         key: _idKey,
//                         onChanged: (value) {
//                           if (value == 'No') {
//                             context.read<StudentCubit>().getStudentId(location!);
//                             //_rollNoController.text =  context.read<StudentCubit>().st
//                           }
//                           setState(() {
//                             idValue = value;
//                           });
//                         },
//                         validator: (value) {
//                           // print('Validator gender value: $genderValue');
//                           if (idValue == null || idValue!.isEmpty) {
//                             return 'Please select an option';
//                           }
//
//                           return null;
//                         },
//                       ),
//                       if (idValue == 'No') ...[
//                         LabelText(
//                           label: 'Student ID',
//                           astrick: true,
//                         ),
//                         CustomTextFormField(
//                           readOnly: true,
//                           labelText: 'Enter student ID',
//                           onChanged: (value) {
//                             _dynamicIdController.text = value;
//                           },
//                           textController: _dynamicIdController,
//                         ),
//                       ],
//                       if (idValue == 'Yes') ...[
//                         LabelText(
//                           label: 'Student ID',
//                           astrick: true,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         CustomTextFormField(
//                           labelText: 'Enter student ID',
//                           onChanged: (value) {
//                             _rollNoController.text = value;
//                           },
//                           textController: _rollNoController,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         LabelText(
//                           label: 'APAAR ID',
//                           astrick: false,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         CustomTextFormField(
//                           labelText: 'Enter APAAR ID',
//                           onChanged: (value) {
//                             _apparController.text = value;
//                           },
//                           textController: _apparController,
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return null;
//                             }
//                             if (value.length != 12) {
//                               return 'APAAR ID must be 12 characters long';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       LabelText(
//                         label: 'Student Name',
//                         astrick: true,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       CustomTextFormField(
//                         labelText: 'Enter Student Name',
//                         onChanged: (value) {
//                           _nameController.text = value;
//                         },
//                         textController: _nameController,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       LabelText(
//                         label: 'Select Gender',
//                         astrick: true,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       ResettableRadio(
//                         options: const ['Male', 'Female'],
//                         key: _radioKey,
//                         onChanged: (value) {
//                           setState(() {
//                             genderValue = value;
//                             // print('this is gender Value 1 $genderValue $value');
//                           });
//                         },
//                         validator: (value) {
//                           // print('Validator gender value: $genderValue');
//                           if (genderValue == null || genderValue!.isEmpty) {
//                             return 'Please select a gender';
//                           }
//
//                           return null;
//                         },
//                       ),
//                       LabelText(
//                         label: 'Select Grade',
//                         astrick: true,
//                       ),
//                       const SizedBox(
//                         height: 10,
//                       ),
//                       // CustomDropdownFormField(
//                       //   key: dropdownKey,
//                       //   options: const [
//                       //     'Nursery',
//                       //     'L.K.G',
//                       //     'U.K.G',
//                       //     'Grade 1',
//                       //     'Grade 2',
//                       //     'Grade 3',
//                       //     'Grade 4',
//                       //     'Grade 5',
//                       //     'Grade 6',
//                       //     'Grade 7',
//                       //     'Grade 8',
//                       //     'Grade 9',
//                       //     'Grade 10',
//                       //     'Grade 11',
//                       //     'Grade 12'
//                       //   ],
//                       //   labelText: 'Select Grade',
//                       //   onChanged: (value) {
//                       //     setState(() {
//                       //       gradeValue = value;
//                       //     });
//                       //   },
//                       // ),
//                       ///This is to fetch grades dynamically from database
//                       if (_isLoadingGrades)
//                         const Center(child: CircularProgressIndicator())
//                       else
//                         CustomDropdownFormField(
//                           height: size.height * 0.5,
//                           key: dropdownKey,
//                           options: _gradesOptions, // Use the dynamic list
//                           labelText: 'Select Grade',
//                           onChanged: (value) {
//                             setState(() {
//                               gradeValue = value;
//                             });
//                           },
//                           // Add a validator for the dropdown
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please select a grade';
//                             }
//                             return null;
//                           },
//                         ),
//                       const SizedBox(height: 20),
//                       BlocConsumer<StudentCubit, StudentState>(
//                         listener: (context, state) {
//                           if (state is StudentSuccess) {
//                             setState(() {
//                               verifyStudent = true;
//                             });
//                              context.read<DashCubit>().dashData(adminId: userId!);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(state.message),
//                                 backgroundColor: AppColors.primary,
//                               ),
//                             );
//
//                             resetForm();
//                           }
//                           if (state is StudentFailure) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text(state.message),
//                                 backgroundColor: AppColors.primary,
//                               ),
//                             );
//                           }
//                         },
//                         builder: (context, state) {
//                           if (state is StudentLoading) {
//                             return const CircularProgressIndicator(
//                               backgroundColor: AppColors.primary,
//                             );
//                           }
//                           return CustomButton(
//                             onPressedButton: () {
//                               // print('this is gender Value 2 $genderValue');
//                               if (_formKey.currentState!.validate()) {
//                                 // print('this is gender Value 3 $genderValue');
//
//                                 final student = StudentModel(
//                                     createdBy: userId!.toString(),
//                                     name: _nameController.text,
//                                     rollNo: idValue == 'Yes'
//                                         ? _rollNoController.text
//                                         : _dynamicIdController.text,
//                                     gender: genderValue!,
//                                     classs: gradeValue!,
//                                     apaarId: _apparController.text.isEmpty
//                                         ? 'NA'
//                                         : _apparController.text.toString(),
//                                     school: 'hell',
//                                    id: ' ',
//                                     // uniqueid: 4,
//
//                                     // uniqueid: DateTime.now()
//                                     //     .millisecondsSinceEpoch
//                                     //     .toString(),
//                                     );
//
//                                 context
//                                     .read<StudentCubit>()
//                                     .registerStudent(student.toJson());
//                                 studentJsonData = jsonEncode(student.toJson());
//                                 // StudentIdCard(
//                                 //   studentData: studentJsonData!,
//                                 // );
//                                 _radioKey.currentState?.resetSelection();
//                                 setState(() {
//                                   gradeValue = null;
//                                   gradeValue = '';
//                                   _nameController.clear();
//                                   _rollNoController.clear();
//                                   _apparController.clear();
//                                 });
//                               }
//                             },
//                             title: 'Register',
//                           );
//                         },
//                       ),
//                     ]),
//                   );
//                 }),
//                 // if (studentJsonData != null && verifyStudent == true)
//                 //   ElevatedButton(
//                 //     style: ElevatedButton.styleFrom(
//                 //       backgroundColor:
//                 //           AppColors.primary, // Set your desired color here
//                 //       foregroundColor:
//                 //           AppColors.onPrimary, // Optional: text & icon color
//                 //       padding: const EdgeInsets.symmetric(
//                 //           horizontal: 16, vertical: 12),
//                 //       shape: RoundedRectangleBorder(
//                 //         borderRadius: BorderRadius.circular(8),
//                 //       ),
//                 //     ),
//                 //     onPressed: () {
//                 //       Navigator.push(
//                 //           context,
//                 //           MaterialPageRoute(
//                 //             builder: (context) =>
//                 //                 StudentIdCard(studentData: studentJsonData!),
//                 //           ));
//                 //     },
//                 //     child: const Row(
//                 //       mainAxisSize: MainAxisSize.min,
//                 //       children: [
//                 //         Icon(Icons.remove_red_eye),
//                 //         SizedBox(width: 8),
//                 //         Text(
//                 //           " View ID Card ",
//                 //           style: TextStyle(fontWeight: FontWeight.bold),
//                 //         ),
//                 //       ],
//                 //     ),
//                 //   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   resetForm() {
//     _formKey.currentState?.reset();
//     _nameController.clear();
//     _rollNoController.clear();
//     _dynamicIdController.clear();
//     //Reset Radio button
//     _radioKey.currentState?.resetSelection();
//     _idKey.currentState?.resetSelection();
//
//     setState(() {
//       dropdownKey = UniqueKey();
//       genderValue = null;
//       gradeValue = null;
//       idValue = null;
//       // genderValue = '';
//       // gradeValue = '';
//     });
//   }
//
//   Future<bool> _showExitConfirmationDialog(BuildContext context) async {
//     final bool? result = await showDialog<bool>(
//       context: context,
//       barrierDismissible:
//           false, // Prevent dismissing by tapping outside the dialog
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirmation'),
//           content: const Text('Do you want to Exit?'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('No'),
//               onPressed: () {
//                 Navigator.of(context)
//                     .pop(false); // Return false if user cancels
//               },
//             ),
//             TextButton(
//               child: const Text('Yes'),
//               onPressed: () {
//                 Navigator.of(context).pop(true); // Return true if user confirms
//               },
//             ),
//           ],
//         );
//       },
//     ); // Ensure that the result is a boolean
//     return result ??
//         false; // Return false if result is null // Return false if dialog is dismissed
//   }
//
//   Widget generateIdCard(String studentdata) {
//     // Decode JSON string to get student details
//     Map<String, dynamic> student = jsonDecode(studentdata);
//
//     return Card(
//       elevation: 5,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text("Student Name: ${student['name']}",
//                 style:
//                     const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             Text("Grade: ${student['grade']}"),
//             Text("Roll No: ${student['rollNo']}"),
//             const SizedBox(height: 10),
//             QrImageView(
//               data: studentdata,
//               version: QrVersions.auto,
//               size: 200,
//               gapless: false,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ResettableRadio extends StatefulWidget {
//   final List<String> options;
//   final ValueChanged<String?> onChanged;
//   final String? selectedOption;
//   final String? Function(String?)? validator;
//
//   const ResettableRadio({
//     super.key,
//     required this.options,
//     required this.onChanged,
//     this.selectedOption,
//     this.validator,
//   });
//
//   @override
//   _ResettableRadioState createState() => _ResettableRadioState();
// }
//
// class _ResettableRadioState extends State<ResettableRadio> {
//   String? selectedOption;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedOption = widget.selectedOption;
//   }
//
//   void _onOptionSelected(String option) {
//     setState(() {
//       selectedOption = option;
//       widget.onChanged(selectedOption);
//     });
//   }
//
//   void resetSelection() {
//     setState(() {
//       selectedOption = null;
//       widget.onChanged(null);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FormField<String>(
//       validator: widget.validator,
//       builder: (FormFieldState<String> state) {
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Column(
//               children: widget.options.map((option) {
//                 return InkWell(
//                   onTap: () => _onOptionSelected(option),
//                   child: Row(
//                     children: [
//                       Radio<String>(
//                         value: option,
//                         groupValue: selectedOption,
//                         onChanged: (value) => _onOptionSelected(option),
//                       ),
//                       Text(option),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//             if (state.hasError)
//               Padding(
//                 padding: const EdgeInsets.only(top: 5),
//                 child: Text(
//                   state.errorText ?? '',
//                   style: const TextStyle(color: Colors.red, fontSize: 12),
//                 ),
//               ),
//           ],
//         );
//       },
//     );
//   }
// }
// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib17000ft/components/component.dart';
import 'package:lib17000ft/forms/dashboard/dash_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/custom_appbar.dart';
import '../../models/student_registration/student_model.dart';
import 'student_cubit.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({super.key});

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rollNoController = TextEditingController();
  final TextEditingController _dynamicIdController = TextEditingController();
  final TextEditingController _apparController = TextEditingController();
  final TextEditingController _penController = TextEditingController();

  // Keys for resetting custom form field widgets
  final _genderRadioKey = GlobalKey<_ResettableRadioState>();
  final _idRadioKey = GlobalKey<_ResettableRadioState>();
  Key _dropdownKey = UniqueKey(); // Use a non-final key to allow replacement

  String? genderValue;
  String? gradeValue;
  String? idValue;
  String? studentJsonData;
  String? userId;
  String? location;
  bool? verifyStudent = false;

  // State for dynamically loading grades
  List<String> _gradesOptions = [];
  bool _isLoadingGrades = true;

  final List<String> idOptions = ["APAAR ID", "PEN ID", "Student ID"];
  String? selectedValue;
  int selectedIndex = 0;

  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    // Fetch the list of grades from the database when the widget is initialized
    context.read<StudentCubit>().fetchGrades();
  }

  /// Loads userId and location from SharedPreferences.
  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) { // Best practice: Check if the widget is still in the tree
      setState(() {
        userId = prefs.getString('userId');
        location = prefs.getString('location');
      });
    }
  }

  /// Resets all form fields to their initial state.
  void resetForm() {
    _formKey.currentState?.reset();
    _nameController.clear();
    _rollNoController.clear();
    _dynamicIdController.clear();
    _apparController.clear();

    // Reset custom radio and dropdown widgets using their keys
    _genderRadioKey.currentState?.resetSelection();
    _idRadioKey.currentState?.resetSelection();

    setState(() {
      genderValue = null;
      gradeValue = null;
      idValue = null;
      // OPTIMIZATION: Recreate the dropdown key to force the CustomDropdownFormField to rebuild and clear its selected value.
      _dropdownKey = UniqueKey();
      verifyStudent = false; // Reset verification status
    });
  }

  /// Handles the registration logic when the form is submitted.
  // void _onRegisterPressed() {
  //   if (_formKey.currentState!.validate()) {
  //     final student = StudentModel(
  //       createdBy: userId!,
  //       name: _nameController.text,
  //       rollNo: idValue == 'Yes' ? _rollNoController.text : _dynamicIdController
  //           .text,
  //       gender: genderValue!,
  //       classs: gradeValue!,
  //       apaarId: _apparController.text.isEmpty ? 'NA' : _apparController.text,
  //       penId: _penController.text.isEmpty ? 'NA' : _penController.text,
  //       school: 'hell',
  //       uniqueId: _rollNoController.text,
  //       // Note: This value is hardcoded
  //       id: ' ', // Note: This value is hardcoded
  //     );
  //
  //     final studentData = student.toJson();
  //     print("this is raw data : $studentData");
  //     studentJsonData = jsonEncode(studentData);
  //     print("this is encoded data : $studentJsonData");
  //
  //     // Call the cubit to register the student
  //     context.read<StudentCubit>().registerStudent(studentData);
  //   }
  // }

  // Inside your _StudentRegistrationState where you submit the form:

  void _register() {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> data = {
        'name': _nameController.text.trim(),
        'class': gradeValue, // Dropdown value
        'gender': genderValue, // Radio value
        'created_by': userId, // Ensure this is the ID you got from SharedPreferences
        'apaarId': _apparController.text.trim(),
        'pen_id': _penController.text.trim(), // Ensure you added this controller
        'rollno': idValue == 'No' ? _dynamicIdController.text : _rollNoController.text,
      };

      context.read<StudentCubit>().registerStudent(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return WillPopScope(
      onWillPop: () async {
        return _showExitConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: const CustomAppbar(
          title: 'Student Registration',
          backbutton: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // OPTIMIZATION: Combined two BlocConsumers into one. This single listener now handles all state changes from StudentCubit.
                BlocConsumer<StudentCubit, StudentState>(
                  listener: (context, state) {
                    // Handle Grade fetching states
                    if (state is GradesSuccess) {
                      setState(() {
                        _gradesOptions = state.grades;
                        _isLoadingGrades = false;
                      });
                    } else if (state is GradesFailure) {
                      setState(() {
                        _isLoadingGrades = false; // Stop loading on error
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    }

                    // Handle Student ID state
                    else if (state is StudentIdSuccess) {
                      // OPTIMIZATION: Directly set the text of the controller. No need for setState as TextEditingController is a listenable.
                      _dynamicIdController.text = state.studentId;
                    }

                    // Handle Student Registration states
                    else if (state is StudentSuccess) {
                      setState(() {
                        verifyStudent = true;
                      });
                      // Refresh dashboard data after successful registration
                      context.read<DashCubit>().dashData(adminId: userId!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                      // OPTIMIZATION: Centralized form reset logic into a single method.
                      resetForm();
                    }

                    // Handle all failure states in one place for cleaner code
                    else if (state is StudentFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Align labels to the left
                        children: [
                          LabelText(
                            label: 'Does student have APAAR ID/PEN ID/Student ID?',
                            astrick: true,
                          ),
                          const SizedBox(height: 10),
                          ResettableRadio(
                            key: _idRadioKey,
                            options: const ['Yes', 'No'],
                            onChanged: (value) {
                              if (value == 'No') {
                                context.read<StudentCubit>().getStudentId(location!);

                              }
                              setState(() {
                                idValue = value;
                                _apparController.clear();
                                _penController.clear();
                              });
                            },
                            validator: (value) {
                              if (idValue == null) {
                                return 'Please select an option';
                              }
                              return null;
                            },
                          ),
                          if (idValue == 'No') ...[
                            LabelText(label: 'Student ID', astrick: true),
                            const SizedBox(height: 12),
                            CustomTextFormField(
                              readOnly: true,
                              labelText: 'Student ID',
                              textController: _dynamicIdController,
                            ),
                          ],
                          if (idValue == 'Yes') ...[
                            LabelText(label: 'APAAR ID/PEN ID/Student ID', astrick: true),
                            const SizedBox(height: 12),

                            CustomDropdownFormField(
                              options: idOptions,
                              selectedOption: selectedValue,
                              labelText: "Select ID Type",
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value;

                                  // Convert value to index
                                  selectedIndex = idOptions.indexOf(value!);
                                });

                                print("Selected Value: $selectedValue");
                                print("Selected Index: $selectedIndex");
                              },
                            ),

                            const SizedBox(height: 12),
                            if(selectedIndex == 0)
                            //   LabelText(label: 'APAAR ID', astrick: false),
                            // const SizedBox(height: 10),
                            CustomTextFormField(
                              suffixIcon: IconButton(
                                icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                              ),
                              obscureText: !isVisible,
                              maxlength: 12,
                              labelText: 'Enter APAAR ID',
                              textInputType: TextInputType.number,
                              textController: _apparController,
                              validator: (value) {
                                if (value != null && value.isNotEmpty &&
                                    value.length != 12) {
                                  return 'APAAR ID must be 12 characters long';
                                }
                                return null;
                              },
                            ),
                            if(selectedIndex == 1)
                            //   LabelText(label: 'PEN ID', astrick: false),
                            // const SizedBox(height: 10),
                              CustomTextFormField(
                                suffixIcon: IconButton(
                                  icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      isVisible = !isVisible;
                                    });
                                  },
                                ),
                                obscureText: !isVisible,
                                maxlength: 11,
                                labelText: 'Enter PEN ID',
                                textInputType: TextInputType.number,
                                textController: _penController,
                                validator: (value) {
                                  if (value != null && value.isNotEmpty &&
                                      value.length != 11) {
                                    return 'APAAR ID must be 11 characters long';
                                  }
                                  return null;
                                },
                              ),
                            if(selectedIndex == 2)
                              // LabelText(label: 'Student ID', astrick: false),
                              // const SizedBox(height: 10),
                            CustomTextFormField(
                              suffixIcon: IconButton(
                                icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                              ),
                              obscureText: !isVisible,
                              labelText: 'Enter student ID',
                              textController: _rollNoController,
                            ),
                            // const SizedBox(height: 10),
                            // LabelText(label: 'APAAR ID', astrick: false),
                            // const SizedBox(height: 10),
                            // CustomTextFormField(
                            //   maxlength: 12,
                            //   labelText: 'Enter APAAR ID',
                            //   textInputType: TextInputType.number,
                            //   textController: _apparController,
                            //   validator: (value) {
                            //     if (value != null && value.isNotEmpty &&
                            //         value.length != 12) {
                            //       return 'APAAR ID must be 12 characters long';
                            //     }
                            //     return null;
                            //   },
                            // ),
                          ],
                          const SizedBox(height: 10),
                          LabelText(label: 'Student Name', astrick: true),
                          const SizedBox(height: 10),
                          CustomTextFormField(
                            labelText: 'Enter Student Name',
                            textController: _nameController,
                          ),
                          const SizedBox(height: 10),
                          LabelText(label: 'Select Gender', astrick: true),
                          const SizedBox(height: 10),
                          ResettableRadio(
                            key: _genderRadioKey,
                            options: const ['Male', 'Female'],
                            onChanged: (value) {
                              setState(() {
                                genderValue = value;
                              });
                            },
                            validator: (value) {
                              if (genderValue == null) {
                                return 'Please select a gender';
                              }
                              return null;
                            },
                          ),
                          LabelText(label: 'Select Grade', astrick: true),
                          const SizedBox(height: 10),
                          // Display a loading indicator while grades are being fetched
                          if (_isLoadingGrades)
                            const Center(child: CircularProgressIndicator())
                          else
                            CustomDropdownFormField(
                              key: _dropdownKey,
                              // Use the key that can be reset
                              height: size.height * 0.5,
                              options: _gradesOptions,
                              labelText: 'Select Grade',
                              onChanged: (value) {
                                setState(() {
                                  gradeValue = value;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a grade';
                                }
                                return null;
                              },
                            ),
                          const SizedBox(height: 20),
                          // OPTIMIZATION: The loading indicator is now handled within the builder, removing the need for a second BlocConsumer.
                          if (state is StudentLoading)
                            const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: AppColors.primary,
                              ),
                            )
                          else
                            CustomButton(
                              // onPressedButton: _onRegisterPressed,
                              onPressedButton: _register,
                              title: 'Register',
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // NOTE: Keep your helper methods like _showExitConfirmationDialog and generateIdCard as they were.
  // This example assumes they exist elsewhere in the class.
  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    // Implementation of your dialog
    return (await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Exit'),
            content: const Text('Are you sure you want to exit registration?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
    )) ??
        false;
  }

  // Dummy implementation for missing methods to ensure code is runnable
  void generateIdCard(String studentdata) {
    // Your ID card generation logic here
  }
}

// Dummy implementation for missing widgets to ensure code is runnable
class ResettableRadio extends StatefulWidget {
  final List<String> options;
  final Function(String?) onChanged;
  final String? Function(String?)? validator;

  const ResettableRadio(
      {required Key key, required this.options, required this.onChanged, this.validator})
      : super(key: key);

  @override
  _ResettableRadioState createState() => _ResettableRadioState();
}

class _ResettableRadioState extends State<ResettableRadio> {
  String? _selectedValue;

  void resetSelection() => setState(() => _selectedValue = null);

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (state) =>
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: widget.options
                    .map((option) =>
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: _selectedValue,
                          onChanged: (value) {
                            setState(() => _selectedValue = value);
                            widget.onChanged(value);
                            state.didChange(value);
                          },
                        ),
                        Text(option),
                      ],
                    ))
                    .toList(),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 5.0),
                  child: Text(state.errorText!, style: TextStyle(color: Theme
                      .of(context)
                      .colorScheme
                      .error, fontSize: 12)),
                )
            ],
          ),
    );
  }
}