import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:preproject_books/features/favorites/favorites_cubit.dart';
import 'package:preproject_books/core/models/book.dart';
import 'package:preproject_books/features/library/library_cubit.dart';

class BookDetailsState {
  final bool isFavorite;
  final bool isReading;

  const BookDetailsState({this.isFavorite = false, this.isReading = false});

  BookDetailsState copyWith({bool? isFavorite, bool? isReading}) {
    return BookDetailsState(
      isFavorite: isFavorite ?? this.isFavorite,
      isReading: isReading ?? this.isReading,
    );
  }
}

class BookDetailsCubit extends Cubit<BookDetailsState> {
  BookDetailsCubit({
    required this.book,
    required this.favoritesCubit,
    required this.libraryCubit,
  }) : super(
         BookDetailsState(
           isFavorite: favoritesCubit.isFavorite(book),
           isReading: libraryCubit.isReading(book),
         ),
       );

  final Book book;
  final FavoritesCubit favoritesCubit;
  final LibraryCubit libraryCubit;

  Future<void> toggleFavorite() async {
    await favoritesCubit.toggle(book);

    emit(state.copyWith(isFavorite: favoritesCubit.isFavorite(book)));
  }

  Future<void> startReading() async {
    await libraryCubit.startReading(book);

    emit(state.copyWith(isReading: true));
  }
}
