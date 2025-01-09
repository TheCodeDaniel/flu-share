import 'package:flutter/material.dart';

class DeviceScanView extends StatefulWidget {
  const DeviceScanView({super.key});

  @override
  State<DeviceScanView> createState() => _DeviceScanViewState();
}

class _DeviceScanViewState extends State<DeviceScanView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Find Nearby Devices"),
      ),
    );
  }
}
