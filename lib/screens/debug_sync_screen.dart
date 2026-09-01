// lib/screens/debug_sync_screen.dart
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import '../core/database/tables/database.dart';
import '../core/di/service_locator.dart';


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
      appBar: AppBar(title: const Text('Debug: Local DB')),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _section('Students', () => db.select(db.students).get()),
          _section('Books', () => db.select(db.books).get()),
          _section('Book Issues', () => db.select(db.bookIssues).get()),
          _section('Sync Outbox (pending pushes)', () => db.select(db.syncOutbox).get()),
        ],
      ),
    );
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