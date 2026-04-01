import 'package:flutter/cupertino.dart';

import '../../components/custom_labeltext.dart';
import '../../components/custom_textField.dart';

class ActivityNameInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const ActivityNameInput({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(label: "Activity Name"),
        const SizedBox(height: 10),
        CustomTextFormField(
          hintText: 'Activity Name',
          onChanged: onChanged,
          validator: (v) => v!.isEmpty ? 'Please enter an activity name' : null,
        ),
      ],
    );
  }
}