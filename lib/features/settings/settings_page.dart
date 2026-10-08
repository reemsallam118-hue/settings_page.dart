import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/features/settings/settings_cubit.dart';
import 'package:preproject_books/features/settings/settings_state.dart';
import 'package:preproject_books/widgets/settings_widgets.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingsAppBar(),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              SettingsTile(
                icon: Icons.language,
                title: context.tr('اللغة', 'Language'),
                subtitle: state.isArabic ? 'العربية' : 'English',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => LanguageSheet(),
                  );
                },
              ),
              SettingsTile(
                icon: Icons.text_fields,
                title: context.tr('حجم الخط', 'Font Size'),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => FontSizeSheet(),
                  );
                },
              ),
              SettingsTile(
                icon: Icons.dark_mode_outlined,
                title: context.tr('الوضع الداكن', 'Dark Mode'),
                trailing: Switch(
                  value: state.isDark,
                  onChanged: (value) {
                    context.read<SettingsCubit>().changeTheme(value);
                  },
                ),
              ),
              SettingsTile(
                icon: Icons.notifications_outlined,
                title: context.tr('الإشعارات', 'Notifications'),
                trailing: NotificationsSwitch(value: state.notificationsOn),
              ),
              SettingsTile(
                icon: Icons.privacy_tip_outlined,
                title: context.tr('الخصوصية', 'Privacy'),
                onTap: () {
                  showPrivacyDialog(context);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
