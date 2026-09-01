import 'package:flutter/material.dart';

import '../configs/color/color.dart';


enum CheckboxLayout { list, grid }

class CustomCheckbox extends FormField<List<String>> {
  final List<String> options;
  // final FocusNode focusNode;
  final String? labelText;
  final bool isRequired;
  final CheckboxLayout layout;
  final int gridCount;

  CustomCheckbox({
    super.key,
    required List<String> selectedOptions,
    required this.options,
    // required this.focusNode,
    this.labelText,
    this.isRequired = false,
    this.layout = CheckboxLayout.list,
    this.gridCount = 2,
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

            Widget buildCheckboxItem(String option) {
              return CheckboxListTile(
                checkColor: AppColors.onPrimary,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero, // Compact for grid
                title: Text(
                  option,
                  style: AppStyles.bodyText(field.context, AppColors.onSurface),
                ),
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
            }

            // return Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: <Widget>[
            //     if (labelText != null)
            //       Text(
            //         labelText,
            //         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //       ),
            //     Focus(
            //       // focusNode: focusNode,
            //       child: Column(
            //         children: options.map((option) {
            //           return CheckboxListTile(
            //             checkColor: AppColors.onPrimary,
            //             activeColor: AppColors.primary,
            //             title: Text(
            //               option,
            //               style: AppStyles.bodyText(field.context, AppColors.onSurface),
            //             ),
            //             value: field.value?.contains(option) ?? false,
            //             onChanged: (bool? value) {
            //               List<String> currentValue = List.from(field.value ?? []);
            //               if (value == true) {
            //                 currentValue.add(option);
            //               } else {
            //                 currentValue.remove(option);
            //               }
            //               field.didChange(currentValue);
            //               onChanged(currentValue);
            //             },
            //           );
            //         }).toList(),
            //       ),
            //     ),
            //     if (field.hasError)
            //       const Text(
            //         'Select an option',
            //         style: TextStyle(color: Colors.red),
            //       ),
            //   ],
            // );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (labelText != null)
                  Text(
                    labelText,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                Focus(
                  child: layout == CheckboxLayout.grid
                      ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: options.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridCount,
                      childAspectRatio: 3.0, // Adjusted for typical tile height
                    ),
                    itemBuilder: (context, index) => buildCheckboxItem(options[index]),
                  )
                      : Column(
                    children: options.map((option) => buildCheckboxItem(option)).toList(),
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
