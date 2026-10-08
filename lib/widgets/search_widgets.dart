import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:preproject_books/core/app_colors.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/features/search/search_cubit.dart';

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        context.tr('البحث', 'Search'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: context.tr(
          'ابحثي عن كتاب أو مؤلف',
          'Search for a book or author',
        ),
        prefixIcon: Icon(Icons.search, color: AppColors.primary),
        filled: true,
        fillColor: context.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class SearchTabs extends StatelessWidget {
  const SearchTabs({super.key, required this.selected});

  final SearchType selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SearchTab(
          type: SearchType.all,
          selected: selected,
          title: context.tr('الكل', 'All'),
        ),
        SearchTab(
          type: SearchType.books,
          selected: selected,
          title: context.tr('كتب', 'Books'),
        ),
        SearchTab(
          type: SearchType.authors,
          selected: selected,
          title: context.tr('مؤلفين', 'Authors'),
        ),
      ],
    );
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({
    super.key,
    required this.type,
    required this.selected,
    required this.title,
  });

  final SearchType type;
  final SearchType selected;
  final String title;

  @override
  Widget build(BuildContext context) {
    final active = type == selected;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: ChoiceChip(
          label: Text(title),
          selected: active,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: active ? Colors.white : context.textColor,
          ),
          onSelected: (_) {
            context.read<SearchCubit>().changeType(type);
          },
        ),
      ),
    );
  }
}
