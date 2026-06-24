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

enum RadioLayout { list, grid }

class ResettableRadio extends StatefulWidget {
  final List<String> options;
  final ValueChanged<String?> onChanged;
  final String? selectedOption;
  final String? Function(String?)? validator;
  final bool isEnabled;
  final RadioLayout layout; // New parameter
  final int gridCount;      // New parameter for grid columns

  const ResettableRadio({
    super.key,
    required this.options,
    required this.onChanged,
    this.selectedOption,
    this.validator,
    this.isEnabled = true,
    this.layout = RadioLayout.list,
    this.gridCount = 2,
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

  @override
  void didUpdateWidget(covariant ResettableRadio oldWidget) {
    super.didUpdateWidget(oldWidget);
    // This checks if the parent (book_issue.dart) has passed a new selectedOption
    if (widget.selectedOption != oldWidget.selectedOption) {
      setState(() {
        selectedOption = widget.selectedOption;
      });
    }
  }


  void _onOptionSelected(String option) {
    if (!widget.isEnabled) return;
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

        // Helper to build individual radio items
        Widget buildRadioItem(String option) {
          return InkWell(
            onTap: widget.isEnabled ? () => _onOptionSelected(option) : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Radio<String>(
                  value: option,
                  groupValue: selectedOption,
                  onChanged: widget.isEnabled ? (value) => _onOptionSelected(option!) : null,
                ),
                Flexible(child: Text(option, style: const TextStyle(fontSize: 13))),
              ],
            ),
          );
        }

        // return Column(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Column(
        //       children: widget.options.map((option) {
        //         return InkWell(
        //           onTap: widget.isEnabled ?  () => _onOptionSelected(option) : null,
        //           child: Row(
        //             children: [
        //               Radio<String>(
        //                 value: option,
        //                 groupValue: selectedOption,
        //                 onChanged: widget.isEnabled ? (value) => _onOptionSelected(option) : null,
        //               ),
        //               Text(option),
        //             ],
        //           ),
        //         );
        //       }).toList(),
        //     ),
        //     if (state.hasError)
        //       Padding(
        //         padding: const EdgeInsets.only(top: 5),
        //         child: Text(
        //           state.errorText ?? '',
        //           style: const TextStyle(color: Colors.red, fontSize: 12),
        //         ),
        //       ),
        //   ],
        // );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.layout == RadioLayout.grid
                ? GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.gridCount,
                childAspectRatio: 3, // Adjust for spacing
              ),
              itemCount: widget.options.length,
              itemBuilder: (context, index) => buildRadioItem(widget.options[index]),
            )
                : Column(
              children: widget.options.map((option) => buildRadioItem(option)).toList(),
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
