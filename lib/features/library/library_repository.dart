import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:preproject_books/core/models/book.dart';

class LibraryRepository {
  static String _booksKey = 'reading_books';
  static String _progressKey = 'reading_progress';

  Future<List<Book>> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_booksKey);

    if (data == null) {
      return [];
    }

    final list = jsonDecode(data) as List;

    return list.whereType<Map<String, dynamic>>().map(Book.fromJson).toList();
  }

  Future<Map<String, double>> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_progressKey);

    if (data == null) {
      return {};
    }

    final map = jsonDecode(data) as Map<String, dynamic>;

    return map.map((key, value) {
      return MapEntry(key, (value as num).toDouble());
    });
  }

  Future<void> saveBooks(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();

    final data = books.map((book) => book.toJson()).toList();

    await prefs.setString(_booksKey, jsonEncode(data));
  }

  Future<void> saveProgress(Map<String, double> progress) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_progressKey, jsonEncode(progress));
  }
}
