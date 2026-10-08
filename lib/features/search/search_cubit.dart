import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:preproject_books/core/models/book.dart';
import 'package:preproject_books/core/repo/books_repo.dart';

enum SearchType { all, books, authors }

class SearchState {
  final List<Book> books;
  final bool loading;
  final SearchType type;
  final String query;
  final bool hasError;

  SearchState({
    this.books = const [],
    this.loading = false,
    this.type = SearchType.all,
    this.query = '',
    this.hasError = false,
  });

  SearchState copyWith({
    List<Book>? books,
    bool? loading,
    SearchType? type,
    String? query,
    bool? hasError,
  }) {
    return SearchState(
      books: books ?? this.books,
      loading: loading ?? this.loading,
      type: type ?? this.type,
      query: query ?? this.query,
      hasError: hasError ?? this.hasError,
    );
  }
}

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this.booksRepository) : super(SearchState());

  final BooksRepository booksRepository;
  int _requestNumber = 0;

  Future<void> search(String text) async {
    final requestNumber = ++_requestNumber;
    if (text.trim().isEmpty) {
      emit(
        state.copyWith(books: [], query: '', loading: false, hasError: false),
      );
      return;
    }

    emit(state.copyWith(loading: true, query: text, hasError: false));

    try {
      final books = await booksRepository.searchBooks(text, state.type.name);

      if (requestNumber != _requestNumber) return;

      emit(state.copyWith(books: books, loading: false, hasError: false));
    } catch (_) {
      if (requestNumber != _requestNumber) return;
      emit(state.copyWith(books: [], loading: false, hasError: true));
    }
  }

  void changeType(SearchType type) {
    emit(state.copyWith(type: type));

    if (state.query.isNotEmpty) {
      search(state.query);
    }
  }
}
