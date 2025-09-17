import 'package:flutter/material.dart';

class CustomCheckbox extends FormField<List<String>> {
  final List<String> options;
  // final FocusNode focusNode;
  final String? labelText;
  final bool isRequired;

  CustomCheckbox({
    super.key,
    required List<String> selectedOptions,
    required this.options,
    // required this.focusNode,
    this.labelText,
    this.isRequired = false,
    required void Function(List<String>?) onChanged,
    String? Function(List<String>?)? validator,
  }) : super(
          initialValue: selectedOptions,
          onSaved: onChanged,
          validator: (value) {
            final result = validator?.call(value);
            if (result != null && result.isNotEmpty) {
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   Scrollable.ensureVisible(
              //     focusNode.context!,
              //     alignment: 0.5, // Adjust alignment as needed
              //     duration: const Duration(milliseconds: 500), // Scroll animation duration
              //   );
              // });
            }
            return result;
          },
          builder: (FormFieldState<List<String>> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (labelText != null)
                  Text(
                    labelText,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                Focus(
                  // focusNode: focusNode,
                  child: Column(
                    children: options.map((option) {
                      return CheckboxListTile(
                        title: Text(option),
                        value: field.value?.contains(option) ?? false,
                        onChanged: (bool? value) {
                          List<String> currentValue = List.from(field.value ?? []);
                          if (value == true) {
                            currentValue.add(option);
                          } else {
                            currentValue.remove(option);
                          }
                          field.didChange(currentValue);
                          onChanged(currentValue);
                        },
                      );
                    }).toList(),
                  ),
                ),
                if (field.hasError)
                  const Text(
                    'Select an option',
                    style: TextStyle(color: Colors.red),
                  ),
              ],
            );
          },
        );
}
