import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preproject_books/core/app_colors.dart';
import 'package:preproject_books/core/localization.dart';
import 'package:preproject_books/core/shared/common_widgets.dart';
import 'package:preproject_books/features/settings/settings_cubit.dart';

class SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        context.tr('الإعدادات', 'Settings'),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: context.card,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF2A2421)
          : Colors.white,
      elevation: 0,
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style:
              TextStyle(color: context.textColor, fontWeight: FontWeight.w600),
        ),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: TextStyle(color: context.mutedColor)),
        trailing: trailing,
      ),
    );
  }
}

class NotificationsSwitch extends StatelessWidget {
  const NotificationsSwitch({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: value,
      activeColor: AppColors.primary,
      onChanged: (value) {
        context.read<SettingsCubit>().changeNotifications(value);
      },
    );
  }
}

class LanguageSheet extends StatelessWidget {
  const LanguageSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.read<SettingsCubit>().state.isArabic;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHandle(),
            SizedBox(height: 20),
            Text(
              context.tr('اختاري اللغة', 'Choose language'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            LanguageOption(title: 'العربية', selected: isArabic, value: true),
            LanguageOption(title: 'English', selected: !isArabic, value: false),
          ],
        ),
      ),
    );
  }
}

class LanguageOption extends StatelessWidget {
  const LanguageOption({
    super.key,
    required this.title,
    required this.selected,
    required this.value,
  });

  final String title;
  final bool selected;
  final bool value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing:
          selected ? Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () async {
        await context.read<SettingsCubit>().changeLanguage(value);

        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }
}

class FontSizeSheet extends StatelessWidget {
  const FontSizeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final scale = context.read<SettingsCubit>().state.fontScale;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHandle(),
            SizedBox(height: 20),
            Text(
              context.tr('حجم الخط', 'Font size'),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            FontSizeOption(
              title: context.tr('صغير', 'Small'),
              value: 0.85,
              selected: scale == 0.85,
            ),
            FontSizeOption(
              title: context.tr('متوسط', 'Medium'),
              value: 1.0,
              selected: scale == 1.0,
            ),
            FontSizeOption(
              title: context.tr('كبير', 'Large'),
              value: 1.15,
              selected: scale == 1.15,
            ),
          ],
        ),
      ),
    );
  }
}

class FontSizeOption extends StatelessWidget {
  const FontSizeOption({
    super.key,
    required this.title,
    required this.value,
    required this.selected,
  });

  final String title;
  final double value;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing:
          selected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () async {
        await context.read<SettingsCubit>().changeFontScale(value);

        if (context.mounted) {
          Navigator.pop(context);
        }
      },
    );
  }
}

void showPrivacyDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        backgroundColor: context.bg,
        title: Text(context.tr('الخصوصية', 'Privacy')),
        content: Text(
          context.tr(
            'نحن نهتم بخصوصيتك ونحافظ على بياناتك.',
            'We care about your privacy and protect your data.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(context.tr('إغلاق', 'Close')),
          ),
        ],
      );
    },
  );
}
