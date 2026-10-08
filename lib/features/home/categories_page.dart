import 'package:flutter/material.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/widgets/home_widgets.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('التصنيفات', 'Categories'))),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        itemCount: bookCategories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.35,
        ),
        itemBuilder: (context, index) {
          final category = bookCategories[index];
          return CategoryBox(
            title: context.tr(category.arabicTitle, category.englishTitle),
            query: category.query,
            icon: category.icon,
          );
        },
      ),
    );
  }
}
