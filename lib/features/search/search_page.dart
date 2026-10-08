import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preproject_books/core/app_colors.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/core/repo/books_repo.dart';
import 'package:preproject_books/core/shared/book_list_card.dart';
import 'package:preproject_books/core/shared/empty_state.dart';
import 'package:preproject_books/features/book_details/book_details_page.dart';
import 'package:preproject_books/features/favorites/favorites_cubit.dart';
import 'package:preproject_books/features/search/search_cubit.dart';
import 'package:preproject_books/widgets/search_widgets.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key, this.initialQuery = ''});

  final String initialQuery;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(context.read<BooksRepository>()),
      child: SearchView(initialQuery: initialQuery),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.initialQuery);

    if (widget.initialQuery.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<SearchCubit>().search(widget.initialQuery);
      });
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SearchField(
              controller: controller,
              onChanged: (value) {
                context.read<SearchCubit>().search(value);
              },
            ),
            SizedBox(height: 12),
            BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return SearchTabs(selected: state.type);
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.loading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state.books.isEmpty) {
                    if (state.hasError) {
                      return EmptyState(
                        title: context.tr(
                          'حدث خطأ أثناء البحث',
                          'Search failed',
                        ),
                        subtitle: context.tr(
                          'حاول مرة أخرى',
                          'Please try again',
                        ),
                      );
                    }
                    return EmptyState(
                      title: context.tr(' لا يوجد نتائج', 'No results'),
                      subtitle: context.tr(
                        'جرب كلمة بحث مختلفة',
                        'Try another search term',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: state.books.length,
                    itemBuilder: (context, index) {
                      final book = state.books[index];

                      return BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, favoritesState) {
                          final favorite = favoritesState.books.any(
                            (item) => item.key == book.key,
                          );

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
                                context.read<FavoritesCubit>().toggle(book);
                              },
                              icon: Icon(
                                favorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: AppColors.primary,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
