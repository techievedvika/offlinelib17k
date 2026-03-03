import 'package:flutter/cupertino.dart';

import '../../components/custom_button.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        onPressedButton: onPressed,
        title: 'SUBMIT',
      ),
    );
  }
}