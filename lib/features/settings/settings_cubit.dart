import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preproject_books/core/repo/settings_repository.dart';
import 'package:preproject_books/features/settings/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this.repository) : super( SettingsState());

  final SettingsRepository repository;

  Future<void> load() async {
    final values = await repository.load();

    emit(
      SettingsState(
        isArabic: values['isArabic']! as bool,
        isDark: values['isDark']! as bool,
        notificationsOn: values['notificationsOn']! as bool,
        fontScale: values['fontScale']! as double,
      ),
    );
  }

  Future<void> changeLanguage(bool value) async {
    emit(state.copyWith(isArabic: value));

    await repository.setBool('isArabic', value);
  }

  Future<void> changeTheme(bool value) async {
    emit(state.copyWith(isDark: value));

    await repository.setBool('isDark', value);
  }

  Future<void> changeNotifications(bool value) async {
    emit(state.copyWith(notificationsOn: value));

    await repository.setBool('notificationsOn', value);
  }

  Future<void> changeFontScale(double value) async {
    emit(state.copyWith(fontScale: value));

    await repository.setDouble('fontScale', value);
  }
}
