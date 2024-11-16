import 'dart:developer';
import 'dart:io';

import 'package:flushare/src/core/constants/bool_modes.dart';
import 'package:flutter/services.dart';

class WifiHandler {
  static const MethodChannel platform = MethodChannel('com.flushare/wifi');

  Future<void> scanForDevices() async {
    try {
      final address = InternetAddress('255.255.255.255');
      final port = 12345; // Port to send/receive messages

      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

      // Send a broadcast message
      socket.send('Hello, device!'.codeUnits, address, port);
      log('Sent broadcast message to $address:$port');

      // Listen for responses from devices
      socket.listen((RawSocketEvent event) async {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null) {
            final deviceMessage = String.fromCharCodes(datagram.data);
            log('Received response: $deviceMessage');
            // Handle device response (e.g., log IP or connect)
          }
        }
      });

      // Optional: Stop listening after a timeout
      await Future.delayed(Duration(seconds: 5));
      socket.close();
    } catch (e) {
      log("Failed to scan for devices: $e");
    }
  }

  Future<void> startWifiDirect() async {
    try {
      final dynamic result = await platform.invokeMethod(
        kIsDesktop ? 'startNetworkListener' : 'startWifiDirect',
      );
      log(result.toString()); // Output: "Discovery started"
    } on PlatformException catch (e) {
      log("Failed to start Wi-Fi Direct: '${e.message}'.");
    }
  }

  Future<void> connectToPeer(String peerAddress, {int? port}) async {
    try {
      final dynamic result = await platform.invokeMethod(
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
      final Socket socket = await Socket.connect(
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
