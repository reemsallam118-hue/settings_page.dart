import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:preproject_books/core/models/book.dart';
import 'package:preproject_books/features/favorites/favorites_repository.dart';

class FavoritesState {
  final List<Book> books;
  final bool loading;

  const FavoritesState({this.books = const [], this.loading = false});

  FavoritesState copyWith({List<Book>? books, bool? loading}) {
    return FavoritesState(
      books: books ?? this.books,
      loading: loading ?? this.loading,
    );
  }
}

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this.repository) : super(const FavoritesState());

  final FavoritesRepository repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    final books = await repository.loadFavorites();

    emit(state.copyWith(books: books, loading: false));
  }

  bool isFavorite(Book book) {
    return state.books.any((item) => item.key == book.key);
  }

  Future<void> add(Book book) async {
    if (isFavorite(book)) {
      return;
    }

    final books = [...state.books, book];

    emit(state.copyWith(books: books));

    await repository.saveFavorites(books);
  }

  Future<void> remove(Book book) async {
    final books = state.books.where((item) => item.key != book.key).toList();

    emit(state.copyWith(books: books));

    await repository.saveFavorites(books);
  }

  Future<void> toggle(Book book) async {
    if (isFavorite(book)) {
      await remove(book);
    } else {
      await add(book);
    }
  }
}
