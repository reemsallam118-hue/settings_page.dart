import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:preproject_books/core/app_colors.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/core/shared/common_widgets.dart';
import 'package:preproject_books/features/library/library_cubit.dart';
import 'package:preproject_books/core/models/book.dart';

class LibraryAppBar extends StatelessWidget {
  const LibraryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        context.tr('مكتبتي', 'My Library'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class LibraryTabs extends StatelessWidget {
  const LibraryTabs({super.key, required this.selected});

  final LibraryTab selected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          LibraryTabButton(
            tab: LibraryTab.all,
            selected: selected,
            title: context.tr('الكل', 'All'),
          ),
          LibraryTabButton(
            tab: LibraryTab.reading,
            selected: selected,
            title: context.tr('أقرأ الآن', 'Reading'),
          ),
          LibraryTabButton(
            tab: LibraryTab.finished,
            selected: selected,
            title: context.tr('منتهية', 'Finished'),
          ),
        ],
      ),
    );
  }
}

class LibraryTabButton extends StatelessWidget {
  const LibraryTabButton({
    super.key,
    required this.tab,
    required this.selected,
    required this.title,
  });

  final LibraryTab tab;
  final LibraryTab selected;
  final String title;

  @override
  Widget build(BuildContext context) {
    final active = tab == selected;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(title),
        selected: active,
        selectedColor: AppColors.primary,
        labelStyle: TextStyle(color: active ? Colors.white : context.textColor),
        onSelected: (_) {
          context.read<LibraryCubit>().selectTab(tab);
        },
      ),
    );
  }
}

class BookProgressFooter extends StatelessWidget {
  const BookProgressFooter({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final safeProgress = progress.clamp(0.0, 1.0);
    final percent = (safeProgress * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: Text(
            '$percent%',
            style: TextStyle(color: context.mutedColor, fontSize: 12),
          ),
        ),
        SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: safeProgress,
            minHeight: 4,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class ProgressSheet extends StatefulWidget {
  const ProgressSheet({
    super.key,
    required this.book,
    required this.initialProgress,
  });

  final Book book;
  final double initialProgress;

  @override
  State<ProgressSheet> createState() => _ProgressSheetState();
}

class _ProgressSheetState extends State<ProgressSheet> {
  late double progress;

  @override
  void initState() {
    super.initState();
    progress = widget.initialProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SheetHandle(),
          SizedBox(height: 20),
          Text(
            context.tr('نسبة القراءة', 'Reading progress'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Text(
            '${(progress * 100).round()}%',
            style: TextStyle(
              fontSize: 24,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          Slider(
            value: progress,
            onChanged: (value) {
              setState(() {
                progress = value;
              });
            },
            activeColor: AppColors.primary,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              await context.read<LibraryCubit>().setProgress(
                widget.book,
                progress,
              );

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: Text(context.tr('حفظ', 'Save')),
          ),
        ],
      ),
    );
  }
}
