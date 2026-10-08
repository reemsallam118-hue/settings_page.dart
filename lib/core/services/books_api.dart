import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:preproject_books/core/models/book.dart';

class BooksApi {
  const BooksApi();

  Future<List<Book>> getBooks(String query) {
    return _fetch('q', query);
  }

  Future<List<Book>> searchBooks(String text, String type) {
    if (type == 'books') {
      return _fetch('title', text);
    }

    if (type == 'authors') {
      return _fetch('author', text);
    }

    return _fetch('q', text);
  }

  Future<List<Book>> _fetch(String parameter, String text) async {
    final uri = Uri.https('openlibrary.org', '/search.json', {
      parameter: text,
      'limit': '15',
    });

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load books');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    final docs = (data['docs'] as List?) ?? [];

    return docs.whereType<Map<String, dynamic>>().map(Book.fromJson).toList();
  }
}
