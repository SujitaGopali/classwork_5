import 'package:classwork_5/models/author_model.dart';
import 'package:classwork_5/models/book_model.dart';
import 'package:flutter/material.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final List<Book> _books = [];

  final List<Author> _authors = [
    Author(authorName: 'J.K. Rowling'),
    Author(authorName: 'George R.R. Martin'),
    Author(authorName: 'J.R.R. Tolkien'),
    Author(authorName: 'Stephen King'),
    Author(authorName: 'Agatha Christie'),
    Author(authorName: 'Dan Brown'),
    Author(authorName: 'Paulo Coelho'),
    Author(authorName: 'Haruki Murakami'),
  ];

  void _showBookDialog({Book? existingBook}) {
    final formKey = GlobalKey<FormState>();
    final bookNameController =
        TextEditingController(text: existingBook?.bookName ?? '');
    final isbnController =
        TextEditingController(text: existingBook?.isbnNumber ?? '');
    final priceController = TextEditingController(
      text: existingBook != null ? existingBook.bookPrice.toString() : '',
    );
    Author? selectedAuthor = existingBook?.author;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFFF8F9FF),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  existingBook == null ? Icons.add_circle : Icons.edit,
                  color: const Color(0xFF5B6AF0),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                existingBook == null ? 'Add Book' : 'Edit Book',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3142),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 4),
                  _buildTextField(
                    controller: bookNameController,
                    label: 'Book Name',
                    icon: Icons.book_outlined,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter book name' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: isbnController,
                    label: 'ISBN Number',
                    icon: Icons.numbers_outlined,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Enter ISBN' : null,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: priceController,
                    label: 'Book Price (\$)',
                    icon: Icons.attach_money_outlined,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Enter price';
                      if (double.tryParse(v) == null) return 'Enter valid price';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Author>(
                    initialValue: selectedAuthor,
                    decoration: InputDecoration(
                      labelText: 'Author',
                      labelStyle: const TextStyle(color: Color(0xFF8E93B0)),
                      prefixIcon: const Icon(Icons.person_outlined,
                          color: Color(0xFF5B6AF0), size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFDDE1F5)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFDDE1F5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF5B6AF0), width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    hint: const Text('Select Author',
                        style: TextStyle(color: Color(0xFF8E93B0))),
                    items: _authors
                        .map((a) => DropdownMenuItem(
                              value: a,
                              child: Text(a.authorName,
                                  style: const TextStyle(
                                      color: Color(0xFF2D3142), fontSize: 14)),
                            ))
                        .toList(),
                    onChanged: (val) =>
                        setDialogState(() => selectedAuthor = val),
                    validator: (v) => v == null ? 'Select an author' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF8E93B0))),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newBook = Book(
                    bookId: existingBook?.bookId ?? DateTime.now().toString(),
                    bookName: bookNameController.text.trim(),
                    isbnNumber: isbnController.text.trim(),
                    bookPrice: double.parse(priceController.text.trim()),
                    author: selectedAuthor!,
                  );
                  setState(() {
                    if (existingBook == null) {
                      _books.add(newBook);
                    } else {
                      final idx = _books
                          .indexWhere((b) => b.bookId == existingBook.bookId);
                      if (idx != -1) _books[idx] = newBook;
                    }
                  });
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5B6AF0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              child: Text(existingBook == null ? 'Add Book' : 'Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Color(0xFF2D3142), fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF8E93B0), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF5B6AF0), size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE1F5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDDE1F5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide:
              const BorderSide(color: Color(0xFF5B6AF0), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF6B8A)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: validator,
    );
  }

  void _deleteBook(dynamic bookId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFF8F9FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Book',
            style: TextStyle(
                color: Color(0xFF2D3142), fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to delete this book?',
            style: TextStyle(color: Color(0xFF5C6080))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF8E93B0))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _books.removeWhere((b) => b.bookId == bookId));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF6B8A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EEFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.menu_book_rounded,
                  color: Color(0xFF5B6AF0), size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              'Book Library',
              style: TextStyle(
                color: Color(0xFF2D3142),
                fontWeight: FontWeight.w800,
                fontSize: 22,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8EEFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_books.length} ${_books.length == 1 ? 'book' : 'books'}',
              style: const TextStyle(
                color: Color(0xFF5B6AF0),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
      body: _books.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF5B6AF0).withAlpha(30),
                          blurRadius: 30,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.library_books_outlined,
                        size: 52, color: Color(0xFF5B6AF0)),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'No books yet',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the + button to add your first book',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8E93B0),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _books.length,
              itemBuilder: (ctx, i) {
                final book = _books[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B6AF0).withAlpha(18),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 50,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF7B88F5), Color(0xFF5B6AF0)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              book.bookName.isNotEmpty
                                  ? book.bookName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.bookName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2D3142),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.numbers,
                                      size: 13, color: Color(0xFF8E93B0)),
                                  const SizedBox(width: 4),
                                  Text(
                                    'ISBN: ${book.isbnNumber}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF8E93B0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.person_outline,
                                      size: 13, color: Color(0xFF8E93B0)),
                                  const SizedBox(width: 4),
                                  Text(
                                    book.author.authorName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF8E93B0),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE8EEFF),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '\$${book.bookPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF5B6AF0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_outlined,
                                  color: Color(0xFF5B6AF0), size: 20),
                              onPressed: () =>
                                  _showBookDialog(existingBook: book),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFE8EEFF),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                            const SizedBox(height: 8),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Color(0xFFFF6B8A), size: 20),
                              onPressed: () => _deleteBook(book.bookId),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFFFECF0),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBookDialog(),
        backgroundColor: const Color(0xFF5B6AF0),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add),
        label: const Text('Add Book',
            style: TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}