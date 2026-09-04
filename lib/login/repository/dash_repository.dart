import 'package:drift/drift.dart';
import 'package:lib17000ft/models/dash/dash_model.dart';
import '../../configs/app_urls.dart';
import '../../core/database/tables/database.dart';
import '../../core/di/service_locator.dart';
import '../../data/network/network_api_services.dart';

class DashRepository {
  final _api = NetworkServicesApi();
  final AppDatabase _db = getIt<AppDatabase>();

Future<DashModel?> fetchDashData(
  String id,
  String? from,
  String? to,
  String? stateName,
  String? block,
  String? school,
) async {
  try {
    print(
      'this is data by fetchdashdata $id $from $to $stateName $block $school',
    );
    // Initialize with required id param
    final queryParams = <String, String>{'id': id};

    // Only add filters if both 'from' and 'to' are provided (required pair)
    final hasDateRange = from != null && to != null;

    // Check if user applied any filter
    final bool hasAnyFilter = hasDateRange ||
        (stateName != null && stateName.isNotEmpty) ||
        (block != null && block.isNotEmpty) ||
        (school != null && school.isNotEmpty);

    if (hasAnyFilter) {
  print('filter applied');
  if (from != null && from.isNotEmpty && to != null && to.isNotEmpty) {
    queryParams['from'] = from;
    queryParams['to'] = to;
  }
  if (stateName != null && stateName.isNotEmpty) queryParams['state'] = stateName;
  if (block != null && block.isNotEmpty) queryParams['block'] = block;
  if (school != null && school.isNotEmpty) queryParams['school'] = school;
}


    print('this is query params $queryParams');
    //final uri = Uri.parse(AppUrls.dashapi).replace(queryParameters: queryParams);
    //final uri = Uri.parse(AppUrls.testDashapi).replace(queryParameters: queryParams);
    final uri = Uri.parse(AppUrls.dashboardApi);
    print('this is my final url for dashboard data $uri');

    //final response = await _api.getApi(uri.toString());
    final response = await _api.postApi(uri.toString(),queryParams);
    print('this is response from dash $response');

    return DashModel.fromJson(response);
  } catch (e) {
    print('Error parsing DashModel: $e');
    rethrow;
  }
}

//To fetch lib activity log form
  Future<List<dynamic>?> fetchFormLogs(String adminId) async {
    try {

      final queryParams = <String, String>{'created_by': adminId};
      //final url = "${AppUrls.getFormApi}?created_by=$adminId";
      final url = AppUrls.getLibFormApi;
      // final response = await _api.getApi(url);
      final response = await _api.postApi(url,queryParams);

      print(response);

      // Assuming the API returns { "status": "success", "data": [...] }
      // or directly a list. Adjust based on your actual JSON structure.
      if (response != null && response['error'] == false) {
        return response['data'];
      }
      return [];
    } catch (e) {
      print('Error fetching form logs: $e');
      return null;
    }
  }

  // Future<DashModel> fetchDashDataOffline({String? from, String? to}) async {
  //
  //   final now = DateTime.now();
  //   final rangeStart = from != null ? DateTime.tryParse(from) ?? DateTime(now.year, 1, 1) : DateTime(now.year, 1, 1);
  //   final rangeEnd = to != null ? DateTime.tryParse(to) ?? now : now;
  //
  //   final students = await _db.select(_db.students).get();
  //   // final allIssues = await _db.select(_db.bookIssues).get();
  //   final allIssues = await (_db.select(_db.bookIssues)
  //     ..where((t) => t.createdAt.isBiggerOrEqualValue(rangeStart) & t.createdAt.isSmallerOrEqualValue(rangeEnd)))
  //       .get();
  //   final books = await _db.select(_db.books).get();
  //
  //   // Same uniqid-based "open loan" logic we fixed in book_issue_repository
  //   final returnedUniqids = allIssues
  //       .where((i) => i.status == 'Returned')
  //       .map((i) => i.uniqid)
  //       .toSet();
  //   final issuedRows = allIssues.where((i) => i.status == 'Issued').toList();
  //   final openLoans =
  //   issuedRows.where((i) => !returnedUniqids.contains(i.uniqid)).toList();
  //
  //   final levelByIsbn = {
  //     for (final b in books) b.isbn: (b.level ?? 'na').toLowerCase()
  //   };
  //
  //   final levelCounts = {'green': 0, 'orange': 0, 'white': 0, 'red': 0, 'na': 0};
  //   for (final loan in openLoans) {
  //     final level = levelByIsbn[loan.bookIsbn] ?? 'na';
  //     levelCounts[levelCounts.containsKey(level) ? level : 'na'] =
  //         levelCounts[levelCounts.containsKey(level) ? level : 'na']! + 1;
  //   }
  //
  //   return DashModel(
  //     error: false,
  //     message: 'Loaded from offline cache',
  //     students: students.length,
  //     bookIssued: issuedRows.length,
  //     pendingReturn: openLoans.length,
  //     green: levelCounts['green']!,
  //     orange: levelCounts['orange']!,
  //     white: levelCounts['white']!,
  //     red: levelCounts['red']!,
  //     na: levelCounts['na']!,
  //     bargraph: const [],       // charts need historical/date-grouped data —
  //     gradebargraph: const [],  // out of scope for now, shown empty offline
  //   );
  // }

  Future<DashModel> fetchDashDataOffline({String? from, String? to}) async {
    final now = DateTime.now();
    final rangeStart = from != null ? DateTime.tryParse(from) ?? DateTime(now.year, 1, 1) : DateTime(now.year, 1, 1);
    final rangeEnd = to != null ? DateTime.tryParse(to) ?? now : now;

    final students = await (_db.select(_db.students)..where((t) => t.status.equals('1'))).get();
    final books = await _db.select(_db.books).get();

    // NEW — split into two queries: date-scoped for bookIssued, unscoped for pendingReturn
    final allIssuesAllTime = await _db.select(_db.bookIssues).get();
    final issuedInRange = allIssuesAllTime.where((i) =>
    i.status == 'Issued' &&
        !i.createdAt.isBefore(rangeStart) &&
        !i.createdAt.isAfter(rangeEnd)).toList();

    // FIX — pending calculation now uses ALL-TIME data, no date filter
    final returnedUniqids = allIssuesAllTime.where((i) => i.status == 'Returned').map((i) => i.uniqid).toSet();
    final openLoans = allIssuesAllTime
        .where((i) => i.status == 'Issued' && !returnedUniqids.contains(i.uniqid))
        .toList();

    final levelByIsbn = {for (final b in books) b.isbn: (b.level ?? 'na').toLowerCase()};
    final levelCounts = {'green': 0, 'orange': 0, 'white': 0, 'red': 0, 'na': 0};
    for (final loan in openLoans) { // unfiltered by date, matches new pendingReturn semantics
      final level = levelByIsbn[loan.bookIsbn] ?? 'na';
      levelCounts[levelCounts.containsKey(level) ? level : 'na'] =
          levelCounts[levelCounts.containsKey(level) ? level : 'na']! + 1;
    }

    return DashModel(
      error: false,
      message: 'Loaded from offline cache',
      students: students.length,
      bookIssued: issuedInRange.length, // still date-scoped
      pendingReturn: openLoans.length,  // FIX — no longer date-scoped
      green: levelCounts['green']!,
      orange: levelCounts['orange']!,
      white: levelCounts['white']!,
      red: levelCounts['red']!,
      na: levelCounts['na']!,
      bargraph: const [],
      gradebargraph: const [],
    );
  }

  // NEW — offline activity log list
  Future<List<dynamic>> fetchFormLogsOffline(String adminId) async {
    final rows = await (_db.select(_db.activityLogs)
      ..where((t) => t.createdBy.equals(int.tryParse(adminId) ?? 0)))
        .get();

    return rows.map((r) => {
      'id': r.id ?? r.localId,
      'date': r.date.toIso8601String(),
      'activity_name': r.activityName,
      'activity_description': r.activityDescription,
      'book_details': r.bookDetails,
      'participants_grades': r.participantsGrades,
      'participants_number': r.participantsNumber,
      'conducted_by': r.conductedBy,
      'created_at': r.createdAt.toIso8601String(),
      'school': r.school,
      'created_by': r.createdBy,
    }).toList();
  }

}