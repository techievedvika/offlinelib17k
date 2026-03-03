import 'package:flutter/cupertino.dart';

import '../../components/custom_textField.dart';

class DescriptionInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const DescriptionInput({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      labelText: 'Activity Description',
      maxlines: 4,
      onChanged: onChanged,
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return 'Please enter a description';
        } else if (v.trim().length < 25) {
          return 'Description must be at least 25 characters long';
        }
        return null;
      },
    );
  }
}