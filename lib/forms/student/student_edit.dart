import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Add this import
import 'package:lib17000ft/forms/student/student_cubit.dart';
import '../../components/custom_appbar.dart';
import '../../components/custom_button.dart';
import '../../components/custom_dropdown.dart';
import '../../components/custom_labeltext.dart';
import '../../components/custom_textField.dart';
import '../../configs/color/color.dart';
import '../../models/student_registration/student_model.dart';

class EditStudentScreen extends StatefulWidget {
  final StudentModel? student;

  const EditStudentScreen({super.key, this.student});

  @override
  State<EditStudentScreen> createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController rollNoController;
  late TextEditingController classController;
  late TextEditingController apaarIdController;
  late TextEditingController schoolController;

  String gender = '';

  @override
  void initState() {
    super.initState();
    // Pre-fill data from StudentModel
    nameController = TextEditingController(text: widget.student?.name);
    rollNoController = TextEditingController(text: widget.student?.rollNo);
    classController = TextEditingController(text: widget.student?.classs);
    apaarIdController = TextEditingController(text: widget.student?.apaarId);
    schoolController = TextEditingController(text: widget.student?.school);
    gender = widget.student?.gender ?? '';
  }

  @override
  void dispose() {
    nameController.dispose();
    rollNoController.dispose();
    classController.dispose();
    apaarIdController.dispose();
    schoolController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
  }
  // Simplified local method that calls the Cubit
  void _onUpdatePressed() {
    if (_formKey.currentState!.validate()) {
      final updatedStudent = StudentModel(
        id: widget.student?.id,
        createdBy: widget.student?.createdBy,
        name: nameController.text.trim(),
        rollNo: rollNoController.text.trim(),
        classs: classController.text.trim(),
        gender: gender,
        apaarId: apaarIdController.text.trim(),
        school: schoolController.text.trim(),
      );

      // Trigger the Cubit
      context.read<StudentCubit>().updateStudent(updatedStudent);

    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Edit Student',
        backbutton: true,
      ),
      // Wrap the body in BlocListener to handle side effects (SnackBars/Navigation)
      body: BlocListener<StudentCubit, StudentState>(
        listener: (context, state) {
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
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                LabelText(label: 'Student Name',astrick: true,),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText: 'Student Name',
                  textController: nameController,
                ),
                const SizedBox(height: 14),
                LabelText(label: 'Student Roll No'),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText: 'Student Roll No',
                  textController: rollNoController,
                  readOnly: true,
                ),
                const SizedBox(height: 14),
                LabelText(label: 'Student Class',astrick: true,),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText: 'Student Class',
                  textController: classController,
                  readOnly: true,
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
                LabelText(label: 'Student Apaar ID',astrick: true,),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText: 'Student Apaar ID',
                  textController: apaarIdController,
                  readOnly: false,
                  maxlength: 12,
                ),
                const SizedBox(height: 14),
                LabelText(label: 'Student School'),
                const SizedBox(height: 10),
                CustomTextFormField(
                  labelText: 'Student School',
                  textController: schoolController,
                  readOnly: true,
                ),
                const SizedBox(height: 20),

                // Use BlocBuilder here if you want to show a loading spinner on the button
                BlocBuilder<StudentCubit, StudentState>(
                  builder: (context, state) {
                    return CustomButton(
                      onPressedButton: state is StudentLoading ? null : _onUpdatePressed,
                      title: state is StudentLoading ? "Updating..." : "Update",
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}