import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class FilterDropdown extends StatelessWidget {
  const FilterDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    required this.isMobile,
  });

  final String? value;
  final String hint;
  final List<String> items;
  final Function(String?) onChanged;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final safeValue = items.contains(value) ? value : null;

    return SizedBox(
      width: isMobile ? double.infinity : 200,
      child: DropdownSearch<String>(
        selectedItem: safeValue,
        items: (filter, props) {
          return items
              .where((item) =>
                  item.toLowerCase().contains(filter.toLowerCase()))
              .toList();
        },
        popupProps: const PopupProps.menu(
          showSearchBox: true,
        ),
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: hint,
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ),
        onChanged: onChanged,
        validator: (val) =>
            (val == null || val.isEmpty) ? 'Please select $hint' : null,
      ),
    );
  }
}
