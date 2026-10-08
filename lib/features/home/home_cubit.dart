import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:preproject_books/core/models/book.dart';
import 'package:preproject_books/core/repo/books_repo.dart';

class HomeState {
  final int currentIndex;
  final List<Book> featuredBooks;
  final bool loading;
  final bool hasError;

  const HomeState({
    this.currentIndex = 0,
    this.featuredBooks = const [],
    this.loading = false,
    this.hasError = false,
  });

  HomeState copyWith({
    int? currentIndex,
    List<Book>? featuredBooks,
    bool? loading,
    bool? hasError,
  }) {
    return HomeState(
      currentIndex: currentIndex ?? this.currentIndex,
      featuredBooks: featuredBooks ?? this.featuredBooks,
      loading: loading ?? this.loading,
      hasError: hasError ?? this.hasError,
    );
  }
}

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.booksRepository) : super(const HomeState()) {
    loadFeatured();
  }

  final BooksRepository booksRepository;

  void changeIndex(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  Future<void> loadFeatured() async {
    emit(state.copyWith(loading: true, hasError: false));

    try {
      final books = await booksRepository.getBooks('bestseller');

      emit(
        state.copyWith(featuredBooks: books, loading: false, hasError: false),
      );
    } catch (_) {
      emit(state.copyWith(loading: false, hasError: true));
    }
  }
}

class CategoryBooksState {
  const CategoryBooksState({
    this.books = const [],
    this.loading = false,
    this.hasError = false,
  });

  final List<Book> books;
  final bool loading;
  final bool hasError;
}

class CategoryBooksCubit extends Cubit<CategoryBooksState> {
  CategoryBooksCubit(this.booksRepository) : super(CategoryBooksState());

  final BooksRepository booksRepository;

  Future<void> load(String query) async {
    emit(CategoryBooksState(loading: true));
    try {
      final books = await booksRepository.getBooks(query);
      emit(CategoryBooksState(books: books));
    } catch (_) {
      emit(CategoryBooksState(hasError: true));
    }
  }
}
