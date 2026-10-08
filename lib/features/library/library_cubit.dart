import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:preproject_books/core/models/book.dart';
import 'package:preproject_books/features/library/library_repository.dart';

enum LibraryTab { all, reading, finished }

class LibraryState {
  final List<Book> books;
  final Map<String, double> progress;
  final LibraryTab tab;
  final bool loading;

  const LibraryState({
    this.books = const [],
    this.progress = const {},
    this.tab = LibraryTab.all,
    this.loading = false,
  });

  LibraryState copyWith({
    List<Book>? books,
    Map<String, double>? progress,
    LibraryTab? tab,
    bool? loading,
  }) {
    return LibraryState(
      books: books ?? this.books,
      progress: progress ?? this.progress,
      tab: tab ?? this.tab,
      loading: loading ?? this.loading,
    );
  }
}

class LibraryCubit extends Cubit<LibraryState> {
  LibraryCubit(this.repository) : super(LibraryState());

  final LibraryRepository repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true));

    final books = await repository.loadBooks();
    final progress = await repository.loadProgress();

    emit(state.copyWith(books: books, progress: progress, loading: false));
  }

  void selectTab(LibraryTab tab) {
    emit(state.copyWith(tab: tab));
  }

  bool isReading(Book book) {
    return state.books.any((item) => item.key == book.key);
  }

  double getProgress(Book book) {
    return state.progress[book.key] ?? 0;
  }

  Future<void> startReading(Book book) async {
    if (isReading(book)) {
      return;
    }

    final books = [...state.books, book];

    final progress = {...state.progress, book.key: 0.0};

    emit(state.copyWith(books: books, progress: progress));

    await repository.saveBooks(books);
    await repository.saveProgress(progress);
  }

  Future<void> setProgress(Book book, double value) async {
    final progress = {...state.progress, book.key: value.clamp(0.0, 1.0)};

    emit(state.copyWith(progress: progress));

    await repository.saveProgress(progress);
  }

  Future<void> removeFromReading(Book book) async {
    final books = state.books.where((item) => item.key != book.key).toList();

    final progress = {...state.progress}..remove(book.key);

    emit(state.copyWith(books: books, progress: progress));

    await repository.saveBooks(books);
    await repository.saveProgress(progress);
  }

  List<Book> visibleBooks() {
    switch (state.tab) {
      case LibraryTab.reading:
        return state.books.where((book) => getProgress(book) < 1).toList();

      case LibraryTab.finished:
        return state.books.where((book) => getProgress(book) >= 1).toList();

      case LibraryTab.all:
        return state.books;
    }
  }
}
