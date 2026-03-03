import 'package:flutter/cupertino.dart';

import '../../components/custom_textField.dart';

class ConductedByInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const ConductedByInput({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      labelText: 'Activity Conducted by',
      onChanged: onChanged,
      validator: (v) => v!.isEmpty ? 'Please enter who conducted the activity' : null,
    );
  }
}