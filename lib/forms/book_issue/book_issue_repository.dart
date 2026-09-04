import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import 'package:lib17000ft/configs/app_urls.dart';
import 'package:uuid/uuid.dart';

import '../../core/database/tables/database.dart';
import '../../core/di/service_locator.dart';
import '../../data/network/network_api_services.dart';

class BookIssueRepository {
  final _api = NetworkServicesApi();
  final AppDatabase _db = getIt<AppDatabase>();

  //login method
  // Future<dynamic> bookIssueReturn(dynamic data) async {
  //   //final response = await _api.postApi(AppUrls.bookIssueapi, data);
  //
  //   // Testing purpose only
  //   //final response = await _api.postApi(AppUrls.testBookIssueapi, data);
  //
  //   final response = await _api.postMultipartApi(AppUrls.bookIssueReturnApi, data);
  //
  //
  //   try {
  //     if (!response['error']) {
  //       // Handle the case where credentials are invalid or user is not found
  //       return {
  //         "error": 0,
  //         "message": response['message'],
  //       };
  //     } else {
  //       return {
  //         "error": 1,
  //         "message": response['message'],
  //
  //       };
  //     }
  //   } catch (e) {
  //     print('Error parsing Book Issue model: $e');
  //     rethrow; // rethrow the error after logging it
  //   }
  // }
  Future<dynamic> bookIssueReturn(dynamic data) async {
    try {
      final response = await _api.postMultipartApi(AppUrls.bookIssueReturnApi, data);

      if (response == null) {
        return {"error": true, "message": "No response from server"};
      }

      // Convert "error" field to boolean safely
      bool isError = response['error'] == true ||
          response['error'].toString().toLowerCase() == 'true' ||
          response['error'] == 1;

      return {
        "error": isError,
        "message": response['message']?.toString() ?? (isError ? "Operation failed" : "Success"),
      };
    } catch (e) {
      print('Repository Error: $e');
      // If the network service throws a CustomException, extract the message
      return {
        "error": true,
        "message": e.toString().replaceAll("Custom Error:", "").trim(),
      };
    }
  }

//Get book Return Report 
  Future<dynamic> getBookReturn(
      dynamic id,
      String? stateName,
      String? district,
      String? block,
      String? school,
      String? from,
      String? to,
      String? level,
      String? language,
      {required int page}
      ) async {
      final Map<String, dynamic> data = {
        "id": id,
        "state": stateName ?? '',
        "district": district ?? '',
        "block": block ?? '',
        "school": school ?? '',
        "from": from ?? '',
        "to": to ?? '',
        "level": level ?? '',
        "language": language ?? '',
      };

    // String url = "${AppUrls.getReturnedBookapi}?id=$id&state=$stateName&district=$district&block=$block&school=$school&from=$from&to=$to&level=$level&language=$language";
    //
    // final response = await _api.getApi(url);


      try {
        final response = await _api.postApi(AppUrls.getReturnedBookApi, data);
        print("this is the response $response");
        //final response = await _api.getApi(url);
        // The API returns "error": false for success
        if (response['error'] == false) {
          print(response);
          return {
            "error": 0, // Success code for Cubit logic
            "data": response['data'] ?? [],
            "message": response['message']?.toString() ?? "Success",
          };
        } else {
          return {
            "error": 1, // Failure code for Cubit logic
            "message": response['message']?.toString() ?? "No Record Found",
          };
        }
      } catch (e) {
        print('Error parsing getIssuedBook: $e');
        rethrow;
      }
    // try {
    //   if (!response['error']) {
    //     // Handle the case where credentials are invalid or user is not found
    //     return {
    //       "error": 0,
    //       "data":response['data'],
    //     };
    //   }else{
    //     print(response['error']);
    //   }
    //
    //   return jsonDecode(response);
    // } catch (e) {
    //   print('Error parsing UserModel: $e');
    //   rethrow; // rethrow the error after logging it
    // }
   
  }

  //Get Issue Book Report
 
  Future<dynamic> getIssuedBook(
      dynamic id,
      String? stateName,
      String? district,
      String? block,
      String? school,
      String? from,
      String? to,
      String? level,
      String? language
      ,{required int page}) async {
    final Map<String, dynamic> data = {
      "id": id,
      "state": stateName ?? '',
      "district": district ?? '',
      "block": block ?? '',
      "school": school ?? '',
      "from": from ?? '',
      "to": to ?? '',
      "level": level ?? '',
      "language": language ?? '',
    };

    //String url = "${AppUrls.getIssuedBookapi}?id=$id&state=$stateName&district=$district&block=$block&school=$school&from=$from&to=$to&level=$level&language=$language";

    //final response = await _api.postApi(AppUrls.getIssuedBookApi, data);
    //print("this is the response $response");
    try {
      final response = await _api.postApi(AppUrls.getIssuedBookApi, data);
      print("this is the response $response");
      //final response = await _api.getApi(url);
      // The API returns "error": false for success
      if (response['error'] == false) {
        print(response);
        return {
          "error": 0, // Success code for Cubit logic
          "data": response['data'] ?? [],
          "message": response['message']?.toString() ?? "Success",
        };
      } else {
        return {
          "error": 1, // Failure code for Cubit logic
          "message": response['message']?.toString() ?? "No Record Found",
        };
      }
    } catch (e) {
      print('Error parsing getIssuedBook: $e');
      rethrow;
    }
   
  }

  // NEW — "All Issued Books": every issue event ever (open or already returned)
  Future<List<Map<String, dynamic>>> getIssuedBookOffline({String? from, String? to}) async {

    final now = DateTime.now();
    final rangeStart = DateTime.tryParse(from ?? '') ?? DateTime(now.year, 1, 1);
    final rangeEnd = DateTime.tryParse(to ?? '') ?? now;

    // final allIssues = await _db.select(_db.bookIssues).get();
    final allIssues = await (_db.select(_db.bookIssues)
      ..where((t) => t.createdAt.isBiggerOrEqualValue(rangeStart) & t.createdAt.isSmallerOrEqualValue(rangeEnd)))
        .get();
    final students = await _db.select(_db.students).get();
    final books = await _db.select(_db.books).get();

    final studentByRollno = {for (final s in students) s.rollno: s};
    final bookByIsbn = {for (final b in books) b.isbn: b};
    final returnedByUniqid = {
      for (final r in allIssues.where((i) => i.status == 'Returned')) r.uniqid: r
    };

    final issuedRows = allIssues.where((i) => i.status == 'Issued');

    return issuedRows.map((issue) {
      final student = studentByRollno[issue.studentRollno];
      final book = bookByIsbn[issue.bookIsbn];
      final returnRow = returnedByUniqid[issue.uniqid]; // null if still open

      return {
        'name': student?.name ?? 'Unknown',
        'apaarId': student?.apaarId ?? 'XXXXXXXXXX',
        'class': student?.studentClass ?? issue.studentGrade,
        'gender': student?.gender ?? '',
        'unique_id': student?.uniqueId ?? '',
        'school': student?.school ?? '',
        'student_created_at': student?.createdAt.toIso8601String() ?? '',
        'isbn': issue.bookIsbn,
        'title': book?.title ?? issue.bookName,
        'publisher': book?.publisher ?? 'Unknown',
        'author': book?.author ?? 'Unknown',
        'language': book?.language ?? 'Unknown',
        'gener': book?.gener ?? 'Unknown',
        'level': book?.level ?? 'Unknown',
        'code': book?.code ?? 'Unknown',
        'created_by': issue.createdBy.toString(), // see note below
        'issued_date': issue.createdAt.toIso8601String(),
        'returned_date': returnRow?.createdAt.toIso8601String(),
      };
    }).toList();
  }

// NEW — "All Pending Returns": only currently OPEN loans (uniqid-aware, matches the fix from before)
  Future<List<Map<String, dynamic>>> getBookReturnOffline({String? from, String? to}) async {

    // final now = DateTime.now();
    // final rangeStart = DateTime.tryParse(from ?? '') ?? DateTime(now.year, 1, 1);
    // final rangeEnd = DateTime.tryParse(to ?? '') ?? now;

    final allIssues = await _db.select(_db.bookIssues).get();
    // final allIssues = await (_db.select(_db.bookIssues)
    //   ..where((t) => t.createdAt.isBiggerOrEqualValue(rangeStart) & t.createdAt.isSmallerOrEqualValue(rangeEnd)))
    //     .get();
    final students = await _db.select(_db.students).get();
    final books = await _db.select(_db.books).get();

    final studentByRollno = {for (final s in students) s.rollno: s};
    final bookByIsbn = {for (final b in books) b.isbn: b};
    final returnedUniqids =
    allIssues.where((i) => i.status == 'Returned').map((i) => i.uniqid).toSet();

    final openLoans =
    allIssues.where((i) => i.status == 'Issued' && !returnedUniqids.contains(i.uniqid));

    return openLoans.map((issue) {
      final student = studentByRollno[issue.studentRollno];
      final book = bookByIsbn[issue.bookIsbn];

      return {
        'name': student?.name ?? '',
        'class': student?.studentClass ?? issue.studentGrade,
        'apaarId': student?.apaarId ?? 'XXXXXXXXXX',
        'gender': student?.gender ?? '',
        'unique_id': student?.uniqueId ?? '',
        'school': student?.school ?? '',
        'rollno': issue.studentRollno,
        'pen_id': student?.penId ?? '',
        'created_at': issue.createdAt.toIso8601String(), // issue date — this list is only open loans
        'isbn': issue.bookIsbn,
        'title': book?.title ?? issue.bookName,
        'publisher': book?.publisher ?? 'unknown',
        'author': book?.author ?? 'Unknown',
        'language': book?.language ?? 'Unknown',
        'gener': book?.gener ?? 'Unknown',
        'level': book?.level ?? 'Unknown',
        'code': book?.code ?? 'Unknown',
        'created_by': issue.createdBy.toString(),
      };
    }).toList();
  }


  Future<Map<String, dynamic>> insertBookOnline(Map<String, dynamic> bookData) async {
    final response = await _api.postApi(AppUrls.bookAdd, bookData);
    if (response['error'] == false || response['error'] == 0) {
      return {"error": 0, "message": response['message'] ?? "Book inserted successfully"};
    }
    return {"error": 1, "message": response['message'] ?? "Failed to insert book"};
  }

  Future<Map<String, dynamic>> insertBookOffline(Map<String, dynamic> bookData) async {
    final isbn = bookData['isbn'].toString();
    final existing = await (_db.select(_db.books)..where((t) => t.isbn.equals(isbn))).getSingleOrNull();
    if (existing != null) {
      return {"error": 1, "message": "Book with this ISBN already exists"};
    }

    final now = DateTime.now();
    await _db.into(_db.books).insert(BooksCompanion.insert(
      isbn: isbn,
      title: bookData['title'].toString(),
      publisher: Value(bookData['publisher']?.toString()),
      author: Value(bookData['author']?.toString()),
      language: Value(bookData['language']?.toString()),
      gener: Value(bookData['gener']?.toString()),
      level: Value(bookData['level']?.toString()),
      coverPage: Value(bookData['cover_page']?.toString()),
      code: Value(bookData['code']?.toString() ?? 'NA'),
      updatedAt: now,
      syncStatus: const Value('pending'),
    ));

    await _db.into(_db.syncOutbox).insert(SyncOutboxCompanion.insert(
      entityType: 'book',
      entityKey: isbn,
      operation: 'create',
      payloadJson: jsonEncode(bookData),
      createdAt: now,
    ));

    if (bookData['cover_page']?.toString().isNotEmpty ?? false) {
      await _db.into(_db.pendingUploads).insert(PendingUploadsCompanion.insert(
        entityType: 'book', entityKey: isbn, fieldName: 'cover_page',
        localFilePath: bookData['cover_page'].toString(),
      ));
    }

    return {"error": 0, "message": "Book saved offline, will sync when online"};
  }

  Future<Map<String, dynamic>> bookIssueReturnOffline({
    required String isbn,
    required String title,
    required String rollno,
    required String status,
    required int createdBy,
    String? level,
    String? language,
    String? localCoverPagePath,
  }) async {
    final now = DateTime.now();

    final existingBook = await (_db.select(_db.books)..where((t) => t.isbn.equals(isbn))).getSingleOrNull();
    if (existingBook == null) {
      await _db.into(_db.books).insertOnConflictUpdate(BooksCompanion.insert(
        isbn: isbn,
        title: title,
        publisher: const Value('Unknown'),
        author: const Value('Unknown'),
        language: Value(language?.isNotEmpty == true ? language : 'Unknown'),
        gener: const Value('Unknown'),
        level: Value(level?.isNotEmpty == true ? level : 'Unknown'),
        coverPage: Value(localCoverPagePath),
        code: const Value('NA'),
        updatedAt: now,
        syncStatus: const Value('pending'),
      ));
      await _db.into(_db.syncOutbox).insert(SyncOutboxCompanion.insert(
        entityType: 'book',
        entityKey: isbn,
        operation: 'create',
        payloadJson: jsonEncode({
          'isbn': isbn, 'title': title, 'level': level, 'language': language,
          'updated_at': now.toIso8601String(),
        }),
        createdAt: now,
      ));
      if (localCoverPagePath != null) {
        await _db.into(_db.pendingUploads).insert(PendingUploadsCompanion.insert(
          entityType: 'book',
          entityKey: isbn,
          fieldName: 'cover_page',
          localFilePath: localCoverPagePath,
        ));
      }
    }

    final openLoan = await _findOpenLoan(isbn, rollno);

    if (status == 'Returned') {
      if (openLoan == null) {
        return {"error": 1, "message": "No Issued Book Found"};
      }
      await _insertIssueRow(
        uniqid: openLoan.uniqid,
        isbn: isbn,
        title: title,
        rollno: rollno,
        grade: openLoan.studentGrade,
        status: 'Returned',
        createdBy: createdBy,
        now: now,
      );
      return {"error": 0, "message": "Success"};
    } else {
      if (openLoan != null) {
        return {"error": 1, "message": "Book Already Issued"};
      }
      final student = await (_db.select(_db.students)..where((t) => t.rollno.equals(rollno))).getSingleOrNull();
      if (student == null) {
        return {"error": 1, "message": "Student not found"};
      }
      final uniqid = const Uuid().v4();
      await _insertIssueRow(
        uniqid: uniqid,
        isbn: isbn,
        title: title,
        rollno: rollno,
        grade: student.studentClass,
        status: 'Issued',
        createdBy: createdBy,
        now: now,
      );
      return {"error": 0, "message": "Success"};
    }
  }

  Future<BookIssue?> _findOpenLoan(String isbn, String rollno) async {
    final returnedUniqids = await (_db.selectOnly(_db.bookIssues)
      ..addColumns([_db.bookIssues.uniqid])
      ..where(_db.bookIssues.status.equals('Returned')))
        .map((row) => row.read(_db.bookIssues.uniqid)!)
        .get();

    final query = _db.select(_db.bookIssues)
      ..where((t) =>
      t.bookIsbn.equals(isbn) &
      t.studentRollno.equals(rollno) &
      t.status.equals('Issued') &
      t.uniqid.isNotIn(returnedUniqids))
      ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);

    return query.getSingleOrNull();
  }

  Future<void> _insertIssueRow({
    required String uniqid,
    required String isbn,
    required String title,
    required String rollno,
    required String grade,
    required String status,
    required int createdBy,
    required DateTime now,
  }) async {
    await _db.into(_db.bookIssues).insert(BookIssuesCompanion.insert(
      uniqid: uniqid,
      uuid: uniqid,
      bookIsbn: isbn,
      bookName: title,
      studentRollno: rollno,
      studentGrade: grade,
      status: status,
      createdAt: now,
      updatedAt: now,
      submittedAt: status == 'Returned' ? Value(now) : const Value(null),
      createdBy: createdBy,
      syncStatus: const Value('pending'),
    ));

    await _db.into(_db.syncOutbox).insert(SyncOutboxCompanion.insert(
      entityType: 'issue',
      entityKey: '$uniqid-$status',
      operation: 'create',
      payloadJson: jsonEncode({
        'uniqid': uniqid, 'isbn': isbn, 'title': title, 'student_id': rollno,
        'student_grade': grade, 'status': status, 'created_by': createdBy,
        'created_at': now.toIso8601String(), 'updated_at': now.toIso8601String(),
      }),
      createdAt: now,
    ));
  }
}
