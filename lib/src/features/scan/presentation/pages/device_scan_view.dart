import 'package:flushare/src/core/network/wifi_handler.dart';
import 'package:flutter/material.dart';

class DeviceScanView extends StatefulWidget {
  const DeviceScanView({super.key});

  @override
  State<DeviceScanView> createState() => _DeviceScanViewState();
}

class _DeviceScanViewState extends State<DeviceScanView> {
  WifiHandler wifiHandler = WifiHandler();

  @override
  void initState() {
    wifiHandler.startServer();
    wifiHandler.broadcastDynamicPort();
    wifiHandler.listenForBroadcasts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Nearby Devices"),
      ),
    );
  }
}
