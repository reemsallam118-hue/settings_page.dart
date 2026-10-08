import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/core/repo/books_repo.dart';
import 'package:preproject_books/core/shared/common_widgets.dart';
import 'package:preproject_books/features/book_details/book_details_page.dart';
import 'package:preproject_books/features/favorites/favorites_page.dart';
import 'package:preproject_books/features/home/categories_page.dart';
import 'package:preproject_books/features/home/home_cubit.dart';
import 'package:preproject_books/features/library/library_page.dart';
import 'package:preproject_books/features/search/search_page.dart';
import 'package:preproject_books/features/settings/settings_page.dart';
import 'package:preproject_books/widgets/home_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        context.read<BooksRepository>(),
      ),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final pages = [
          HomeContent(),
          SearchPage(),
          LibraryPage(
            onDiscover: () {
              context.read<HomeCubit>().changeIndex(1);
            },
          ),
          FavoritesPage(
            onDiscover: () {
              context.read<HomeCubit>().changeIndex(1);
            },
          ),
          SettingsPage(),
        ];

        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: pages,
          ),
          bottomNavigationBar: AppBottomNav(
            currentIndex: state.currentIndex,
            onTap: (index) {
              context.read<HomeCubit>().changeIndex(index);
            },
          ),
        );
      },
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: () {
          return context.read<HomeCubit>().loadFeatured();
        },
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            HomeSearchBox(
              onTap: () {
                context.read<HomeCubit>().changeIndex(1);
              },
            ),
            SizedBox(height: 24),
            CategoriesSection(
              onSeeAll: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CategoriesPage(),
                  ),
                );
              },
            ),
            SizedBox(height: 24),
            SectionTitle(
              title: context.tr('كتب مميزة', 'Featured Books'),
            ),
            SizedBox(height: 12),
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state.loading) {
                  return SizedBox(
                    height: 220,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (state.hasError) {
                  return Center(
                    child: TextButton(
                      onPressed: context.read<HomeCubit>().loadFeatured,
                      child: Text(
                        context.tr(
                          'تعذر تحميل الكتب، حاول مرة أخرى',
                          'Could not load books. Tap to retry.',
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  height: 300,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.featuredBooks.length,
                    itemBuilder: (context, index) {
                      final book = state.featuredBooks[index];

                      return FeaturedBookCard(
                        book: book,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BookDetailsPage(book: book),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
