import 'package:flutter/cupertino.dart';

import '../../components/custom_textField.dart';

class TotalParticipantsInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const TotalParticipantsInput({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      labelText: 'Total No. of Participants',
      onChanged: onChanged,
      textInputType: TextInputType.number,
      validator: (v) => v!.isEmpty ? 'Please enter the number of participants' : null,
    );
  }
}