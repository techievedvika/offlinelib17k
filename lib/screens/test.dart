import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html;
class ScannerFormScreen extends StatefulWidget {
  const ScannerFormScreen({super.key});

  @override
  State<ScannerFormScreen> createState() => _ScannerFormScreenState();
}

class _ScannerFormScreenState extends State<ScannerFormScreen> {
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController bookTitleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  bool isScanning = false;
  Future<void> scanISBN() async {
  try {
    setState(() => isScanning = true);
    String isbn = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    if (isbn != '-1') {
      final bookDetails = await fetchBookDetailsFromHtml(isbn);
      setState(() {
        isbnController.text = isbn;
        bookTitleController.text = bookDetails['title'] ?? 'No title available';
        authorController.text = bookDetails['author'] ?? 'No author available';
      });
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error fetching book details: $e")),
    );
  } finally {
    setState(() => isScanning = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan ISBN & Fill Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: isScanning ? null : scanISBN,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Scan ISBN'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: isbnController,
              decoration: const InputDecoration(
                labelText: 'ISBN',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: bookTitleController,
              decoration: const InputDecoration(
                labelText: 'Book Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: authorController,
              decoration: const InputDecoration(
                labelText: 'Author',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save logic goes here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Form Submitted!')),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}



Future<Map<String, String>> fetchBookDetailsFromHtml(String isbn) async {
  final url = Uri.parse('https://isbndb.com/book/$isbn');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final document = html.parse(response.body);
    
    // Extract book details from the HTML content
    final titleElement = document.querySelector('h1.title');
    final authorElement = document.querySelector('span.author');
    final coverImageElement = document.querySelector('img.cover');

    String title = titleElement?.text ?? 'No title available';
    String author = authorElement?.text ?? 'No author available';
    String coverImageUrl = coverImageElement?.attributes['src'] ?? '';

    // Return the extracted information as a JSON-like structure (Map)
    return {
      'title': title,
      'author': author,
      'cover_image': coverImageUrl,
    };
  } else {
    throw Exception('Failed to load book details');
  }
}
