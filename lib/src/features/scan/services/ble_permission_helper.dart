import 'dart:io';

import 'package:flushare/src/core/utils/navigation_extension.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flushare/src/core/network/ble_handler.dart';

class BlePermissionHelper {
  BleHandler ble = BleHandler();

  Future<void> checkBluetoothAndPermissions(BuildContext context) async {
    var bluetoothState = await FlutterBluePlus.adapterState.first;
    if (bluetoothState != BluetoothAdapterState.on) {
      return;
    }

    if (context.mounted) await requestPermissionsAndStartScan(context);
  }

  Future<void> requestPermissionsAndStartScan(BuildContext context) async {
    bool permissionsGranted = true;

    if (!Platform.isMacOS && !Platform.isLinux) {
      final bluetoothStatus = await Permission.bluetooth.status;
      if (bluetoothStatus.isGranted == false) {
        final bluetoothPermission = await Permission.bluetooth.request();
        if (!bluetoothPermission.isGranted) {
          permissionsGranted = false;
          debugPrint("Bluetooth permission denied");
        }
      }
    }

    if (Platform.isAndroid) {
      final bluetoothScanStatus = await Permission.bluetoothScan.status;
      if (bluetoothScanStatus.isGranted == false) {
        final bluetoothScanPermission =
            await Permission.bluetoothScan.request();
        if (!bluetoothScanPermission.isGranted) {
          permissionsGranted = false;
          debugPrint("Bluetooth scan permission denied");
        }
      }
    }

    if (Platform.isAndroid) {
      final bluetoothConnectStatus = await Permission.bluetoothConnect.status;
      if (bluetoothConnectStatus.isGranted == false) {
        final bluetoothConnectPermission =
            await Permission.bluetoothConnect.request();
        if (!bluetoothConnectPermission.isGranted) {
          permissionsGranted = false;
          debugPrint("Bluetooth connect permission denied");
        }
      }
    }

    if (!Platform.isMacOS && !Platform.isLinux) {
      final locationStatus = await Permission.locationWhenInUse.status;
      if (locationStatus.isGranted == false) {
        final locationPermission = await Permission.locationWhenInUse.request();
        if (!locationPermission.isGranted) {
          permissionsGranted = false;
          debugPrint("Location permission denied");
        }
      }
    }

    if (permissionsGranted) {
      debugPrint("All permissions granted, starting scan");
      ble.startScan();
    } else {
      debugPrint("Not all permissions were granted");
      if(context.mounted) showPermissionDeniedDialog(context);
    }
  }

  void showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Permissions Required"),
        content: const Text(
          "The app requires certain permissions to function. Please grant the necessary permissions in the app settings.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
              openAppSettings();
            },
            child: const Text("Open Settings"),
          ),
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}
