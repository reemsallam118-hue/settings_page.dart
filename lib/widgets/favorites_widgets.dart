import 'package:flutter/material.dart';

import 'package:preproject_books/core/app_colors.dart';
import 'package:preproject_books/core/localization.dart';

class FavoritesAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FavoritesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        context.tr('المفضلة', 'Favorites'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(kToolbarHeight);
  }
}

class FavoriteRemoveButton extends StatelessWidget {
  const FavoriteRemoveButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(Icons.favorite, color: AppColors.primary),
    );
  }
}
