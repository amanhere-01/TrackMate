import 'package:flutter/material.dart';
import 'package:track_mate/core/theme/theme.dart';

import 'features/auth/pages/sign_in_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightThemeMode,
      home: const SignInPage(),
    );
  }
}
