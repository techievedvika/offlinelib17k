// /lib/models/book_model.dart

import 'package:equatable/equatable.dart';

class Book extends Equatable {
  final String isbn;
  final String title;
  final String genre;
  final String language;

  const Book({
    required this.isbn,
    required this.title,
    this.genre = 'N/A', // Default value if not provided
    this.language = 'N/A', // Default value
  });

  // Factory constructor to create a Book from JSON
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      isbn: json['isbn']?.toString() ?? '',
      title: json['title'] ?? 'No Title',
      genre: json['genre'] ?? 'N/A', // Adjust key if different in your API
      language: json['language'] ?? 'N/A', // Adjust key if different
    );
  }

  @override
  List<Object?> get props => [isbn, title, genre, language];
}