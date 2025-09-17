// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib17000ft/components/component.dart';
import 'package:lib17000ft/forms/dashboard/dash_cubit.dart';
import 'package:qr_flutter/qr_flutter.dart';
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
  final _radioKey = GlobalKey<_ResettableRadioState>(); // Key for resetting
  final _idKey = GlobalKey<_ResettableRadioState>(); // Key for resetting
  Key dropdownKey = UniqueKey();
  String? genderValue;
  String? gradeValue;
  String? idValue;
  String? studentJsonData;
  String? userId;
  String? location;
  bool? verifyStudent = false;

  // String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  generateQr(String studentdata) {
    generateIdCard(studentdata);
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      location = prefs.getString('location');
    });
  }

  @override
  Widget build(BuildContext context) {
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
                BlocConsumer<StudentCubit, StudentState>(
                    listener: (context, state) {
                  if (state is StudentIdSuccess) {
                    setState(() {
                      _dynamicIdController.text = state.studentId;
                    });
                  }
                  if (state is StudentFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  }
                }, builder: (context, state) {
                  return Form(
                    key: _formKey,
                    child: Column(children: [
                      LabelText(
                        label: 'Does student have unique ID?',
                        astrick: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ResettableRadio(
                        options: const ['Yes', 'No'],
                        key: _idKey,
                        onChanged: (value) {
                          if (value == 'No') {
                            context.read<StudentCubit>().getStudentId(location!);
                            //_rollNoController.text =  context.read<StudentCubit>().st
                          }
                          setState(() {
                            idValue = value;
                          });
                        },
                        validator: (value) {
                          // print('Validator gender value: $genderValue');
                          if (idValue == null || idValue!.isEmpty) {
                            return 'Please select an option';
                          }

                          return null;
                        },
                      ),
                      if (idValue == 'No') ...[
                        LabelText(
                          label: 'Student ID',
                          astrick: true,
                        ),
                        CustomTextFormField(
                          readOnly: true,
                          labelText: 'Enter student ID',
                          onChanged: (value) {
                            _dynamicIdController.text = value;
                          },
                          textController: _dynamicIdController,
                        ),
                      ],
                      if (idValue == 'Yes') ...[
                        LabelText(
                          label: 'Student ID',
                          astrick: true,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          labelText: 'Enter student ID',
                          onChanged: (value) {
                            _rollNoController.text = value;
                          },
                          textController: _rollNoController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        LabelText(
                          label: 'APAAR ID',
                          astrick: false,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextFormField(
                          labelText: 'Enter APAAR ID',
                          onChanged: (value) {
                            _apparController.text = value;
                          },
                          textController: _apparController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return null;
                            }
                            if (value.length != 12) {
                              return 'APAAR ID must be 12 characters long';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(
                        height: 10,
                      ),
                      LabelText(
                        label: 'Student Name',
                        astrick: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        labelText: 'Enter Student Name',
                        onChanged: (value) {
                          _nameController.text = value;
                        },
                        textController: _nameController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      LabelText(
                        label: 'Select Gender',
                        astrick: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ResettableRadio(
                        options: const ['Male', 'Female'],
                        key: _radioKey,
                        onChanged: (value) {
                          setState(() {
                            genderValue = value;
                            // print('this is gender Value 1 $genderValue $value');
                          });
                        },
                        validator: (value) {
                          // print('Validator gender value: $genderValue');
                          if (genderValue == null || genderValue!.isEmpty) {
                            return 'Please select a gender';
                          }

                          return null;
                        },
                      ),
                      LabelText(
                        label: 'Select Grade',
                        astrick: true,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomDropdownFormField(
                        key: dropdownKey,
                        options: const [
                          'Grade 1',
                          'Grade 2',
                          'Grade 3',
                          'Grade 4',
                          'Grade 5',
                          'Grade 6',
                          'Grade 7',
                          'Grade 8',
                          'Grade 9',
                          'Grade 10',
                          'Grade 11',
                          'Grade 12'
                        ],
                        labelText: 'Select Grade',
                        onChanged: (value) {
                          setState(() {
                            gradeValue = value;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      BlocConsumer<StudentCubit, StudentState>(
                        listener: (context, state) {
                          if (state is StudentSuccess) {
                            setState(() {
                              verifyStudent = true;
                            });
                             context.read<DashCubit>().dashData(adminId: userId!);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: AppColors.primary,
                              ),
                            );

                            resetForm();
                          }
                          if (state is StudentFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.message),
                                backgroundColor: AppColors.primary,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is StudentLoading) {
                            return const CircularProgressIndicator(
                              backgroundColor: AppColors.primary,
                            );
                          }
                          return CustomButton(
                            onPressedButton: () {
                              // print('this is gender Value 2 $genderValue');
                              if (_formKey.currentState!.validate()) {
                                // print('this is gender Value 3 $genderValue');

                                final student = StudentModel(
                                    createdBy: userId!.toString(),
                                    name: _nameController.text,
                                    rollNo: idValue == 'Yes'
                                        ? _rollNoController.text
                                        : _dynamicIdController.text,
                                    gender: genderValue!,
                                    classs: gradeValue!,
                                    apaarId: _apparController.text.isEmpty
                                        ? 'NA'
                                        : _apparController.text.toString(),
                                    school: 'hell',
                                   id: ' ',
                                    // uniqueid: 4,

                                    // uniqueid: DateTime.now()
                                    //     .millisecondsSinceEpoch
                                    //     .toString(),
                                    );

                                context
                                    .read<StudentCubit>()
                                    .registerStudent(student.toJson());
                                studentJsonData = jsonEncode(student.toJson());
                                // StudentIdCard(
                                //   studentData: studentJsonData!,
                                // );
                                _radioKey.currentState?.resetSelection();
                                setState(() {
                                  gradeValue = null;
                                  gradeValue = '';
                                  _nameController.clear();
                                  _rollNoController.clear();
                                  _apparController.clear();
                                });
                              }
                            },
                            title: 'Register',
                          );
                        },
                      ),
                    ]),
                  );
                }),
                // if (studentJsonData != null && verifyStudent == true)
                //   ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor:
                //           AppColors.primary, // Set your desired color here
                //       foregroundColor:
                //           AppColors.onPrimary, // Optional: text & icon color
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 16, vertical: 12),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //     onPressed: () {
                //       Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) =>
                //                 StudentIdCard(studentData: studentJsonData!),
                //           ));
                //     },
                //     child: const Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Icon(Icons.remove_red_eye),
                //         SizedBox(width: 8),
                //         Text(
                //           " View ID Card ",
                //           style: TextStyle(fontWeight: FontWeight.bold),
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  resetForm() {
    _nameController.clear();
    _rollNoController.clear();
    _dynamicIdController.clear();
    
    setState(() {
      dropdownKey = UniqueKey();
      genderValue = null;
      gradeValue = null;
      genderValue = '';
      gradeValue = '';
    });
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you want to Exit?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false if user cancels
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if user confirms
              },
            ),
          ],
        );
      },
    ); // Ensure that the result is a boolean
    return result ??
        false; // Return false if result is null // Return false if dialog is dismissed
  }

  Widget generateIdCard(String studentdata) {
    // Decode JSON string to get student details
    Map<String, dynamic> student = jsonDecode(studentdata);

    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Student Name: ${student['name']}",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text("Grade: ${student['grade']}"),
            Text("Roll No: ${student['rollNo']}"),
            const SizedBox(height: 10),
            QrImageView(
              data: studentdata,
              version: QrVersions.auto,
              size: 200,
              gapless: false,
            ),
          ],
        ),
      ),
    );
  }
}

class ResettableRadio extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String? selectedOption;
  final String? Function(String?)? validator;

  const ResettableRadio({
    super.key,
    required this.options,
    required this.onChanged,
    this.selectedOption,
    this.validator,
  });

  @override
  _ResettableRadioState createState() => _ResettableRadioState();
}

class _ResettableRadioState extends State<ResettableRadio> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
  }

  void _onOptionSelected(String option) {
    setState(() {
      selectedOption = option;
      widget.onChanged(selectedOption);
    });
  }

  void resetSelection() {
    setState(() {
      selectedOption = null;
      widget.onChanged(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: widget.options.map((option) {
                return InkWell(
                  onTap: () => _onOptionSelected(option),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: selectedOption,
                        onChanged: (value) => _onOptionSelected(option),
                      ),
                      Text(option),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
