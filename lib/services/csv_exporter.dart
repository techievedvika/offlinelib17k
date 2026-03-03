import 'dart:io';
import 'dart:typed_data'; // <-- ADD THIS for Uint8List

import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lib17000ft/models/student_registration/student_model.dart';
import 'package:permission_handler/permission_handler.dart';

class CsvExporter {
  /// Requests necessary storage permissions.
  /// Returns `true` if permission is granted, `false` otherwise.
  // static Future<bool> _requestStoragePermission() async {
  //   if (Platform.isAndroid) {
  //     // For Android 11 (API 30) and above
  //     if (await Permission.manageExternalStorage.isGranted) return true;
  //
  //     final status = await Permission.manageExternalStorage.request();
  //     if (status.isGranted) return true;
  //
  //     // Fallback for older Android versions (API < 30)
  //     final legacyStatus = await Permission.storage.request();
  //     if (legacyStatus.isGranted) return true;
  //
  //     // If permanently denied, open app settings
  //     if (status.isPermanentlyDenied || legacyStatus.isPermanentlyDenied) {
  //       await openAppSettings();
  //
  //     }
  //
  //     return false;
  //   } else if (Platform.isIOS) {
  //     // iOS doesn't require storage permission to write within app sandbox
  //     // Ensure you're saving file to app directory
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }
  /// Exports a list of students to a CSV file and saves it to the device's Downloads folder.
  static Future<void> exportStudentsToCSV(
      BuildContext context, List<StudentModel> students) async {
    if (students.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('There is no data to export.')),
      );
      return;
    }

    // 1. Request Permission
    // final bool hasPermission = await _requestStoragePermission();
    // if (!hasPermission) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //         content: Text(
    //             'Storage permission is required to save the file.')),
    //   );
    //   return;
    // }

    // 2. Prepare Data for CSV
    final List<List<String>> rows = [
      // CSV Headers
      [
        'Name',
        'Gender',
        'Student ID',
        'Class',
        'APAAR ID',
        'School'
      ],
      // Student Data
      ...students.map((student) => [
        student.name,
        student.gender,
        student.rollNo,
        student.classs,
        student.apaarId ?? 'N/A',
        student.school ?? 'N/A',
      ]),
    ];

    // 3. Convert to CSV String
    final String csvData = const ListToCsvConverter().convert(rows);

    // 4. Generate a unique file name with a timestamp
    final String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final String fileName = 'Student_List_$timestamp';

    try {
      // 5. Save the file using file_saver
      // This is the most reliable and modern way to handle saving.
      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: Uint8List.fromList(csvData.codeUnits),
        ext: 'csv',
        mimeType: MimeType.csv,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Student list exported successfully to Downloads!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error exporting file: $e')),
      );
    }
  }
}
