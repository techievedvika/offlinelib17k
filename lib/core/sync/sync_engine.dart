import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:http/http.dart' as http;
import '../../configs/app_urls.dart';
import '../../data/network/network_api_services.dart';
import '../database/tables/database.dart';

class SyncEngine {
  final AppDatabase db;
  final String baseUrl;
  bool _isSyncing = false;
  final _api = NetworkServicesApi();

  SyncEngine(this.db, {required this.baseUrl});

  Future<void> runSync() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      await _push();
      await _pull();
      await _uploadPendingFiles();
    } finally {
      _isSyncing = false;
    }
  }

  // ---------------- PUSH ----------------

  Future<void> _push() async {
    // Strict dependency order: books -> students -> issues -> activity logs
    for (final type in ['book', 'student', 'issue', 'activity_log']) {
      final rows = await (db.select(db.syncOutbox)..where((t) => t.entityType.equals(type))).get();

      for (final row in rows) {
        try {
          final resp = await http.post(
            Uri.parse('$baseUrl/sync/push'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'entity_type': type,
              'operation': row.operation,
              'payload': jsonDecode(row.payloadJson),
            }),
          );
          final result = jsonDecode(resp.body);

          switch (result['status']) {
            case 'created':
            case 'updated':
            case 'already_exists':
              await (db.delete(db.syncOutbox)..where((t) => t.id.equals(row.id))).go();
              await _markSynced(type, row.entityKey);
              break;
            case 'ignored_stale':
              await (db.delete(db.syncOutbox)..where((t) => t.id.equals(row.id))).go();
              break; // corrected by pull step right after
            case 'merged':
              await _handleMerge(type, row.entityKey, result['server_key']?.toString());
              await (db.delete(db.syncOutbox)..where((t) => t.id.equals(row.id))).go();
              break;
            default:
              throw Exception(result['message'] ?? 'sync failed');
          }
        } catch (e) {
          await (db.update(db.syncOutbox)..where((t) => t.id.equals(row.id))).write(
            SyncOutboxCompanion(retryCount: Value(row.retryCount + 1), lastError: Value(e.toString())),
          );
          break; // stop this entity type's loop, retry next cycle
        }
      }
    }
  }

  Future<void> _markSynced(String type, String key) async {
    switch (type) {
      case 'student':
        await (db.update(db.students)..where((t) => t.rollno.equals(key)))
            .write(const StudentsCompanion(syncStatus: Value('synced')));
        break;
      case 'book':
        await (db.update(db.books)..where((t) => t.isbn.equals(key)))
            .write(const BooksCompanion(syncStatus: Value('synced')));
        break;
      case 'issue':
        final uniqid = key.split('-').first;
        await (db.update(db.bookIssues)..where((t) => t.uniqid.equals(uniqid)))
            .write(const BookIssuesCompanion(syncStatus: Value('synced')));
        break;
      case 'activity_log':
        await (db.update(db.activityLogs)..where((t) => t.localId.equals(key)))
            .write(const ActivityLogsCompanion(syncStatus: Value('synced')));
        break;
    }
  }

  Future<void> _handleMerge(String type, String localKey, String? serverKey) async {
    if (serverKey == null) return;
    // e.g. two devices created the same real student with different rollno inputs —
    // relink any pending issue rows referencing the old key, then drop the local duplicate.
    if (type == 'student' && localKey != serverKey) {
      await (db.update(db.bookIssues)..where((t) => t.studentRollno.equals(localKey)))
          .write(BookIssuesCompanion(studentRollno: Value(serverKey)));
      await (db.delete(db.students)..where((t) => t.rollno.equals(localKey))).go();
    }
    if (type == 'book' && localKey != serverKey) {
      await (db.update(db.bookIssues)..where((t) => t.bookIsbn.equals(localKey)))
          .write(BookIssuesCompanion(bookIsbn: Value(serverKey)));
      await (db.delete(db.books)..where((t) => t.isbn.equals(localKey))).go();
    }
  }

  // ---------------- PULL ----------------

  Future<void> _pull() async {
    for (final entity in ['book', 'student', 'issue', 'activity_log']) {
      final lastSynced = await _getLastSynced(entity);
      final resp = await http.get(Uri.parse('$baseUrl/sync/pull?entity=$entity&updated_since=$lastSynced'));
      final decoded = jsonDecode(resp.body);
      final data = (decoded['data'] as List?) ?? [];
      await _mergeIncoming(entity, data);
      await _setLastSynced(entity, DateTime.now());
    }
  }

  Future<String> _getLastSynced(String entity) async {
    final row = await (db.select(db.syncMeta)..where((t) => t.key.equals('last_synced_$entity'))).getSingleOrNull();
    return row?.value ?? DateTime(2000).toIso8601String();
  }

  Future<void> _setLastSynced(String entity, DateTime time) async {
    await db.into(db.syncMeta).insertOnConflictUpdate(
      SyncMetaCompanion.insert(key: 'last_synced_$entity', value: time.toIso8601String()),
    );
  }

  Future<void> _mergeIncoming(String entity, List data) async {
    for (final item in data) {
      switch (entity) {
        case 'student':
          await db.into(db.students).insertOnConflictUpdate(StudentsCompanion.insert(
            uuid: item['uuid'] ?? '',
            apaarId: Value(item['apaarId']),
            penId: Value(item['pen_id']),
            uniqueId: Value(item['unique_id']),
            school: item['school'] ?? '',
            name: item['name'] ?? '',
            studentClass: item['class'] ?? '',
            rollno: item['rollno'] ?? '',
            gender: item['gender'] ?? '',
            createdAt: DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now(),
            updatedAt: DateTime.tryParse(item['updated_at'] ?? '') ?? DateTime.now(),
            createdBy: item['created_by'] ?? 0,
            syncStatus: const Value('synced'),
          ));
          break;
        case 'book':
          await db.into(db.books).insertOnConflictUpdate(BooksCompanion.insert(
            isbn: item['isbn'] ?? '',
            title: item['title'] ?? '',
            publisher: Value(item['publisher']),
            author: Value(item['author']),
            language: Value(item['language']),
            gener: Value(item['gener']),
            level: Value(item['level']),
            coverPage: Value(item['cover_page']),
            code: Value(item['code']),
            updatedAt: DateTime.tryParse(item['updated_at'] ?? '') ?? DateTime.now(),
            syncStatus: const Value('synced'),
          ));
          break;
        case 'issue':
          await db.into(db.bookIssues).insertOnConflictUpdate(BookIssuesCompanion.insert(
            uniqid: item['uniqid'] ?? '',
            uuid: item['uuid'] ?? item['uniqid'] ?? '',
            bookIsbn: item['book_id'] ?? '',
            bookName: item['book_name'] ?? '',
            studentRollno: item['student_id'] ?? '',
            studentGrade: item['student_grade'] ?? '',
            status: item['status'] ?? 'Issued',
            createdAt: DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now(),
            updatedAt: DateTime.tryParse(item['updated_at'] ?? item['created_at'] ?? '') ?? DateTime.now(),
            submittedAt: Value(DateTime.tryParse(item['submitted_at'] ?? '')),
            createdBy: item['created_by'] ?? 0,
            syncStatus: const Value('synced'),
          ));
          break;
        case 'activity_log':
          await db.into(db.activityLogs).insertOnConflictUpdate(ActivityLogsCompanion.insert(
            localId: item['id']?.toString() ?? DateTime.now().microsecondsSinceEpoch.toString(),
            date: DateTime.tryParse(item['date'] ?? '') ?? DateTime.now(),
            activityName: item['activity_name'] ?? '',
            activityDescription: item['activity_description'] ?? '',
            photo: Value(item['photo']),
            bookDetails: item['book_details'] ?? '',
            participantsGrades: item['participants_grades'] ?? '',
            participantsNumber: item['participants_number'] ?? 0,
            conductedBy: item['conducted_by'] ?? '',
            school: item['school'] ?? '',
            createdBy: item['created_by'] ?? 0,
            createdAt: DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now(),
            syncStatus: const Value('synced'),
          ));
          break;
      }
    }
  }

  // ---------------- INITIAL SYNC (post-login bulk pull) ----------------

  Future<void> runInitialSync({required String createdBy, required String school, required String role}) async {

    final Map<String, dynamic> data = {
      "created_by": createdBy,
      "school": school,
      "role": role,
    };

    final resp = await _api.postApi(AppUrls.syncInitial, data);
    final Map<String, dynamic> decoded = jsonDecode(resp.body);

    await _mergeIncoming('student', decoded['students'] ?? []);
    await _mergeIncoming('book', decoded['books'] ?? []);
    await _mergeIncoming('issue', decoded['issues'] ?? []);
    await _mergeIncoming('activity_log', decoded['activity_logs'] ?? []);

    for (final g in (decoded['grades'] as List? ?? [])) {
      await db.into(db.grades).insertOnConflictUpdate(GradesCompanion.insert(grade: g.toString()));
    }

    final now = DateTime.now();
    for (final entity in ['student', 'book', 'issue', 'activity_log']) {
      await _setLastSynced(entity, now);
    }
  }

  // ---------------- FILE UPLOADS ----------------

  Future<void> _uploadPendingFiles() async {
    final pending = await (db.select(db.pendingUploads)..where((t) => t.uploaded.equals(false))).get();

    for (final file in pending) {
      try {
        final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload_file'));
        request.fields['entity_type'] = file.entityType;
        request.fields['entity_key'] = file.entityKey;
        request.fields['field_name'] = file.fieldName;
        request.files.add(await http.MultipartFile.fromPath('file', file.localFilePath));

        final streamed = await request.send();
        final resp = await http.Response.fromStream(streamed);
        final decoded = jsonDecode(resp.body);

        if (decoded['url'] != null) {
          await _patchParentField(file.entityType, file.entityKey, file.fieldName, decoded['url']);
          await (db.update(db.pendingUploads)..where((t) => t.id.equals(file.id)))
              .write(const PendingUploadsCompanion(uploaded: Value(true)));
        }
      } catch (_) {
        // leave in queue, retry next cycle
      }
    }
  }

  Future<void> _patchParentField(String entityType, String entityKey, String fieldName, String url) async {
    if (entityType == 'book' && fieldName == 'cover_page') {
      await (db.update(db.books)..where((t) => t.isbn.equals(entityKey)))
          .write(BooksCompanion(coverPage: Value(url)));
    }
    if (entityType == 'activity_log' && fieldName == 'photo') {
      await (db.update(db.activityLogs)..where((t) => t.localId.equals(entityKey)))
          .write(ActivityLogsCompanion(photo: Value(url)));
    }
  }
}