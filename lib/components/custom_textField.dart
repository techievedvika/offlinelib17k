import 'package:flutter/material.dart';

import '../configs/color/color.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? textController;
  final IconData? prefixIcon;
  final String? hintText;
  final String? labelText;
  final IconButton? suffixIcon;
  final bool? obscureText;
  final bool? readOnly;
  final TextInputType? textInputType;
  final int? maxlength;
  final int? maxlines;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged; // Updated to void return type
  final void Function()? onEditingComplete; // Updated to void return type
  final FocusNode? focusNode;
  final Function()? onTap;

  const CustomTextFormField({
    super.key,
    this.textController,
    this.prefixIcon,
    this.hintText,
    this.maxlength,
    this.labelText,
    this.suffixIcon,
    this.obscureText,
    this.textInputType,
    this.maxlines,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.onChanged, // Updated type
    this.focusNode,
    this.onEditingComplete, // Updated type
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
     controller: textController,
      obscureText: obscureText ?? false,
      readOnly: readOnly ?? false,
      maxLength: maxlength,
      focusNode: focusNode,
      keyboardType: textInputType,
      maxLines: maxlines ?? 1,
      onChanged: onChanged, // Correct usage
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Field must be filled';
            }
            return null;
          },
      onFieldSubmitted: (value) {
        if (onEditingComplete != null) {
          onEditingComplete!();
        }
      },
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        prefixIconColor: AppColors.outline,
        suffixIconColor: AppColors.outline,
        label: labelText != null
            ? Text(
                labelText!,
                style: AppStyles.captionText(context, AppColors.outline, 11),
              )
            : null,
        hintText: hintText ?? '',
        floatingLabelStyle: const TextStyle(color: AppColors.primary),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: AppColors.onBackground,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: AppColors.outline),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1, color: AppColors.error),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 2, color: AppColors.error),
        ),
      ),
    );
  }
}
