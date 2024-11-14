import 'package:flushare/src/config/theme/app_theme.dart';
import 'package:flushare/src/features/home/presentation/pages/select_transfer_option_view.dart';
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
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const SelectTransferOptionView(),
    );
  }
}
