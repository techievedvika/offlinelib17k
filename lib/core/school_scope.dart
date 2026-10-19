import 'package:shared_preferences/shared_preferences.dart';

/// The logged-in user's school, read from the values saved at login.
/// Empty string = no school (e.g. Super-Admin) -> no filtering.
class SchoolScope {
  static Future<String> udise() async {
    final p = await SharedPreferences.getInstance();
    return (p.getString('schoolUdise') ??
        p.getString('school_udise') ??
        p.getString('licenseSchoolUdise') ??
        '')
        .trim();
  }

  static Future<String> schoolName() async {
    final p = await SharedPreferences.getInstance();
    return (p.getString('school') ?? '').trim();
  }
}