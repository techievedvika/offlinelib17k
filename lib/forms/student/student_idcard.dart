import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:lib17000ft/components/component.dart';
import 'package:lib17000ft/components/custom_appbar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class StudentIdCard extends StatefulWidget {
  final String studentData;
  const StudentIdCard({super.key, required this.studentData});

  @override
  State<StudentIdCard> createState() => _StudentIdCardState();
}

class _StudentIdCardState extends State<StudentIdCard> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _captureAndSave() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/student_id.png';
      File file = File(filePath);
      await file.writeAsBytes(pngBytes);

      await ImageGallerySaverPlus.saveFile(filePath);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID Card saved to gallery!'),
          backgroundColor: AppColors.primary,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save ID Card!'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> student = jsonDecode(widget.studentData);

    return WillPopScope(
      onWillPop: () async {
        return _showExitConfirmationDialog(context);
      },
      child: Scaffold(
        appBar: const CustomAppbar(
          title: 'Student ID Card',
          backbutton: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                RepaintBoundary(
                  key: _globalKey,
                  child: Center(
                    child: Column(
                      children: [
                        // GREY BACKGROUND + CARD
                        Container(
                          color: Colors.grey[300],
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            width: 300,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  child: Image.asset(
                                    'assets/logo.png',
                                    width: 240,
                                    height: 140,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.amber,
                                      width: 10.0,
                                    ),
                                  ),
                                  child: QrImageView(
                                    data: widget.studentData,
                                    version: QrVersions.auto,
                                    size: 150,
                                    gapless: false,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  student['name'] ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // const SizedBox(height: 8),
                                // Text(
                                //   'Student Code - ${student['rollno'] ?? ''}',
                                //
                                //   style: const TextStyle(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                                const SizedBox(height: 8),
                                Text(
                                  'School - ${student['school'] ?? ''}',

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Lib Code - lib/${student['id'] ?? ''}',

                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                // const SizedBox(height: 8),
                                // Text(
                                //   'APAAR ID - ${student['apaarId'] ?? 'XXXXX'}',
                                //   style: const TextStyle(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w500,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        // BOTTOM BAR
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       flex: 2,
                        //       child: Container(
                        //         height: 30,
                        //         color: Colors.orange,
                        //       ),
                        //     ),
                        //     Expanded(
                        //       flex: 1,
                        //       child: Container(
                        //         height: 30,
                        //         color: const Color.fromARGB(255, 247, 187, 97),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _captureAndSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        AppColors.primary, // Set your desired color here
                    foregroundColor:
                        Colors.white, // Optional: text & icon color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download_rounded),
                      SizedBox(width: 8),
                      Text("Download ID Card"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitConfirmationDialog(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing by tapping outside the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Do you want to Exit?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false if user cancels
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true if user confirms
              },
            ),
          ],
        );
      },
    ); // Ensure that the result is a boolean
    return result ??
        false; // Return false if result is null // Return false if dialog is dismissed
  }
}
