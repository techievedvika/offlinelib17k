import 'dart:io';import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lib17000ft/components/component.dart'; // For AppColors

class CustomImagePicker extends FormField<File> {
  ValueChanged<File?>? onChanged;


  CustomImagePicker({
    super.key,
    this.onChanged,
    super.onSaved,
    super.validator,
  }) : super(
    builder: (FormFieldState<File> state) {

      void updateImage(File? file) {
        state.didChange(file);
        if (onChanged != null) {
          onChanged(file);
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              final picker = ImagePicker();
              final pickedFile = await picker.pickImage(
                source: ImageSource.camera,
                imageQuality: 50, // Optimize for upload
              );
              if (pickedFile != null) {
                // state.didChange(File(pickedFile.path));
                updateImage(File(pickedFile.path));
              }
            },
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: state.hasError ? AppColors.error : Colors.grey.shade400,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade50,
              ),
              child: state.value == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt, color: AppColors.primary, size: 40),
                  const SizedBox(height: 8),
                  Text("Tap to capture book image",
                      style: TextStyle(color: Colors.grey.shade600)),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(state.value!, fit: BoxFit.cover),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.edit, color: Colors.white),
                          // onPressed: () async {
                          //   final picker = ImagePicker();
                          //   final picked = await picker.pickImage(source: ImageSource.camera);
                          //   if (picked != null) state.didChange(File(picked.path));
                          // },
                          onPressed: () async {
                            final picker = ImagePicker();
                            final picked = await picker.pickImage(source: ImageSource.camera);
                            if (picked != null) {
                              File file = File(picked.path);
                              state.didChange(file); // This updates the UI and the internal FormField state
                              if (onChanged != null) {
                                onChanged!(file); // This updates the bookImage variable in book_issue.dart
                              }
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Text(
                state.errorText!,
                style: const TextStyle(color: AppColors.error, fontSize: 12),
              ),
            ),
        ],
      );
    },
  );
}