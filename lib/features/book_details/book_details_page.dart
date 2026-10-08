import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:preproject_books/features/favorites/favorites_cubit.dart';
import 'package:preproject_books/core/models/book.dart';
import 'package:preproject_books/widgets/book_details_widgets.dart';
import 'package:preproject_books/features/library/library_cubit.dart';
import 'package:preproject_books/features/book_details/book_details_cubit.dart';

class BookDetailsPage extends StatelessWidget {
  const BookDetailsPage({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookDetailsCubit(
        book: book,
        favoritesCubit: context.read<FavoritesCubit>(),
        libraryCubit: context.read<LibraryCubit>(),
      ),
      child: const BookDetailsView(),
    );
  }
}

class BookDetailsView extends StatelessWidget {
  const BookDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookDetailsCubit>();

    return Scaffold(
      appBar: BookDetailsAppBar(),
      body: BlocBuilder<BookDetailsCubit, BookDetailsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                BookDetailsHeader(book: cubit.book),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ReadButton(
                        isReading: state.isReading,
                        onPressed: () async {
                          await cubit.startReading();

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Book added to your library'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 8),
                    FavoriteButton(
                      isFavorite: state.isFavorite,
                      onPressed: () {
                        cubit.toggleFavorite();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                AboutBookCard(book: cubit.book),
              ],
            ),
          );
        },
      ),
    );
  }
}
