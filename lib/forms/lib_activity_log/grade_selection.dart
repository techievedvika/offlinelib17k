import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/custom_checkbox.dart';
import '../../components/custom_labeltext.dart';

class GradesSelection extends StatelessWidget {
  final bool isLoading;
  final List<String> availableGrades;
  final List<String> selectedGrades;
  // This now expects the full list of selections
  final ValueChanged<List<String>> onGradesChanged;

  const GradesSelection({
    required this.isLoading,
    required this.availableGrades,
    required this.selectedGrades,
    required this.onGradesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(label: 'Participating Grades'),
        const SizedBox(height: 10),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (availableGrades.isEmpty)
          const Text('No grades available or failed to load.')
        else
        // Using your actual CustomCheckbox component
          CustomCheckbox(
            options: availableGrades,
            selectedOptions: selectedGrades,
            onChanged: (selection) {
              if (selection != null) {
                onGradesChanged(selection);
              }
            },
          ),
      ],
    );
  }
}