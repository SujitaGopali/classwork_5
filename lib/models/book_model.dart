import 'package:classwork_5/models/author_model.dart';
import 'package:uuid/uuid.dart';


const _uuid = Uuid();

class Book {
  final String bookId;
  final String bookName;
  final String isbnNumber;
  final double bookPrice;
  final Author author;

  Book({
    String? bookId,
    required this.bookName,
    required this.isbnNumber,
    required this.bookPrice,
    required this.author,
  }) : bookId = bookId ?? _uuid.v4();

  Book copyWith({
    String? bookName,
    String? isbnNumber,
    double? bookPrice,
    Author? author,
  }) {
    return Book(
      bookId: bookId,
      bookName: bookName ?? this.bookName,
      isbnNumber: isbnNumber ?? this.isbnNumber,
      bookPrice: bookPrice ?? this.bookPrice,
      author: author ?? this.author,
    );
  }
}