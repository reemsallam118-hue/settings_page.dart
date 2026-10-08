import 'package:flutter/material.dart';

extension AppLocalization on BuildContext {
  String tr(String arabic, String english) {
    return Localizations.localeOf(this).languageCode == 'ar' ? arabic : english;
  }
}
