import 'package:flushare/src/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  void systemUiOverlay = SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  // light mode theme color
  static ThemeData themeData = ThemeData.light(
    useMaterial3: false,
  ).copyWith(
    primaryColor: AppColors.primaryColor,
    datePickerTheme: DatePickerThemeData(
      headerBackgroundColor: AppColors.primaryColor,
    ),
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.kWhite,

    /// Icon
    iconTheme: IconThemeData(color: AppColors.primaryColor),

    /// AppBar
    appBarTheme: AppBarTheme(
      color: AppColors.kWhite,
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(
        color: Colors.black,
        size: 20,
      ),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 17.5,
      ),
    ),

    /// Text
    textTheme: buildTextTheme(ThemeData.light().textTheme),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColors.primaryColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
    ),
    listTileTheme: ListTileThemeData(
      tileColor: AppColors.kGrey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}

String _fontName = "Rubik";
String get fontName => _fontName;

TextTheme buildTextTheme(TextTheme base) {
  return TextTheme(
    /// Body Text
    bodySmall: TextStyle(
      fontFamily: _fontName,
      height: 1.33,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontFamily: _fontName,
      height: 1.43,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontFamily: _fontName,
      height: 1.5,
      color: Colors.black,
    ),

    /// Label Text
    labelSmall: TextStyle(
      fontFamily: _fontName,
      height: 1.45,
      color: Colors.black,
    ),
    labelMedium: TextStyle(
      fontFamily: _fontName,
      height: 1.33,
      color: Colors.black,
    ),
    labelLarge: TextStyle(
      fontFamily: _fontName,
      height: 1.43,
      color: Colors.black,
    ),

    /// Title Text
    titleSmall: TextStyle(
      fontFamily: _fontName,
      height: 1.43,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontFamily: _fontName,
      height: 1.5,
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      fontFamily: _fontName,
      height: 1.27,
      color: Colors.black,
    ),

    /// Headline Text
    headlineSmall: TextStyle(
      fontFamily: _fontName,
      height: 1.33,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontFamily: _fontName,
      height: 1.29,
      color: Colors.black,
    ),
    headlineLarge: TextStyle(
      fontFamily: _fontName,
      height: 1.25,
      color: Colors.black,
    ),

    /// Display Text
    displaySmall: TextStyle(
      fontFamily: _fontName,
      height: 1.22,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontFamily: _fontName,
      height: 1.16,
      color: Colors.black,
    ),
    displayLarge: TextStyle(
      fontFamily: _fontName,
      height: 1.12,
      color: Colors.black,
    ),
  );
}
