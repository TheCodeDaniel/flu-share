import 'dart:developer';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleHandler {
  final int scanDuration = 60;

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  void startScan() {
    FlutterBluePlus.startScan(
      timeout: Duration(seconds: scanDuration),
    );
  }

  // discover services of BLE device
  Future<List<BluetoothService>> discoverServices(
    BluetoothDevice device,
  ) async {
    List<BluetoothService> services = await device.discoverServices();
    return services;
  }

  // connect to a BLE device
  Future<void> connectDevice(BluetoothDevice device) async {
    try {
      if (device.isDisconnected) {
        await device.connect(
          timeout: const Duration(days: 1),
        );
      }
    } catch (e) {
      log("$e");
    }
  }

  // find characteristics of BLE device
  Future<BluetoothCharacteristic?> findCharacteristic(
    BluetoothService service,
    Guid characteristicUuid,
  ) async {
    BluetoothCharacteristic? characteristic =
        service.characteristics.firstWhere(
      (char) => char.uuid == characteristicUuid,
    );
    return characteristic;
  }

  // read and fetch the characteristics of connected BLE device
  Future<List<int>> readCharacteristic(
    BluetoothCharacteristic characteristic,
  ) async {
    List<int> value = await characteristic.read();
    return value;
  }

  // write to the connected BLE device
  Future<void> writeToCharacteristic(
    BluetoothCharacteristic characteristic,
    List<int> value,
  ) async {
    await characteristic.write(value);
  }

  // subscribe to a stream of notifications from a characteristic based on connected BLE device
  Stream<List<int>> subscribeToCharacteristic(
    BluetoothCharacteristic characteristic,
  ) {
    return characteristic.lastValueStream;
  }

  // un-subscribe from notification from a specific characteristic
  void unsubscribeFromCharacteristic(
    BluetoothCharacteristic characteristic,
  ) async {
    await characteristic.setNotifyValue(false);
  }
}
