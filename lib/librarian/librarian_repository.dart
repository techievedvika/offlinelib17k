// lib/librarian/librarian_repository.dart
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
  }) async {
    return await _api.postApi(AppUrls.registerLibrarianApi, {
      'name': name,
      'number': number,
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
}