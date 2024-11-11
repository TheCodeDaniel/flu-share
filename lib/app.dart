import 'package:androp/src/config/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppInit {
  static void initializeAll() async {
    AppTheme().systemUiOverlay;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('en'),
      debugShowCheckedModeBanner: kDebugMode,
      theme: AppTheme.themeData,
      home: const Scaffold(),
    );
  }
}
