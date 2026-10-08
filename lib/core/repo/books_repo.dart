import 'package:preproject_books/core/models/book.dart';
import 'package:preproject_books/core/services/books_api.dart';

class BooksRepository {
  const BooksRepository(this._api);

  final BooksApi _api;

  Future<List<Book>> getBooks(String query) => _api.getBooks(query);

  Future<List<Book>> searchBooks(String query, String type) =>
      _api.searchBooks(query, type);
}
