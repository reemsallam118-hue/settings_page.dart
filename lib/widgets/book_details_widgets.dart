import 'package:flutter/material.dart';
import 'package:preproject_books/core/app_colors.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/core/models/book.dart';
import 'package:preproject_books/core/shared/book_cover.dart';
import 'package:preproject_books/core/shared/common_widgets.dart';

class BookDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        context.tr('تفاصيل الكتاب', 'Book Details'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class BookDetailsHeader extends StatelessWidget {
  const BookDetailsHeader({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                book.title,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: context.textColor,
                ),
              ),
              SizedBox(height: 8),
              Text(
                book.author,
                style: TextStyle(color: context.mutedColor, fontSize: 15),
              ),
              if (book.ratingAverage != null) ...[
                SizedBox(height: 12),
                RatingRow(rating: book.ratingAverage!),
              ],
            ],
          ),
        ),
        SizedBox(width: 18),
        BookCover(bookUrl: book.coverUrl, width: 132, height: 195),
      ],
    );
  }
}

class ReadButton extends StatelessWidget {
  const ReadButton({
    super.key,
    required this.isReading,
    required this.onPressed,
  });

  final bool isReading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.menu_book),
        label: Text(
          isReading
              ? context.tr('موجود في مكتبتي', 'In My Library')
              : context.tr('ابدأ القراءة', 'Start Reading'),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onPressed,
  });

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: AppColors.primary,
        size: 30,
      ),
    );
  }
}

class AboutBookCard extends StatelessWidget {
  const AboutBookCard({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final hasMetadata =
        book.firstPublishYear != null || book.ratingCount != null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.08),
        ),
        boxShadow: softShadow(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.auto_stories_rounded,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  context.tr('عن الكتاب', 'About the book'),
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: context.textColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Divider(
            height: 1,
            color: context.mutedColor.withValues(alpha: 0.18),
          ),
          SizedBox(height: 16),
          Text(
            hasMetadata
                ? context.tr(
                    'تفاصيل النشر والتقييم المتاحة لهذا الكتاب.',
                    'Available publication and rating details for this book.',
                  )
                : context.tr(
                    'لا توجد تفاصيل إضافية عن هذا الكتاب حاليًا.',
                    'No additional details are available for this book yet.',
                  ),
            style: TextStyle(
              color: context.mutedColor,
              fontSize: 15,
              height: 1.6,
            ),
          ),
          if (hasMetadata) ...[
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (book.firstPublishYear != null)
                  InfoChip(
                    label: '${book.firstPublishYear}',
                    icon: Icons.calendar_month_rounded,
                  ),
                if (book.ratingCount != null)
                  InfoChip(
                    label: context.tr(
                      '${book.ratingCount} تقييم',
                      '${book.ratingCount} ratings',
                    ),
                    icon: Icons.star_outline_rounded,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
