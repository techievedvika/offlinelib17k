import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add this import
import 'package:intl/intl.dart';
import 'package:lib17000ft/forms/student/student_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';
import '../../components/custom_dropdown.dart';
import '../../components/custom_labeltext.dart';
import '../../components/custom_textField.dart';
import '../../configs/color/color.dart';
import '../../models/student_registration/student_model.dart';

class EditStudentScreen extends StatefulWidget {
  final StudentModel? student;
  final bool? skipOption;

  const EditStudentScreen({super.key, this.student, this.skipOption});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController rollNoController;
  late TextEditingController gradeController;
  final TextEditingController apaarIdController = TextEditingController();
  final TextEditingController penIdController = TextEditingController();
  final TextEditingController studentIdController = TextEditingController();
  late TextEditingController schoolController ;
  // late TextEditingController statusController;
  late TextEditingController reasonController;

  String gender = '';
  String? gradeValue;
  List<String> _gradeOptions = [];
  bool _isLoadingGrades = true;
  String? status;

  final List<String> idOptions = ["Apaar ID", "PEN ID", "Student ID"];
  String? selectedValue;
  int selectedIndex = 0;

  bool isVisible = false;
  bool stdIdEdit = false;


  @override
  void initState() {
    super.initState();
    // Pre-fill data from StudentModel
    nameController = TextEditingController(text: widget.student?.name);
    rollNoController = TextEditingController(text: widget.student?.rollNo);
    gradeController = TextEditingController(text: widget.student?.classs);
    schoolController = TextEditingController(text: widget.student?.school);
    reasonController = TextEditingController(text: widget.student?.reason ?? '');
    // if(widget.student?.apaarId == 'NA' && widget.student?.uniqueId == 'NA'){
    //   penIdController.text = (widget.student?.penId)!;
    //   selectedValue = "PEN ID";
    //   selectedIndex = 1;
    //   print("Pen Id : ${penIdController.text = (widget.student?.penId)!}");
    // }
    // else if(widget.student?.apaarId == 'NA' && widget.student?.penId == 'NA'){
    //   studentIdController.text = (widget.student?.uniqueId)!;
    //   selectedValue = "Student ID";
    //   selectedIndex = 2;
    // }
    //   print("Student Id : ${studentIdController.text = (widget.student?.uniqueId)!}");
    // }
    // else if(widget.student?.uniqueId == 'NA' && widget.student?.penId == 'NA') {
    //   apaarIdController.text = (widget.student?.apaarId)!;
    //   selectedValue = "Apaar ID";
    //   selectedIndex = 0;
    //   print("Apaar Id : ${apaarIdController.text = (widget.student?.apaarId)!}");
    // }
    if (widget.student?.apaarId != null && widget.student?.apaarId != 'NA') {
      apaarIdController.text = widget.student!.apaarId!;
      selectedValue = "Apaar ID";
      selectedIndex = 0;
    }
    if (widget.student?.penId != null && widget.student?.penId != 'NA') {
      penIdController.text = widget.student!.penId!;
      selectedValue = "PEN ID";
      selectedIndex = 1;
    }
    if (widget.student?.uniqueId != null && widget.student?.uniqueId != 'NA') {
      studentIdController.text = widget.student!.uniqueId!;
      selectedValue = "Student ID";
      selectedIndex = 2;
    }

    // apaarIdController.text = (widget.student?.apaarId)!;
    // penIdController.text = (widget.student?.penId)!;
    // studentIdController.text = (widget.student?.uniqueId)!;
    gender = widget.student?.gender ?? '';
    gradeValue = widget.student?.classs;
    if (widget.student?.status == "1" || widget.student?.status == 1) {
      status = "Active";
    } else if (widget.student?.status == "0" || widget.student?.status == 0) {
      status = "Inactive";
    } else {
      status = widget.student?.status?.toString(); // Fallback
    }

    print("Student Detail ${widget.student}");

    context.read<StudentCubit>().fetchGrades();
  }

  @override
  void dispose() {
    nameController.dispose();
    rollNoController.dispose();
    gradeController.dispose();
    apaarIdController.dispose();
    schoolController.dispose();
    // statusController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
  }
  // Simplified local method that calls the Cubit
  void _onUpdatePressed() {
    print('Grade : $gradeValue');
    if (_formKey.currentState!.validate()) {

      String statusIndex = (status == "Active") ? "1" : "0";

      // if(penIdController.text.trim() != ""){
      //   apaarIdController.text = "NA";
      //   studentIdController.text = "NA";
      //   rollNoController.clear();
      // }
      //
      // if(apaarIdController.text.trim() != ""){
      //   penIdController.text = "NA" ;
      //   studentIdController.text = "NA";
      //   rollNoController.clear();
      // }
      //
      // if(studentIdController.text.trim() != ""){
      //   apaarIdController.text = "NA";
      //   penIdController.text = "NA";
      //   rollNoController.clear();
      // }
      //
      // final updatedStudent = StudentModel(
      //   id: widget.student?.id,
      //   createdBy: widget.student?.createdBy,
      //   name: nameController.text.trim(),
      //   rollNo: rollNoController.text.trim(),
      //   //classs: gradeController.text.trim(),
      //   classs: gradeValue!.trim(),
      //   gender: gender,
      //   apaarId: apaarIdController.text.trim(),
      //   penId: penIdController.text.trim(),
      //   uniqueId: studentIdController.text.trim(),
      //   school: schoolController.text.trim(),
      //   status: statusIndex,
      //   reason: status == "Active" ? "" : reasonController.text.trim(),
      // );
      // Initialize all as NA
      String finalApaar = "NA";
      String finalPen = "NA";
      String finalUnique = "NA";

      // Assign value based on the selected index in the UI
      if (selectedIndex == 0) {
        finalApaar = apaarIdController.text.trim().isEmpty ? "NA" : apaarIdController.text.trim();
      } else if (selectedIndex == 1) {
        finalPen = penIdController.text.trim().isEmpty ? "NA" : penIdController.text.trim();
      } else if (selectedIndex == 2) {
        finalUnique = studentIdController.text.trim().isEmpty ? "NA" : studentIdController.text.trim();
      }

      final updatedStudent = StudentModel(
        id: widget.student?.id,
        createdBy: widget.student?.createdBy,
        name: nameController.text.trim(),
        rollNo: rollNoController.text.trim(),
        classs: gradeValue?.trim() ?? "",
        gender: gender,
        apaarId: finalApaar,
        penId: finalPen,
        uniqueId: finalUnique,
        school: schoolController.text.trim(),
        status: statusIndex,
        reason: status == "Active" ? "" : reasonController.text.trim(),
      );

      print("Student Details: $updatedStudent");
      // Trigger the Cubit
      context.read<StudentCubit>().updateStudent(updatedStudent);

      Navigator.pop(context);

    }
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppbar(
        title: 'Edit Student',
        backbutton: true,
      ),

      body: BlocListener<StudentCubit, StudentState>(
        listener: (context, state) {

          if (state is GradesSuccess) {
            setState(() {
              _gradeOptions = state.grades;
              _isLoadingGrades = false;
            });
          } else if (state is GradesFailure) {
            setState(() {
              _isLoadingGrades = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error loading grades: ${state.message}")),
            );
          }

          if (state is StudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
             Navigator.pop(context); // Go back after successful update
            _resetForm();
            //Navigator.pushReplacementNamed(context, '/all_student');
          } else if (state is StudentFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.primaryContainer),
            );

            Future.delayed(const Duration(seconds: 2),(){
                Navigator.pushReplacementNamed(context, '/all_student');
              });

          }
        },
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16, // ← key fix
          ),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                LabelText(label: 'Student Name',astrick: true,),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText: 'Student Name',
                  textController: nameController,
                ),
                const SizedBox(height: 14),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LabelText(label: 'Student ID',astrick: true,),
                    IconButton(
                      icon: const Icon(Icons.edit,size: 16),
                      onPressed: (){
                        setState(() {
                          stdIdEdit = !stdIdEdit;
                        });
                      }
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText: 'Student ID',
                  textController: rollNoController,
                  readOnly: true,
                ),
                const SizedBox(height: 14),
                if(stdIdEdit == true)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LabelText(label: 'Edit Student ID',astrick: true,),
                      const SizedBox(height: 14),
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
                          textController: apaarIdController,
                          validator: (value) {
                            if (value != null && value.isNotEmpty &&
                                value.length != 12) {
                              return 'APAAR ID must be 12 characters long';
                            }
                            return null;
                          },
                        ),
                      if(selectedIndex == 1)
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
                          textController: penIdController,
                          validator: (value) {
                            if (value != null && value.isNotEmpty &&
                                value.length != 11) {
                              return 'APAAR ID must be 11 characters long';
                            }
                            return null;
                          },
                        ),
                      if(selectedIndex == 2)
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
                          textController: studentIdController,
                        ),
                    ],
                  ),

                const SizedBox(height: 14),
                LabelText(label: 'Student Grade',astrick: true,),
                const SizedBox(height: 10),
                // CustomTextFormField(
                //   labelText: 'Student Grade',
                //   textController: gradeController,
                //   readOnly: false,
                // ),
                _isLoadingGrades
                    ? const Center(child: CircularProgressIndicator())
                    : CustomDropdownFormField(
                  height: size.height * 0.5,
                  labelText: 'Select Grade',
                  options: _gradeOptions,
                  selectedOption: gradeValue, // Auto-fills with current value
                  onChanged: (value) {
                    setState(() {
                      gradeValue = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select a grade";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                LabelText(label: 'Student Gender',astrick: true,),
                const SizedBox(height: 10),
                CustomDropdownFormField(
                  labelText: "Gender",
                  options: const ["Male", "Female", "Other"],
                  selectedOption: gender,
                  onChanged: (value) {
                    setState(() {
                      gender = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select gender";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                // LabelText(label: 'Student ID',astrick: true,),
                // const SizedBox(height: 10),
                // CustomDropdownFormField(
                //   options: idOptions,
                //   selectedOption: selectedValue,
                //   labelText: "Select ID Type",
                //   onChanged: (value) {
                //     setState(() {
                //       selectedValue = value;
                //
                //       // Convert value to index
                //       selectedIndex = idOptions.indexOf(value!);
                //     });
                //
                //     print("Selected Value: $selectedValue");
                //     print("Selected Index: $selectedIndex");
                //   },
                // ),
                // const SizedBox(height: 12),
                // if(selectedIndex == 0)
                //   CustomTextFormField(
                //     suffixIcon: IconButton(
                //       icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                //       onPressed: () {
                //         setState(() {
                //           isVisible = !isVisible;
                //         });
                //       },
                //     ),
                //     obscureText: !isVisible,
                //     maxlength: 12,
                //     labelText: 'Enter APAAR ID',
                //     textInputType: TextInputType.number,
                //     textController: apaarIdController,
                //     validator: (value) {
                //       if (value != null && value.isNotEmpty &&
                //           value.length != 12) {
                //         return 'APAAR ID must be 12 characters long';
                //       }
                //       return null;
                //     },
                //   ),
                // if(selectedIndex == 1)
                //   CustomTextFormField(
                //     suffixIcon: IconButton(
                //       icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                //       onPressed: () {
                //         setState(() {
                //           isVisible = !isVisible;
                //         });
                //       },
                //     ),
                //     obscureText: !isVisible,
                //     maxlength: 11,
                //     labelText: 'Enter PEN ID',
                //     textInputType: TextInputType.number,
                //     textController: penIdController,
                //     validator: (value) {
                //       if (value != null && value.isNotEmpty &&
                //           value.length != 11) {
                //         return 'APAAR ID must be 11 characters long';
                //       }
                //       return null;
                //     },
                //   ),
                // if(selectedIndex == 2)
                //   CustomTextFormField(
                //     suffixIcon: IconButton(
                //       icon: isVisible ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off),
                //       onPressed: () {
                //         setState(() {
                //           isVisible = !isVisible;
                //         });
                //       },
                //     ),
                //     obscureText: !isVisible,
                //     labelText: 'Enter student ID',
                //     textController: studentIdController,
                //   ),
                //
                // const SizedBox(height: 14),
                LabelText(label: 'Student School'),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText: 'Student School',
                  textController: schoolController,
                  readOnly: true,
                ),
                const SizedBox(height: 14),
                LabelText(label: 'Student Status', astrick: true,),
                const SizedBox(height: 10),
                CustomDropdownFormField(
                  labelText: "Status",
                  options: const ["Active", "Inactive"],
                  selectedOption: status,
                  onChanged: (value) {
                    setState(() {
                      status = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please select value";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                if (status == "Inactive")
                LabelText(label: 'Reason for remove Student'),
                const SizedBox(height: 10),
                if (status == "Inactive")
                CustomDropdownFormField(
                  labelText: "Reason",
                  options: const [
                    "Student move to Higher School",
                    "Student leave School",
                    "Student transferred to another school",
                    "Other"
                  ],
                  // FIX 3: Ensure selectedOption is null if the text is empty or doesn't match list
                  selectedOption: (reasonController.text.isEmpty) ? null : reasonController.text,
                  onChanged: (value) {
                    setState(() {
                      reasonController.text = value!;
                    });
                  },
                  validator: (value) {
                    // Only require reason if the status is set to Inactive
                    if (status == "Inactive" && (value == null || value.isEmpty)) {
                      return "Please select reason";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Use BlocBuilder here if you want to show a loading spinner on the button
                //if(widget.skipOption != true)
                BlocBuilder<StudentCubit, StudentState>(
                  builder: (context, state) {
                    return CustomButton(
                      onPressedButton: state is StudentLoading ? null : _onUpdatePressed,
                      title: state is StudentLoading ? "Updating..." : "Update",
                    );
                  },
                ),
                SizedBox(width: size.width * 0.001),
                if(widget.skipOption == true)
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Proceed without updating"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}