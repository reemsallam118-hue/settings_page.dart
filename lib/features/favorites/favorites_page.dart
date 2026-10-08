import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/core/shared/book_list_card.dart';
import 'package:preproject_books/core/shared/empty_state.dart';
import 'package:preproject_books/features/book_details/book_details_page.dart';
import 'package:preproject_books/features/favorites/favorites_cubit.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key, this.onDiscover});

  final VoidCallback? onDiscover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('المفضلة', 'Favorites'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          if (state.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.books.isEmpty) {
            return EmptyState(
              title: context.tr(' قائمة المفضلة فارغة ', 'No favorite books'),
              subtitle: context.tr(
                'ابدأ بإضافة الكتب التي تحبها ',
                'Start adding books you love',
              ),
              buttonText: context.tr('اكتشف الكتب', 'Discover books'),
              onPressed: onDiscover,
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: state.books.length,
            itemBuilder: (context, index) {
              final book = state.books[index];

              return BookListCard(
                book: book,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookDetailsPage(book: book),
                    ),
                  );
                },
                trailing: IconButton(
                  onPressed: () {
                    context.read<FavoritesCubit>().remove(book);
                  },
                  icon: Icon(Icons.favorite, color: Color(0xFFA8434B)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
