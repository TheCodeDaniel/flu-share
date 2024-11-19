import 'dart:developer';
import 'dart:io';
import 'package:flushare/src/core/constants/bool_modes.dart';
import 'package:flutter/services.dart';

class WifiHandler {
  static const MethodChannel platform = MethodChannel('com.flushare/wifi');

  int? dynamicPort; // Store the dynamically allocated port
  String? localIpAddress; // Store the local IP address for broadcasting

  /// Starts a server with a dynamically allocated port
  Future<void> startServer() async {
    try {
      final server =
          await ServerSocket.bind(InternetAddress.anyIPv4, 0); // Dynamic port
      dynamicPort = server.port; // Save the allocated port
      localIpAddress = server.address.address; // Save the local IP

      log("Server started on ${server.address.address}:${server.port}");

      await for (Socket socket in server) {
        log('New connection from ${socket.remoteAddress.address}:${socket.remotePort}');
        socket.listen((data) {
          log('Received data: ${String.fromCharCodes(data)}');
          // Handle received data here
        }, onError: (error) {
          log("Connection error: $error");
        }, onDone: () {
          log("Client disconnected");
        });
      }
    } catch (e) {
      log("Failed to start server: $e");
    }
  }

  /// Broadcasts the server's IP and port to the network
  Future<void> broadcastDynamicPort() async {
    if (dynamicPort == null || localIpAddress == null) {
      log("No server port or IP available. Start the server first.");
      return;
    }

    try {
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);
      final broadcastAddress = InternetAddress('255.255.255.255');
      final message = "${localIpAddress ?? ''}:${dynamicPort ?? 0}";

      socket.send(message.codeUnits, broadcastAddress, 12345); // Discovery port
      log("Broadcasted: $message");
      socket.close();
    } catch (e) {
      log("Failed to broadcast: $e");
    }
  }

  /// Listens for broadcast messages from other devices
  Future<void> listenForBroadcasts() async {
    try {
      final socket =
          await RawDatagramSocket.bind(InternetAddress.anyIPv4, 12345);
      log("Listening for broadcasts on port 12345");

      socket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null) {
            final senderAddress = datagram.address.address;
            final message = String.fromCharCodes(datagram.data);
            log("Received broadcast from $senderAddress: $message");

            // Parse the message for IP and port
            final parts = message.split(':');
            if (parts.length == 2) {
              final ip = parts[0];
              final port = int.tryParse(parts[1]);
              if (port != null) {
                log("Discovered device at $ip:$port");
              }
            }
          }
        }
      });
    } catch (e) {
      log("Failed to listen for broadcasts: $e");
    }
  }

  /// Sends data to a specific IP and port
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

  /// Scans the network for devices using broadcasts
  Future<void> scanForDevices() async {
    try {
      final address = InternetAddress('255.255.255.255');
      final port = 12345; // Port for discovery messages

      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

      // Send a broadcast message
      socket.send('Discovery Request'.codeUnits, address, port);
      log('Sent discovery request to $address:$port');

      // Listen for responses from devices
      socket.listen((RawSocketEvent event) {
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

  /// Initiates Wi-Fi Direct for peer-to-peer communication (platform-specific)
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

  /// Connects to a peer device
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
}
