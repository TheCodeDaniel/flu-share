import 'dart:io';
import 'dart:typed_data';
import 'package:flushare/src/config/global.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ping_discover_network_forked/ping_discover_network_forked.dart';
import 'file_transfer_event.dart';
import 'file_transfer_state.dart';
import 'package:network_info_plus/network_info_plus.dart';

class FileTransferBloc extends Bloc<FileTransferEvent, FileTransferState> {
  FileTransferBloc() : super(FileTransferInitial()) {
    // Register the event handler
    on<DiscoverDevices>(_onDiscoverDevices);
  }

  // request network permission
  Future<bool> requestLocationPermission() async {
    if (Platform.isMacOS) {
      return true; // Assuming permission is not required for macOS
    }

    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      return true; // Permission granted
    } else {
      return false; // Permission denied
    }
  }

  // Event handler for discovering devices
  Future<void> _onDiscoverDevices(
    DiscoverDevices event,
    Emitter<FileTransferState> emit,
  ) async {
    emit(DeviceDiscoveryLoading());

    // Request permission first
    bool permissionGranted = await requestLocationPermission();

    if (!permissionGranted) {
      emit(DeviceDiscoveryFailure(
        "Location permission is required to scan for devices.",
      ));
      return;
    }
    try {
      final info = NetworkInfo();
      final ip = await info.getWifiIP();
      final subnet = ip?.substring(0, ip.lastIndexOf('.'));

      if (subnet == null) {
        emit(DeviceDiscoveryFailure("Could not retrieve subnet."));
        return;
      }

      final List<String> devices = [];
      final stream = NetworkAnalyzer.discover2(subnet, 8000);

      await for (final NetworkAddress addr in stream) {
        if (addr.exists) {
          devices.add(addr.ip);
        }
      }

      // Send multicast message to discover devices on the network
      await sendMulticastMessage();

      emit(DeviceDiscoverySuccess(devices));
    } catch (e) {
      emit(DeviceDiscoveryFailure(e.toString()));
    }
  }

  // Function to send a multicast message with a unique app identifier
  Future<void> sendMulticastMessage() async {
    try {
      // Set up the socket for multicast
      final socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

      // Multicast group address (you can choose any address between 224.0.0.0 and 239.255.255.255)
      final multicastAddress = InternetAddress(
          '224.0.0.1'); // Change to your desired multicast address
      final tokenPrefix = 'flushare-App-Discovery-Token:'; // Your unique prefix
      final uniqueToken =
          '$tokenPrefix${DateTime.now().millisecondsSinceEpoch}'; // Unique token

      // Send message to the multicast address
      socket.send(
          Uint8List.fromList(uniqueToken.codeUnits), multicastAddress, 8080);

      // Listen for responses (this part depends on your devices that should be listening to the multicast address)
      socket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          final datagram = socket.receive();
          if (datagram != null) {
            // Filter responses based on the app-specific token
            final receivedMessage = String.fromCharCodes(datagram.data);
            if (receivedMessage.contains('flushare-App-Discovery-Response')) {
              printMessage(
                'Received response from ${datagram.address.address}',
              );
            }
          }
        }
      });

      // Keep the socket open for a while to receive responses
      await Future.delayed(Duration(seconds: 5));
      socket.close();
    } catch (e) {
      printMessage('Error: $e');
    }
  }
}
