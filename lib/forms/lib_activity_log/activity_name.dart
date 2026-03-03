import 'package:flutter/cupertino.dart';

import '../../components/custom_textField.dart';

class ActivityNameInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const ActivityNameInput({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      labelText: 'Activity Name',
      onChanged: onChanged,
      validator: (v) => v!.isEmpty ? 'Please enter an activity name' : null,
    );
  }
}