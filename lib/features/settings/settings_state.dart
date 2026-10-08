class SettingsState {
  final bool isArabic;
  final bool isDark;
  final bool notificationsOn;
  final double fontScale;

  SettingsState({
    this.isArabic = true,
    this.isDark = false,
    this.notificationsOn = true,
    this.fontScale = 1.0,
  });

  SettingsState copyWith({
    bool? isArabic,
    bool? isDark,
    bool? notificationsOn,
    double? fontScale,
  }) {
    return SettingsState(
      isArabic: isArabic ?? this.isArabic,
      isDark: isDark ?? this.isDark,
      notificationsOn: notificationsOn ?? this.notificationsOn,
      fontScale: fontScale ?? this.fontScale,
    );
  }
}
