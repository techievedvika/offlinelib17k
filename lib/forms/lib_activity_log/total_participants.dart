import 'package:flutter/cupertino.dart';

import '../../components/custom_labeltext.dart';
import '../../components/custom_textField.dart';

class TotalParticipantsInput extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const TotalParticipantsInput({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelText(label: "Activity No. of Participants"),
        const SizedBox(height: 10),
        CustomTextFormField(
          hintText: 'Total Participants',
          onChanged: onChanged,
          textInputType: TextInputType.number,
          validator: (v) => v!.isEmpty ? 'Please enter the number of participants' : null,
        ),
      ],
    );
  }
}