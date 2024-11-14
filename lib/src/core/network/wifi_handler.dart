import 'dart:developer';
import 'dart:io';

import 'package:flushare/src/core/constants/bool_modes.dart';
import 'package:flutter/services.dart';

class WifiHandler {
  static const platform = MethodChannel('com.flushare/wifi');

  Future<void> startWifiDirect() async {
    try {
      final result = await platform.invokeMethod(
        kIsDesktop ? 'startNetworkListener' : 'startWifiDirect',
      );
      log(result.toString()); // Output: "Discovery started"
    } on PlatformException catch (e) {
      log("Failed to start Wi-Fi Direct: '${e.message}'.");
    }
  }

  Future<void> connectToPeer(String peerAddress, {int? port}) async {
    try {
      final result = await platform.invokeMethod(
        'connectToPeer',
        {
          'address': peerAddress,
          if (port != null) 'port': port,
        },
      );
      log(result.toString());
    } on PlatformException catch (e) {
      log("Failed to connect to peer: '${e.message}'.");
    }
  }

  Future<void> sendData(String ipAddress, int port, List<int> data) async {
    try {
      final socket = await Socket.connect(
        ipAddress,
        port,
        timeout: Duration(seconds: 5),
      );
      socket.add(data);
      await socket.flush();
      await socket.close();
      log('Data sent to $ipAddress:$port');
    } catch (e) {
      log("Failed to send data: $e");
    }
  }

  Future<void> startServer(int port) async {
    try {
      final ServerSocket server = await ServerSocket.bind(
        InternetAddress.anyIPv4,
        port,
      );
      log("Server started on port $port");

      await for (Socket socket in server) {
        log('New connection from ${socket.remoteAddress.address}:${socket.remotePort}');
        socket.listen((data) {
          log('Received data: $data');
          // Handle received data here
        }, onError: (error) {
          log("Connection error: $error");
        }, onDone: () {
          log("Client done and disconnected");
        });
      }
    } catch (e) {
      log("Failed to start server: $e");
    }
  }
}
