import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
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

  // Future<DashModel> fetchDashDataOffline({String? from, String? to}) async {
  //   final now = DateTime.now();
  //   final rangeStart = from != null ? DateTime.tryParse(from) ?? DateTime(now.year, 1, 1) : DateTime(now.year, 1, 1);
  //   final rangeEnd = to != null ? DateTime.tryParse(to) ?? now : now;
  //
  //   final students = await (_db.select(_db.students)..where((t) => t.status.equals('1'))).get();
  //   final books = await _db.select(_db.books).get();
  //
  //   // NEW — split into two queries: date-scoped for bookIssued, unscoped for pendingReturn
  //   final allIssuesAllTime = await _db.select(_db.bookIssues).get();
  //   final issuedInRange = allIssuesAllTime.where((i) =>
  //   i.status == 'Issued' &&
  //       !i.createdAt.isBefore(rangeStart) &&
  //       !i.createdAt.isAfter(rangeEnd)).toList();
  //
  //   // FIX — pending calculation now uses ALL-TIME data, no date filter
  //   final returnedUniqids = allIssuesAllTime.where((i) => i.status == 'Returned').map((i) => i.uniqid).toSet();
  //   final openLoans = allIssuesAllTime
  //       .where((i) => i.status == 'Issued' && !returnedUniqids.contains(i.uniqid))
  //       .toList();
  //
  //   final levelByIsbn = {for (final b in books) b.isbn: (b.level ?? 'na').toLowerCase()};
  //   final levelCounts = {'green': 0, 'orange': 0, 'white': 0, 'red': 0, 'na': 0};
  //   for (final loan in openLoans) { // unfiltered by date, matches new pendingReturn semantics
  //     final level = levelByIsbn[loan.bookIsbn] ?? 'na';
  //     levelCounts[levelCounts.containsKey(level) ? level : 'na'] =
  //         levelCounts[levelCounts.containsKey(level) ? level : 'na']! + 1;
  //   }
  //
  //   return DashModel(
  //     error: false,
  //     message: 'Loaded from offline cache',
  //     students: students.length,
  //     bookIssued: issuedInRange.length, // still date-scoped
  //     pendingReturn: openLoans.length,  // FIX — no longer date-scoped
  //     green: levelCounts['green']!,
  //     orange: levelCounts['orange']!,
  //     white: levelCounts['white']!,
  //     red: levelCounts['red']!,
  //     na: levelCounts['na']!,
  //     bargraph: const [],
  //     gradebargraph: const [],
  //   );
  // }

  Future<DashModel> fetchDashDataOffline({String? from, String? to}) async {
    final now = DateTime.now();
    final rangeStart = from != null ? DateTime.tryParse(from) ?? DateTime(now.year, 1, 1) : DateTime(now.year, 1, 1);
    final rangeEnd = to != null ? DateTime.tryParse(to) ?? now : now;

    final students = await (_db.select(_db.students)..where((t) => t.status.equals('1'))).get();
    final books = await _db.select(_db.books).get();
    final allIssuesAllTime = await _db.select(_db.bookIssues).get();

    final issuedInRange = allIssuesAllTime.where((i) =>
    i.status == 'Issued' &&
        !i.createdAt.isBefore(rangeStart) &&
        !i.createdAt.isAfter(rangeEnd)).toList();

    final returnedUniqids = allIssuesAllTime.where((i) => i.status == 'Returned').map((i) => i.uniqid).toSet();
    final openLoans = allIssuesAllTime
        .where((i) => i.status == 'Issued' && !returnedUniqids.contains(i.uniqid))
        .toList();

    final levelByIsbn = {for (final b in books) b.isbn: (b.level ?? 'na').toLowerCase()};

    String normalizedLevel(String isbn) {
      final level = levelByIsbn[isbn] ?? 'na';
      return ['green', 'orange', 'white', 'red'].contains(level) ? level : 'na';
    }

    // Pending-return level breakdown (unfiltered by date, per the earlier fix)
    final levelCounts = {'green': 0, 'orange': 0, 'white': 0, 'red': 0, 'na': 0};
    for (final loan in openLoans) {
      final level = normalizedLevel(loan.bookIsbn);
      levelCounts[level] = levelCounts[level]! + 1;
    }

    // NEW — month-wise bar graph, matches barGraphQuery's groupBy('issue_month') orderByRaw(MIN(created_at) ASC)
    final monthGroups = <String, Map<String, int>>{};
    final minDateByMonth = <String, DateTime>{};

    for (final issue in issuedInRange) {
      final monthKey = DateFormat('MMMM yyyy').format(issue.createdAt);
      monthGroups.putIfAbsent(monthKey, () => {'green': 0, 'orange': 0, 'white': 0, 'red': 0, 'na': 0, 'total_issues': 0});
      final level = normalizedLevel(issue.bookIsbn);
      monthGroups[monthKey]![level] = monthGroups[monthKey]![level]! + 1;
      monthGroups[monthKey]!['total_issues'] = monthGroups[monthKey]!['total_issues']! + 1;

      if (!minDateByMonth.containsKey(monthKey) || issue.createdAt.isBefore(minDateByMonth[monthKey]!)) {
        minDateByMonth[monthKey] = issue.createdAt;
      }
    }

    final sortedMonths = monthGroups.keys.toList()
      ..sort((a, b) => minDateByMonth[a]!.compareTo(minDateByMonth[b]!));

    final barGraph = sortedMonths.map((month) => {
      'issue_month': month,
      'green': monthGroups[month]!['green'],
      'orange': monthGroups[month]!['orange'],
      'white': monthGroups[month]!['white'],
      'red': monthGroups[month]!['red'],
      'na': monthGroups[month]!['na'],
      'total_issues': monthGroups[month]!['total_issues'],
    }).toList();

    // NEW — grade-wise bar graph, matches gradeBarGraphQuery's custom CASE-based ordering
    int gradeSortKey(String grade) {
      final g = grade.trim().toLowerCase();
      if (g == 'nursery') return 1;
      if (g == 'lkg') return 2;
      if (g == 'ukg') return 3;
      final match = RegExp(r'(\d+)').firstMatch(g);
      if (match != null) {
        final num = int.tryParse(match.group(1)!) ?? 999;
        return 3 + num; // Grade 1 -> 4 ... Grade 12 -> 15, matches the Laravel CASE mapping exactly
      }
      return 999;
    }

    final gradeGroups = <String, Map<String, int>>{};
    for (final issue in issuedInRange) {
      final grade = issue.studentGrade; // already stored directly on the issue row, no join needed
      gradeGroups.putIfAbsent(grade, () => {'green': 0, 'orange': 0, 'white': 0, 'red': 0, 'na': 0, 'total_books': 0});
      final level = normalizedLevel(issue.bookIsbn);
      gradeGroups[grade]![level] = gradeGroups[grade]![level]! + 1;
      gradeGroups[grade]!['total_books'] = gradeGroups[grade]!['total_books']! + 1;
    }

    final sortedGrades = gradeGroups.keys.toList()
      ..sort((a, b) => gradeSortKey(a).compareTo(gradeSortKey(b)));

    final gradeBarGraph = sortedGrades.map((grade) => {
      'grade': grade,
      'green': gradeGroups[grade]!['green'],
      'orange': gradeGroups[grade]!['orange'],
      'white': gradeGroups[grade]!['white'],
      'red': gradeGroups[grade]!['red'],
      'na': gradeGroups[grade]!['na'],
      'total_books': gradeGroups[grade]!['total_books'],
    }).toList();

    return DashModel(
      error: false,
      message: 'Loaded from offline cache',
      students: students.length,
      bookIssued: issuedInRange.length,
      pendingReturn: openLoans.length,
      green: levelCounts['green']!,
      orange: levelCounts['orange']!,
      white: levelCounts['white']!,
      red: levelCounts['red']!,
      na: levelCounts['na']!,
      bargraph: barGraph,       // FIX — was const [], now real data
      gradebargraph: gradeBarGraph, // FIX — was const [], now real data
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