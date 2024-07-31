
import 'package:flutter/material.dart';

class AppTheme{
  static final  _borderDesign = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.white.withOpacity(0.2)
    ),
    borderRadius: BorderRadius.circular(20),
  );

  static final lightThemeMode = ThemeData.light().copyWith(
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(20),
      enabledBorder: _borderDesign,
      focusedBorder: _borderDesign
    )
  );
}