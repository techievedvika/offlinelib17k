// // lib/screens/debug_sync_screen.dart
// import 'package:flutter/material.dart';
// import 'package:drift/drift.dart' show Value;
// import '../core/database/tables/database.dart';
// import '../core/di/service_locator.dart';
//
//
// class DebugSyncScreen extends StatefulWidget {
//   const DebugSyncScreen({super.key});
//
//   @override
//   State<DebugSyncScreen> createState() => _DebugSyncScreenState();
// }
//
// class _DebugSyncScreenState extends State<DebugSyncScreen> {
//   final db = getIt<AppDatabase>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Debug: Local DB')),
//       body: ListView(
//         padding: const EdgeInsets.all(12),
//         children: [
//           _section('Students', () => db.select(db.students).get()),
//           _section('Books', () => db.select(db.books).get()),
//           _section('Book Issues', () => db.select(db.bookIssues).get()),
//           _section('Sync Outbox (pending pushes)', () => db.select(db.syncOutbox).get()),
//         ],
//       ),
//     );
//   }
//
//   Widget _section(String title, Future<List<dynamic>> Function() fetcher) {
//     return FutureBuilder<List<dynamic>>(
//       future: fetcher(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const SizedBox();
//         return ExpansionTile(
//           title: Text('$title (${snapshot.data!.length})'),
//           children: snapshot.data!
//               .map((row) => Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             child: Text(row.toString(), style: const TextStyle(fontSize: 11)),
//           ))
//               .toList(),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../core/di/service_locator.dart';
import '../core/database/tables/database.dart';

class DebugSyncScreen extends StatefulWidget {
  const DebugSyncScreen({super.key});

  @override
  State<DebugSyncScreen> createState() => _DebugSyncScreenState();
}

class _DebugSyncScreenState extends State<DebugSyncScreen> {
  final db = getIt<AppDatabase>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug: Local DB'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            tooltip: 'Delete all local data',
            onPressed: () => _confirmAndWipe(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _section('Students', () => db.select(db.students).get()),
          _section('Books', () => db.select(db.books).get()),
          _section('Book Issues', () => db.select(db.bookIssues).get()),
          _section('Activity Logs', () => db.select(db.activityLogs).get()),
          _section('Sync Outbox (pending pushes)', () => db.select(db.syncOutbox).get()),
          _section('Pending Uploads', () => db.select(db.pendingUploads).get()),
        ],
      ),
    );
  }

  Future<void> _confirmAndWipe(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete all local data?'),
        content: const Text(
          'This permanently deletes every locally cached student, book, issue record, '
              'activity log, AND any unsynced pending changes on this device.\n\n'
              'This cannot be undone. Are you sure?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete Everything', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await db.clearAllLocalData();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All local data deleted')),
        );
        setState(() {}); // refresh the FutureBuilders to show empty tables
      }
    }
  }

  Widget _section(String title, Future<List<dynamic>> Function() fetcher) {
    return FutureBuilder<List<dynamic>>(
      future: fetcher(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        return ExpansionTile(
          title: Text('$title (${snapshot.data!.length})'),
          children: snapshot.data!
              .map((row) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Text(row.toString(), style: const TextStyle(fontSize: 11)),
          ))
              .toList(),
        );
      },
    );
  }
}