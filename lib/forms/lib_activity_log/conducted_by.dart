import 'package:flutter/cupertino.dart';

import '../../components/custom_labeltext.dart';
import '../../components/custom_textField.dart';

class ConductedByInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const ConductedByInput({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(label: "Activity Conducted by"),
        const SizedBox(height: 10),
        CustomTextFormField(
          hintText: 'Activity Conducted by',
          onChanged: onChanged,
          validator: (v) => v!.isEmpty ? 'Please enter who conducted the activity' : null,
        ),
      ],
    );
  }
}