import 'dart:async';
import 'dart:io';

import 'package:flushare/src/config/global.dart';

class FileReceiveRepository {
  final int broadcastPort = 45454; // Port for broadcasting
  final String discoveryToken = "flushare-App-Discovery-Token"; // Unique token
  RawDatagramSocket? _socket;

  /// Start listening and broadcasting
  Future<void> makeDeviceDiscoverable() async {
    try {
      // Bind to any available network interface
      _socket =
          await RawDatagramSocket.bind(InternetAddress.anyIPv4, broadcastPort);
      _socket?.broadcastEnabled = true;

      printMessage("Listening for discovery messages on port $broadcastPort");

      // Start listening
      _socket?.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          final datagram = _socket?.receive();
          if (datagram != null) {
            final senderAddress = datagram.address.address;
            final message = String.fromCharCodes(datagram.data);

            // Only accept messages with the unique discovery token
            if (message.startsWith(discoveryToken)) {
              printMessage(
                  "Valid discovery message: '$message' from $senderAddress");
            } else {
              printMessage("Ignored message: '$message' from $senderAddress");
            }
          }
        }
      });

      // Broadcast this device's availability periodically
      Timer.periodic(const Duration(seconds: 5), (timer) {
        final message =
            "$discoveryToken: Device available - ${Platform.localHostname}";
        _socket?.send(
          message.codeUnits,
          InternetAddress("255.255.255.255"),
          broadcastPort,
        );
        printMessage("Broadcasting: $message");
      });
    } catch (e) {
      throw Exception("Failed to make device discoverable: $e");
    }
  }

  /// Stop broadcasting and listening
  void stopDiscovery() {
    _socket?.close();
    _socket = null;
    printMessage("Stopped listening and broadcasting.");
  }
}
