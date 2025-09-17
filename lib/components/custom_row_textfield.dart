
import 'package:flutter/material.dart';
import 'package:lib17000ft/components/component.dart';

@immutable

class CustomFieldWithTextController extends StatefulWidget {
final  String? labelText;
 final String? sizedBox;
  final double? sizedBoxValue;
 final TextEditingController? editingController;
 final bool? required;
 final String? hintText;
 final TextInputType? inputType;
 final int? maxLines;
 final FocusNode? focusNode;
  final FormFieldValidator<String>? validate;
 final String? Function(String?)? onSaved;
  
  const CustomFieldWithTextController({
    super.key,
    this.labelText,
    this.sizedBox,
    this.sizedBoxValue,
    this.editingController,
    this.required,
    this.hintText,
    this.inputType,
    this.validate,
    this.maxLines,
    this.onSaved,
    this.focusNode,
  });

  @override
  State<CustomFieldWithTextController> createState() =>
      _CustomFieldWithTextControllerState();
}

class _CustomFieldWithTextControllerState
    extends State<CustomFieldWithTextController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LabelText(
          label: widget.labelText ?? '',
          astrick: widget.required ?? false,
        ),
        CustomSizedBox(
          value: widget.sizedBoxValue ?? 10,
          side: widget.sizedBox ?? '',
        ),
        CustomTextFormField(
          focusNode: widget.focusNode,
        //  onSaved: widget.onSaved,
            textController: widget.editingController,
            maxlines: widget.maxLines ?? 1,
            labelText: widget.hintText ?? '',
            textInputType: widget.inputType,
            validator: widget.validate),
      ],
    );
  }
}
