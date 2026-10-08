import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:preproject_books/core/models/book.dart';

class FavoritesRepository {
  static const String _key = 'favorite_books';

  Future<List<Book>> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_key);

    if (data == null) {
      return [];
    }

    final list = jsonDecode(data) as List;

    return list.whereType<Map<String, dynamic>>().map(Book.fromJson).toList();
  }

  Future<void> saveFavorites(List<Book> books) async {
    final prefs = await SharedPreferences.getInstance();

    final data = books.map((book) => book.toJson()).toList();

    await prefs.setString(_key, jsonEncode(data));
  }
}
