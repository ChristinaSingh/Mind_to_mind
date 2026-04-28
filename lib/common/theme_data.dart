import 'package:flutter/material.dart';

import 'colors.dart';

class MThemeData {
  static ThemeData themeData() {
    return ThemeData(
      fontFamily: 'Poppins',
      primaryColor: primaryColor,
      secondaryHeaderColor: primaryColor,
      hintColor: primaryColor,
      focusColor: primaryColor,
      hoverColor: primaryColor,
      highlightColor: primaryColor,
      unselectedWidgetColor: primaryColor,
      cardColor: backgroundColor,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionColor: primaryColor.withOpacity(0.3),
        selectionHandleColor: primaryColor,
      ),
      colorScheme:
      ColorScheme.fromSwatch(
        primarySwatch: Colors.green,
        accentColor: primaryColor,
        backgroundColor: backgroundColor,
      ).copyWith(
        primary: primaryColor,
        secondary: primaryColor,
        onPrimary: backgroundColor,
        onSecondary: backgroundColor,
      ),
    );
  }
}