import 'package:flutter/material.dart';
import 'package:lib17000ft/configs/color/color.dart';
class DynamicRadio extends FormField<String> {
  final List<dynamic> options;
  // final FocusNode focusNode;
  final int? gridcount;

  DynamicRadio({
    super.key,
    required String? selectedOption,
    this.gridcount,
    required this.options,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
    // required this.focusNode,
  }) : super(
          initialValue: selectedOption,
          onSaved: onChanged,
          validator: (value) {
            final result = validator?.call(value);
           
            return result;
          },
          builder: (FormFieldState<String> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Focus(
                 // focusNode: focusNode,
                  child: GridView.count(
                    crossAxisCount: gridcount ?? 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: MediaQuery.of(field.context).size.width /
                        (MediaQuery.of(field.context).size.height / 20),
                    children: options.map((dynamic option) {
                      return RadioListTile<String>(
                        title: Text(option, style: const TextStyle(fontSize: 13)),
                        value: option,
                        groupValue: field.value,
                        activeColor: AppColors.primary,
                        onChanged: (value) {
                          field.didChange(value);
                          onChanged(value);
                        },
                      );
                    }).toList(),
                  ),
                ),
                if (field.hasError)
                  Text(
                    field.errorText!,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            );
          },
        );
}

// class ResettableRadio extends StatefulWidget {
//   final List<String> options;
//   final ValueChanged<String?> onChanged;
//   final String? selectedOption;
//
//   const ResettableRadio({
//     super.key,
//     required this.options,
//     required this.onChanged,
//     this.selectedOption,
//   });
//
//   @override
//   ResettableRadioState createState() => ResettableRadioState();
// }
//
// class ResettableRadioState extends State<ResettableRadio> {
//   String? selectedOption;
//
//   @override
//   void initState() {
//     super.initState();
//     selectedOption = widget.selectedOption; // Initialize selection
//   }
//
//   void _onOptionSelected(String option) {
//     setState(() {
//       selectedOption = option;
//       widget.onChanged(selectedOption);
//     });
//   }
//
//   void resetSelection() {
//     setState(() {
//       selectedOption = null;
//       widget.onChanged(null);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: widget.options.map((option) {
//         return InkWell(
//           onTap: () => _onOptionSelected(option),
//           child: Row(
//             children: [
//               Radio<String>(
//                 value: option,
//                 groupValue: selectedOption,
//                 onChanged: (value) => _onOptionSelected(option),
//               ),
//               Text(option),
//             ],
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
class ResettableRadio extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String? selectedOption;
  final String? Function(String?)? validator;

  const ResettableRadio({
    super.key,
    required this.options,
    required this.onChanged,
    this.selectedOption,
    this.validator,
  });

  @override
  ResettableRadioState createState() => ResettableRadioState();
}

class ResettableRadioState extends State<ResettableRadio> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
  }

  void _onOptionSelected(String option) {
    setState(() {
      selectedOption = option;
      widget.onChanged(selectedOption);
    });
  }

  void resetSelection() {
    setState(() {
      selectedOption = null;
      widget.onChanged(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: widget.options.map((option) {
                return InkWell(
                  onTap: () => _onOptionSelected(option),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: selectedOption,
                        onChanged: (value) => _onOptionSelected(option),
                      ),
                      Text(option),
                    ],
                  ),
                );
              }).toList(),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  state.errorText ?? '',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        );
      },
    );
  }
}
