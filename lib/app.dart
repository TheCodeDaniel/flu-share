import 'package:flushare/src/config/bloc_manager.dart';
import 'package:flushare/src/config/routes/routes.dart';
import 'package:flushare/src/config/theme/app_theme.dart';
import 'package:flushare/src/features/file_transfer/presentation/pages/device_scan_view.dart';
import 'package:flushare/src/features/home/presentation/pages/select_transfer_option_view.dart';
import 'package:flushare/src/features/settings/presentation/pages/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return MultiBlocProvider(
      providers: BlocManager.blocProviders,
      child: MaterialApp(
        locale: const Locale('en'),
        debugShowCheckedModeBanner: false,
        theme: AppTheme.themeData,
        initialRoute: '/',
        routes: {
          RouteName.defaultView: (context) => SelectTransferOptionView(),
          RouteName.deviceScanView: (context) => DeviceScanView(),
          RouteName.settingsView: (context) => SettingsView(),
        },
      ),
    );
  }
}
