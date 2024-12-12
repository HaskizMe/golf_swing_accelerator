import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/bluetooth.dart';
import 'package:golf_accelerator_app/providers/device_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/device.dart';
import 'device_collecting_status.dart';

part 'bluetooth_provider.g.dart';

@Riverpod(keepAlive: true)
class BluetoothNotifier extends _$BluetoothNotifier {


  @override
  Bluetooth build() {
    return const Bluetooth(); // Initial state: No account data loaded
  }

  /// --------------------------------------------------------------------------
  /// Getters and Setters
  /// --------------------------------------------------------------------------
  BluetoothDevice? get connectedDevice => state.connectedDevice;
  void setConnectedDevice(BluetoothDevice? device) => state = state.copyWith(connectedDevice: device);


  // Methods
  Future<bool> connectDevice(BluetoothDevice device, DeviceCollectingStatus notifier) async {
    bool success = false;
    try {
      await device.connect();
      setConnectedDevice(device);
      //myConnectedDevice = device;


      print("Device ${connectedDevice?.advName}");
      var connectionSubscription = device.connectionState.listen((BluetoothConnectionState state) async {
        if (state == BluetoothConnectionState.disconnected) {
          print("Device Disconnected");
          print("Error disconnection description: ${device.disconnectReason}");
          notifier.stopReceivingData();
          setConnectedDevice(null);
          //myConnectedDevice = null;
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
    if (connectedDevice != null) {
      try {
        await connectedDevice!.disconnect();
        return true;
      } catch (e) {
        print("Couldn't disconnect $e");
      }
    }
    return false;
  }

  Future<void> discoverServices(BluetoothDevice connectedDevice) async {
    state = state.copyWith(services: await connectedDevice.discoverServices());
    //services = await connectedDevice.discoverServices();

    for (BluetoothService service in state.services) {
      if (service.uuid.toString() == state.customServiceUUID) {
        state = state.copyWith(customService: service);
        //customService = service;
      }
    }

    var customServiceCharacteristics = state.customService?.characteristics;
    for (BluetoothCharacteristic characteristic in customServiceCharacteristics!) {
      if (characteristic.uuid.toString() == state.customCharacteristicUUID) {
        state = state.copyWith(customCharacteristic: characteristic);
        //customCharacteristic = characteristic;
      }

      if (characteristic.uuid.toString() == state.writeCharacteristicUUID) {
        state = state.copyWith(writeCustomCharacteristic: characteristic);
        //writeCustomCharacteristic = characteristic;
      }
    }
  }

  void setupListeners(BluetoothDevice device, BuildContext context) async {
    print("Device subscription Started");

    // Create a subscription and update the state using copyWith
    final subscription = state.customCharacteristic!.onValueReceived.listen((value) {
      print("Characteristic received from device: $value");
      String data = bytes2Str(value);

      // Use the notifier to handle the received data
      final deviceNotifier = ref.read(golfDeviceNotifierProvider.notifier);
      deviceNotifier.handleSwingData(data, context);
    });

    // Update the state with the new subscription
    state = state.copyWith(customCharacteristicSubscription: subscription);

    // Ensure the subscription is canceled when the device disconnects
    device.cancelWhenDisconnected(subscription);

    // Enable notifications for the custom characteristic
    await state.customCharacteristic!.setNotifyValue(true);
  }

  void cancelNotificationsSubscription() {
    try {
      print("Device subscription canceled");
      state.customCharacteristicSubscription!.cancel();
    } catch (e) {
      print("Can't cancel notifications subscriptions $e");
    }
  }

  Future<bool> writeToDevice(List<int> values) async {
    try {
      await state.writeCustomCharacteristic!.write(values);
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