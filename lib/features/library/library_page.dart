import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/core/shared/book_list_card.dart';
import 'package:preproject_books/core/shared/empty_state.dart';
import 'package:preproject_books/features/book_details/book_details_page.dart';
import 'package:preproject_books/features/library/library_cubit.dart';
import 'package:preproject_books/widgets/library_widgets.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key, this.onDiscover});

  final VoidCallback? onDiscover;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.tr('مكتبتي', 'My Library'),
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<LibraryCubit, LibraryState>(
        builder: (context, state) {
          if (state.loading) {
            return Center(child: CircularProgressIndicator());
          }

          final books = context.read<LibraryCubit>().visibleBooks();

          if (books.isEmpty) {
            return EmptyState(
              title: context.tr(' المكتبة فارغة', 'Your library is empty'),
              subtitle: context.tr(
                'ابدأ بإضافة كتب لمكتبتك',
                'Start adding books to your library',
              ),
              buttonText: context.tr('اكتشف الكتب', 'Discover books'),
              onPressed: onDiscover,
            );
          }

          return Column(
            children: [
              LibraryTabs(selected: state.tab),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];

                    return BookListCard(
                      book: book,
                      footer: BookProgressFooter(
                        progress: state.progress[book.key] ?? 0,
                      ),
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
                          showModalBottomSheet(
                            context: context,
                            builder: (_) {
                              return ProgressSheet(
                                book: book,
                                initialProgress: context
                                    .read<LibraryCubit>()
                                    .getProgress(book),
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit, color: Color(0xFFA8434B)),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
