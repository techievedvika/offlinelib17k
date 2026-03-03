import 'package:flutter/material.dart';
import '../configs/color/color.dart';

class CustomDropdownFormField extends StatefulWidget {
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?>? onChanged;
  final String labelText;
  final FocusNode? focusNode;
  final GlobalKey? widgetKey;
  final String? Function(String?)? validator;
  final double? height;

  const CustomDropdownFormField({
    super.key,
    required this.options,
    this.selectedOption,
    required this.onChanged,
    required this.labelText,
    this.focusNode,
    this.validator,
    this.widgetKey,
    this.height,
  });

  @override
  _CustomDropdownFormFieldState createState() => _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600; // Adjust breakpoint as needed

    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownButtonFormField<String>(
          menuMaxHeight: widget.height,
          key: widget.widgetKey,
          focusNode: widget.focusNode,
          value: widget.options.contains(widget.selectedOption)
              ? widget.selectedOption
              : null,
          onChanged: widget.onChanged,
          isExpanded: true, // Important for responsiveness
          items: widget.options.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16, // Responsive font size
                ),
              ),
            );
          }).toList(),
          style: TextStyle(
            fontSize: isSmallScreen ? 14 : 16,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
          decoration: InputDecoration(
            iconColor: AppColors.primary,
            labelText: widget.labelText,
            labelStyle: TextStyle(
              fontSize: isSmallScreen ? 14 : 16,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 12 : 16,
              vertical: isSmallScreen ? 14 : 18,
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: AppColors.onBackground,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 2,
                color: AppColors.primary,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 1,
                color: AppColors.outline,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                width: 2,
                color: AppColors.error,
              ),
            ),
          ),
          validator: widget.validator ?? (value) {
            if (value == null || value.isEmpty) {
              return 'Select an option';
            }
            return null;
          },
        );
      },
    );
  }
}