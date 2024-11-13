import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';

class WifiHandler {
  static const platform = MethodChannel('com.flushare/wifi');

  Future<void> startWifiDirect() async {
    try {
      final result = await platform.invokeMethod('startWifiDirect');
      log(result.toString()); // Output: "Discovery started"
    } on PlatformException catch (e) {
      log("Failed to start Wi-Fi Direct: '${e.message}'.");
    }
  }

  Future<void> connectToPeer(String peerAddress) async {
    try {
      final result = await platform.invokeMethod(
        'connectToPeer',
        {
          'address': peerAddress,
        },
      );
      log(result.toString());
    } on PlatformException catch (e) {
      log("Failed to connect to peer: '${e.message}'.");
    }
  }

  Future<void> sendData(String ipAddress, int port, List<int> data) async {
    final socket = await Socket.connect(ipAddress, port);
    socket.add(data);
    await socket.flush();
    await socket.close();
  }

  Future<void> startServer(int port) async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    await for (var socket in server) {
      socket.listen((data) {
        // Handle received data here
      });
    }
  }
}
