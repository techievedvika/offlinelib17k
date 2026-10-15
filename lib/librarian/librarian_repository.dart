// lib/librarian/librarian_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../configs/app_urls.dart';
import '../data/network/network_api_services.dart';

class LibrarianRepository {
  final _api = NetworkServicesApi();

  Future<Map<String, dynamic>> registerLibrarian({
    required String name,
    required String number,
    required String schoolId,
    required String username,
    required String password,
    required String designation,
  }) async {
    return await _api.postApi(AppUrls.registerLibrarianApi, {
      'name': name,
      'mobile_number': number,
      'designation': designation,
      'school_id': schoolId,
      'username': username,
      'password': password,
    });
  }

  /// Check school details via getSchoolDetail GET API
  Future<dynamic> getSchoolDetail(String udiseCode) async {
    try {
      final url = '${AppUrls.getSchoolDetail}?udise_code=$udiseCode';
      final response = await _api.getApi(url);

      if (response != null) {
        return response;
      }
      return {'status': 0, 'message': 'No response from server'};
    } catch (e) {
      return {'status': 0, 'message': 'School UDISE code not found: $e'};
    }
  }

  // OTP endpoints return 422/429/502 with a useful message; the shared
  // NetworkServicesApi throws a generic error for those codes, so call directly.
  Future<Map<String, dynamic>> _postOtp(String url, Map<String, String> body) async {
    final response = await http
        .post(Uri.parse(url), headers: {'Accept': 'application/json'}, body: body)
        .timeout(const Duration(seconds: 30));
    Map<String, dynamic> data;
    try {
      final decoded = jsonDecode(response.body);
      data = decoded is Map<String, dynamic> ? decoded : {};
    } catch (_) {
      data = {};
    }
    data['http_code'] = response.statusCode;
    data['message'] ??= 'Something went wrong. Please try again.';
    return data;
  }

  Future<Map<String, dynamic>> sendRegistrationOtp(String mobile) =>
      _postOtp(AppUrls.sendRegistrationOtpApi, {'mobile_number': mobile});

  Future<Map<String, dynamic>> verifyRegistrationOtp(String mobile, String otp) =>
      _postOtp(AppUrls.verifyRegistrationOtpApi, {'mobile_number': mobile, 'otp': otp});
}