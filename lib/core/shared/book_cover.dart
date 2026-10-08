import 'package:flutter/material.dart';

import 'package:preproject_books/core/app_colors.dart';

class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.bookUrl,
    this.width = 80,
    this.height = 120,
    this.borderRadius = 8,
  });

  final String? bookUrl;
  final double width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: bookUrl == null
          ? Container(
              width: width,
              height: height,
              color: AppColors.primary.withValues(alpha: 0.12),
              child: Icon(Icons.menu_book, color: AppColors.primary),
            )
          : Image.network(
              bookUrl!,
              width: width,
              height: height,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: width,
                  height: height,
                  color: AppColors.primary.withValues(alpha: 0.12),
                  child: Icon(Icons.menu_book, color: AppColors.primary),
                );
              },
            ),
    );
  }
}
