import 'package:flutter/material.dart';
import 'package:preproject_books/core/app_colors.dart';
import 'package:preproject_books/core/models/book.dart';
import 'package:preproject_books/core/shared/book_cover.dart';
import 'package:preproject_books/core/shared/common_widgets.dart';

class BookListCard extends StatelessWidget {
  const BookListCard({
    super.key,
    required this.book,
    this.trailing,
    this.onTap,
    this.footer,
  });

  final Book book;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: softShadow(),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            onTap: onTap,
            contentPadding: EdgeInsets.all(10),
            leading: BookCover(bookUrl: book.coverUrl, width: 60, height: 85),
            title: Text(
              book.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: context.textColor,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: context.mutedColor),
              ),
            ),
            trailing:
                trailing ?? Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.muted,
                ),
          ),
          if (footer != null)
            Padding(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: footer,
            ),
        ],
      ),
    );
  }
}
