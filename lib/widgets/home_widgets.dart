import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preproject_books/core/app_colors.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/core/models/book.dart';
import 'package:preproject_books/core/shared/book_cover.dart';
import 'package:preproject_books/core/shared/common_widgets.dart';
import 'package:preproject_books/features/home/home_cubit.dart';

class BookCategory {
  const BookCategory({
    required this.arabicTitle,
    required this.englishTitle,
    required this.query,
    required this.icon,
  });

  final String arabicTitle;
  final String englishTitle;
  final String query;
  final IconData icon;
}

const bookCategories = <BookCategory>[
  BookCategory(
    arabicTitle: 'روايات',
    englishTitle: 'Novels',
    query: 'fiction',
    icon: Icons.menu_book_outlined,
  ),
  BookCategory(
    arabicTitle: 'شعر',
    englishTitle: 'Poetry',
    query: 'poetry',
    icon: Icons.edit_outlined,
  ),
  BookCategory(
    arabicTitle: 'تاريخ',
    englishTitle: 'History',
    query: 'history',
    icon: Icons.account_balance_outlined,
  ),
  BookCategory(
    arabicTitle: 'علم نفس',
    englishTitle: 'Psychology',
    query: 'psychology',
    icon: Icons.psychology_outlined,
  ),
  BookCategory(
    arabicTitle: 'كتب عربي',
    englishTitle: 'Arabic books',
    query: 'Arabic',
    icon: Icons.auto_stories_outlined,
  ),
  BookCategory(
    arabicTitle: 'تنمية بشرية',
    englishTitle: 'Personal growth',
    query: 'self help',
    icon: Icons.trending_up,
  ),
  BookCategory(
    arabicTitle: 'رعب',
    englishTitle: 'Horror',
    query: 'horror',
    icon: Icons.nights_stay_outlined,
  ),
  BookCategory(
    arabicTitle: 'علوم',
    englishTitle: 'Science',
    query: 'science',
    icon: Icons.science_outlined,
  ),
  BookCategory(
    arabicTitle: 'فلسفة',
    englishTitle: 'Philosophy',
    query: 'philosophy',
    icon: Icons.lightbulb_outline,
  ),
  BookCategory(
    arabicTitle: 'دينية',
    englishTitle: 'Religion',
    query: 'religion',
    icon: Icons.auto_awesome_outlined,
  ),
];

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        'Bookia',
        style: TextStyle(fontWeight: FontWeight.bold, color: context.textColor),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class HomeSearchBox extends StatelessWidget {
  const HomeSearchBox({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.primary),
            SizedBox(width: 10),
            Text(
              context.tr('ابحثي عن كتاب...', 'Search for a book...'),
              style: TextStyle(color: context.mutedColor),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({super.key, this.onSeeAll});

  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: context.tr('التصنيفات', 'Categories'),
          onSeeAll: onSeeAll,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.86,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            final category = bookCategories[index];
            return CategoryBox(
              title: context.tr(category.arabicTitle, category.englishTitle),
              query: category.query,
              icon: category.icon,
            );
          },
        ),
      ],
    );
  }
}

class CategoryBox extends StatelessWidget {
  const CategoryBox({
    super.key,
    required this.title,
    required this.query,
    required this.icon,
  });

  final String title;
  final String query;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<CategoryBooksCubit>().load(query);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (_) => CategoryBooksSheet(title: title),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: softShadow(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: AppColors.primary),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class FeaturedBookCard extends StatelessWidget {
  const FeaturedBookCard({super.key, required this.book, this.onTap});

  final Book book;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 150,
        margin: EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(bookUrl: book.coverUrl, width: 150, height: 210),
            SizedBox(height: 8),
            Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
            ),
            SizedBox(height: 4),
            Text(
              book.author,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.mutedColor),
            ),
            SizedBox(height: 4),
            if (book.ratingAverage != null)
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 14),
                  SizedBox(width: 4),
                  Text(
                    book.ratingAverage!.toStringAsFixed(1),
                    style: TextStyle(color: context.mutedColor, fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class CategoryBooksSheet extends StatelessWidget {
  const CategoryBooksSheet({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBooksCubit, CategoryBooksState>(
      builder: (context, state) {
        if (state.loading) {
          return SizedBox(
            height: 300,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final books = state.books;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SheetHandle(),
                SizedBox(height: 15),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                if (state.hasError)
                  Text(context.tr('تعذر تحميل الكتب', 'Could not load books')),
                if (!state.hasError && books.isEmpty)
                  Text(
                    context.tr(
                      'لا توجد كتب في هذا التصنيف',
                      'No books found in this category',
                    ),
                  ),
                SizedBox(
                  height: 350,
                  child: ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: BookCover(
                          bookUrl: books[index].coverUrl,
                          width: 45,
                          height: 65,
                        ),
                        title: Text(books[index].title),
                        subtitle: Text(books[index].author),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        backgroundColor: context.card,
        indicatorColor: Colors.transparent,
        height: 68,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 10,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            color: selected ? AppColors.primary : context.mutedColor,
          );
        }),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: context.tr('الرئيسية', 'Home'),
          ),
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: context.tr('بحث', 'Search'),
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: context.tr('مكتبتي', 'Library'),
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: context.tr('المفضلة', 'Favorites'),
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: context.tr('الإعدادات', 'Settings'),
          ),
        ],
      ),
    );
  }
}
