import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/custom_button.dart';
import '../../models/book/book_model.dart';

class BookScannerSection extends StatelessWidget {
  final VoidCallback onScan;
  const BookScannerSection({required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Corrected to use CustomLabelText with 'label' parameter
        //LabelText(label: 'Library Books Used'),
        // Corrected to use CustomButton with 'title' and 'onPressedButton' parameters
        CustomButton(
          title: 'Scan Book',
          onPressedButton: onScan,
          icon: Icons.qr_code_scanner,
        ),
      ],
    );
  }
}

class BookList extends StatelessWidget {
  final List<Book> books;
  final ValueChanged<Book> onBookRemoved;
  const BookList({required this.books, required this.onBookRemoved});

  @override
  Widget build(BuildContext context) {
    if (books.isEmpty) return const SizedBox.shrink();
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(book.title),
            subtitle: Text('Book Code: ${book.isbn} \nBook Title: ${book.title}\nGenre: ${book.genre}\nLanguage: ${book.language}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => onBookRemoved(book),
            ),
          ),
        );
      },
    );
  }
}
