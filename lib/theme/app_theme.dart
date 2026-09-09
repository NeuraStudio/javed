import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData dark(Color accent) => ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor: Colors.black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.black, elevation: 0),
      );

  static ThemeData light(Color accent) => ThemeData.light(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.light,
        ),
      );

  // NeuraAster brand gradient (from the app logo): cyan -> blue -> violet
  static const List<Color> brandGradient = [
    Color(0xFF22D3EE),
    Color(0xFF3B82F6),
    Color(0xFFA855F7),
  ];
}
