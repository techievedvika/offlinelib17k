import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/custom_button.dart';
import '../../components/custom_labeltext.dart';
import '../../configs/color/color.dart';
import '../../models/book/book_model.dart';

class BookScannerSection extends StatelessWidget {
  final VoidCallback onScan;
  const BookScannerSection({required this.onScan});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(label: "Activity Scan Book"),
        const SizedBox(height: 10),
        CustomButton(
          title: 'Scan ISBN Barcode',
          onPressedButton: onScan,
          icon: Icons.document_scanner_outlined,
          width: 230,
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
        // return Card(
        //   margin: const EdgeInsets.symmetric(vertical: 4.0),
        //   child: ListTile(
        //     title: Text(book.title),
        //     subtitle: Text('Book Code: ${book.isbn} \nBook Title: ${book.title}\nGenre: ${book.genre}\nLanguage: ${book.language}'),
        //     trailing: IconButton(
        //       icon: const Icon(Icons.delete, color: Colors.red),
        //       onPressed: () => onBookRemoved(book),
        //     ),
        //   ),
        // );
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Book icon accent
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),

                // Book details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        book.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _buildTag(book.genre, const Color(0xFFEEF2FF), const Color(0xFF4F6EF7)),
                          const SizedBox(width: 6),
                          _buildTag(book.language, const Color(0xFFF0FDF4), const Color(0xFF16A34A)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'ISBN: ${book.isbn}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9CA3AF),
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),

                // Delete button
                GestureDetector(
                  onTap: () => onBookRemoved(book),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFEF4444),
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Widget _buildTag(String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
