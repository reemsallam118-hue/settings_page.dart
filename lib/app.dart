import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:preproject_books/core/app_theme.dart';
import 'package:preproject_books/core/repo/books_repo.dart';
import 'package:preproject_books/core/repo/settings_repository.dart';
import 'package:preproject_books/core/services/books_api.dart';
import 'package:preproject_books/features/favorites/favorites_cubit.dart';
import 'package:preproject_books/features/favorites/favorites_repository.dart';
import 'package:preproject_books/features/home/home_cubit.dart';
import 'package:preproject_books/features/library/library_cubit.dart';
import 'package:preproject_books/features/library/library_repository.dart';
import 'package:preproject_books/features/settings/settings_cubit.dart';
import 'package:preproject_books/features/settings/settings_state.dart';
import 'package:preproject_books/features/splash/splash_page.dart';

class BookiaApp extends StatefulWidget {
  const BookiaApp({super.key});

  @override
  State<BookiaApp> createState() => _BookiaAppState();
}

class _BookiaAppState extends State<BookiaApp> {
  late final SettingsCubit settingsCubit;
  late final FavoritesCubit favoritesCubit;
  late final LibraryCubit libraryCubit;
  late final Future<void> initialization;

  @override
  void initState() {
    super.initState();

    settingsCubit = SettingsCubit(SettingsRepository());
    favoritesCubit = FavoritesCubit(FavoritesRepository());
    libraryCubit = LibraryCubit(LibraryRepository());

    initialization = Future.wait<void>([
      settingsCubit.load(),
      favoritesCubit.load(),
      libraryCubit.load(),
    ]);
  }

  @override
  void dispose() {
    settingsCubit.close();
    favoritesCubit.close();
    libraryCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<BooksRepository>(
      create: (_) => const BooksRepository(BooksApi()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: settingsCubit),
          BlocProvider.value(value: favoritesCubit),
          BlocProvider.value(value: libraryCubit),
          BlocProvider<CategoryBooksCubit>(
            create: (context) => CategoryBooksCubit(
              context.read<BooksRepository>(),
            ),
          ),
        ],
        child: FutureBuilder<void>(
          future: initialization,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return MaterialApp(
                theme: lightTheme,
                home: const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            return BookiaMaterialApp();
          },
        ),
      ),
    );
  }
}

class BookiaMaterialApp extends StatelessWidget {
  BookiaMaterialApp();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bookia',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
          locale: Locale(state.isArabic ? 'ar' : 'en'),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            Locale('ar'),
            Locale('en'),
          ],
          home: const SplashPage(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(state.fontScale),
              ),
              child: child ?? SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}
