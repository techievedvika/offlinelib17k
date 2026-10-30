// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:lib17000ft/core/network/authed_http.dart' as http;
// import '../configs/app_urls.dart';
//
// class LanguageDropdown extends StatelessWidget {
//   final String? selectedLanguage;
//   final ValueChanged<String?> onChanged;
//   final String labelText;
//   final String hintText;
//   final String? Function(String?)? validator;
//   final bool enabled;
//
//   const LanguageDropdown({
//     super.key,
//     required this.selectedLanguage,
//     required this.onChanged,
//     this.labelText = 'Select Language',
//     this.hintText = 'Select Language',
//     this.validator,
//     this.enabled = true,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownSearch<String>(
//
//       enabled: enabled,
//       selectedItem: selectedLanguage != null && selectedLanguage!.isNotEmpty
//           ? selectedLanguage
//           : null,
//       items: (filter, loadProps) async {
//         try {
//           final response = await http
//               .get(Uri.parse(AppUrls.getBookLanguageApi))
//               .timeout(const Duration(seconds: 15));
//
//           if (response.statusCode == 200) {
//             final data = json.decode(response.body);
//
//             List<String> languages = [];
//
//             if (data is Map<String, dynamic> && data['data'] is List) {
//               languages = (data['data'] as List)
//                   .map((e) => e['language'].toString())
//                   .toList();
//             }
//
//             if (filter.isNotEmpty) {
//               languages = languages
//                   .where((item) =>
//                   item.toLowerCase().contains(filter.toLowerCase()))
//                   .toList();
//             }
//
//             return languages;
//           }
//         } catch (e) {
//           debugPrint('Error fetching book languages: $e');
//         }
//
//         return [];
//       },
//       popupProps: const PopupProps.menu(
//         showSearchBox: true,
//       ),
//       decoratorProps: DropDownDecoratorProps(
//         decoration: InputDecoration(
//           //labelText: labelText,
//           hintText: hintText,
//           contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 16),
//           border: const OutlineInputBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8)),
//             borderSide: BorderSide(color: Colors.grey, width: 4),
//
//           ),
//         ),
//       ),
//       onChanged: onChanged,
//       validator: validator ??
//               (val) => (val == null || val.isEmpty) ? 'Please select $labelText' : null,
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lib17000ft/core/network/authed_http.dart' as http;
import '../configs/app_urls.dart';

/// Book language list: fetched online, saved on the phone, used offline.
class LanguageCache {
  static const _key = 'cachedBookLanguages';
  // Used only when the phone has never loaded the list. "Other" lets the user type one.
  static const _fallback = ['Other'];

  static Future<List<String>> read() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_key) ?? [];
    } catch (_) {
      return [];
    }
  }

  static Future<void> _save(List<String> languages) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_key, languages);
    } catch (_) {}
  }

  /// Fetches from the server and saves. Returns null if the server could not be reached.
  static Future<List<String>?> refresh() async {
    try {
      final response = await http
          .get(Uri.parse(AppUrls.getBookLanguageApi))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data['data'] is List) {
          final languages = (data['data'] as List)
              .map((e) => e['language'].toString().trim())
              .where((e) => e.isNotEmpty)
              .toSet()
              .toList();
          if (languages.isNotEmpty) {
            await _save(languages);
            return languages;
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching book languages: $e');
    }
    return null;
  }

  /// Online list if available, otherwise the saved list, otherwise the fallback.
  static Future<List<String>> load() async {
    final fresh = await refresh();
    if (fresh != null) return fresh;
    final saved = await read();
    return saved.isNotEmpty ? saved : _fallback;
  }
}

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
        var languages = await LanguageCache.load();

        // A language auto-filled from a scanned book must stay selectable
        final current = selectedLanguage;
        if (current != null && current.isNotEmpty && !languages.contains(current)) {
          languages = [current, ...languages];
        }

        if (filter.isNotEmpty) {
          languages = languages
              .where((item) => item.toLowerCase().contains(filter.toLowerCase()))
              .toList();
        }
        return languages;
      },
      popupProps: const PopupProps.menu(
        showSearchBox: true,
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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