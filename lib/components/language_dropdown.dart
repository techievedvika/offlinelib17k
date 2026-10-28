import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:lib17000ft/core/network/authed_http.dart' as http;
import '../configs/app_urls.dart';

class LanguageDropdown extends StatelessWidget {
  final String? selectedLanguage;
  final ValueChanged<String?> onChanged;
  final String labelText;
  final String hintText;
  final String? Function(String?)? validator;
  final bool enabled;

  const LanguageDropdown({
    super.key,
    required this.selectedLanguage,
    required this.onChanged,
    this.labelText = 'Select Language',
    this.hintText = 'Select Language',
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(

      enabled: enabled,
      selectedItem: selectedLanguage != null && selectedLanguage!.isNotEmpty
          ? selectedLanguage
          : null,
      items: (filter, loadProps) async {
        try {
          final response = await http
              .get(Uri.parse(AppUrls.getBookLanguageApi))
              .timeout(const Duration(seconds: 15));

          if (response.statusCode == 200) {
            final data = json.decode(response.body);

            List<String> languages = [];

            if (data is Map<String, dynamic> && data['data'] is List) {
              languages = (data['data'] as List)
                  .map((e) => e['language'].toString())
                  .toList();
            }

            if (filter.isNotEmpty) {
              languages = languages
                  .where((item) =>
                  item.toLowerCase().contains(filter.toLowerCase()))
                  .toList();
            }

            return languages;
          }
        } catch (e) {
          debugPrint('Error fetching book languages: $e');
        }

        return [];
      },
      popupProps: const PopupProps.menu(
        showSearchBox: true,
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          //labelText: labelText,
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: Colors.grey, width: 4),

          ),
        ),
      ),
      onChanged: onChanged,
      validator: validator ??
              (val) => (val == null || val.isEmpty) ? 'Please select $labelText' : null,
    );
  }
}
