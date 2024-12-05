import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/device.dart';
import 'package:golf_accelerator_app/providers/device_collecting_status.dart';

class BluetoothModel {
  // Singleton instance
  static final BluetoothModel _instance = BluetoothModel._internal();

  // Factory constructor
  factory BluetoothModel() {
    return _instance;
  }

  // Private constructor
  BluetoothModel._internal();

  // Class properties
  List<ScanResult> scanResults = [];
  BluetoothDevice? myConnectedDevice;
  late List<BluetoothService> services;
  String customServiceUUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e";
  String customCharacteristicUUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e";
  String writeCharacteristicUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e";
  late BluetoothService customService;
  late BluetoothCharacteristic customCharacteristic;
  late BluetoothCharacteristic writeCustomCharacteristic;
  late StreamSubscription<List<int>> customCharacteristicSubscription;
  int packets = 0;

  // Initialize the singleton instance
  void initialize() {
    // Perform any necessary initialization here
  }

  // Methods
  Future<bool> connectDevice(BluetoothDevice device, DeviceCollectingStatus notifier) async {
    bool success = false;
    try {
      await device.connect();
      myConnectedDevice = device;

      var connectionSubscription = device.connectionState.listen((BluetoothConnectionState state) async {
        if (state == BluetoothConnectionState.disconnected) {
          print("Device Disconnected");
          print("Error disconnection description: ${device.disconnectReason}");
          notifier.stopReceivingData();
          myConnectedDevice = null;
        } else if (state == BluetoothConnectionState.connected) {
          success = true;
        }
      });

      device.cancelWhenDisconnected(connectionSubscription, delayed: true, next: true);
      await discoverServices(device);
      success = true;
    } catch (e) {
      success = false;
      print("Error Cannot Connect $e");
    }
    return success;
  }

  Future<bool> disconnectDevice() async {
    if (myConnectedDevice != null) {
      try {
        await myConnectedDevice!.disconnect();
        return true;
      } catch (e) {
        print("Couldn't disconnect $e");
      }
    }
    return false;
  }

  Future<void> discoverServices(BluetoothDevice connectedDevice) async {
    services = await connectedDevice.discoverServices();

    for (BluetoothService service in services) {
      if (service.uuid.toString() == customServiceUUID) {
        customService = service;
      }
    }

    var customServiceCharacteristics = customService.characteristics;
    for (BluetoothCharacteristic characteristic in customServiceCharacteristics) {
      if (characteristic.uuid.toString() == customCharacteristicUUID) {
        customCharacteristic = characteristic;
      }

      if (characteristic.uuid.toString() == writeCharacteristicUUID) {
        writeCustomCharacteristic = characteristic;
      }
    }
  }

  void setupListeners(BluetoothDevice device, WidgetRef ref) async {
    print("Device subscription Started");
    customCharacteristicSubscription = customCharacteristic.onValueReceived.listen((value) {
      print("Characteristic received from device: $value");
      String data = bytes2Str(value);
      final deviceNotifier = ref.read(golfDeviceProvider.notifier);
      deviceNotifier.handleSwingData(data);
    });

    device.cancelWhenDisconnected(customCharacteristicSubscription);

    await customCharacteristic.setNotifyValue(true);
  }

  void cancelNotificationsSubscription() {
    try {
      print("Device subscription canceled");
      customCharacteristicSubscription.cancel();
    } catch (e) {
      print("Can't cancel notifications subscriptions $e");
    }
  }

  Future<bool> writeToDevice(List<int> values) async {
    try {
      await writeCustomCharacteristic.write(values);
      return true;
    } catch (e) {
      print("Writing to device error: $e");
    }
    return false;
  }

  String bytes2Str(List<int> arr) {
    var str = '';
    for (var byte in arr) {
      var tmp = byte.toRadixString(16);
      if (tmp.length == 1) {
        tmp = '0$tmp';
      }
      str += tmp;
    }
    return str;
  }

  List<int> stringToHexList(String input) {
    List<int> hexList = [];
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      final hexValue = char.codeUnitAt(0);
      hexList.add(hexValue);
    }
    return hexList;
  }

  int combinedHex(int highByte, lowByte) {
    return (highByte << 8) | lowByte;
  }

  int toSignedInt8(int byte) {
    return byte < 128 ? byte : byte - 256;
  }

  double getDecimalCombined(int highByte, int lowByte) {
    int combined = (highByte << 8) | lowByte;
    combined = combined.toSigned(16);
    return combined / 100;
  }

  int combineValues(int highByte, int lowByte) {
    int combined = (highByte << 8) | lowByte;
    combined = combined.toSigned(16);
    return (combined * 0.049).round();
  }
}