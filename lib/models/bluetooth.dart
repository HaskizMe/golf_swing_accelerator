import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:golf_accelerator_app/models/device.dart';
import 'package:golf_accelerator_app/providers/device_collecting_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'bluetooth.g.dart';


@Riverpod(keepAlive: true)
class Bluetooth extends _$Bluetooth{
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

  @override
  Bluetooth build() {
    _initialize();
    return this;
  }

  // Methods
  void _initialize() async {

  }


  Future<bool> connectDevice(BluetoothDevice device) async {
    print("Here");
    bool success = false;
    try {
      await device.connect();
      print("after connection");
      myConnectedDevice = device;
      var connectionSubscription = device.connectionState.listen((BluetoothConnectionState state) async {
        if (state == BluetoothConnectionState.disconnected) {
          print("Device Disconnected");
          print("Error disconnection description: ${device.disconnectReason}");
          ref.read(deviceCollectingStatusProvider.notifier).stopReceivingData(); // Turns off loader if device gets disconnected by accident
          myConnectedDevice = null;
        } else if (state == BluetoothConnectionState.connected) {
          success = true;
        }

      });
      device.cancelWhenDisconnected(connectionSubscription, delayed: true, next: true);
      await discoverServices(device);
      success = true;
      // setupListeners(device);
    } catch (e) {
      success = false;
      print("Error Cannot Connect $e");
    }

    return success;
  }

  Future<bool> disconnectDevice() async {
    if(myConnectedDevice != null){
      try{
        await myConnectedDevice!.disconnect();
        return true;
      } catch(e){
        print("Couldn't disconnect $e");
      }
    }
    return false;
  }

  Future<void> discoverServices(BluetoothDevice connectedDevice) async {
    services = await connectedDevice.discoverServices();

    print("after actually discovering services");

    // Reads all services and finds the custom service uuid
    for (BluetoothService service in services) {
      //print("Services: ${service.uuid.toString()}");
      //print("Services: $service");
      if(service.uuid.toString() == customServiceUUID){
        print("Custom service found");
        customService = service;
      }

    }
    // Reads all characteristics
    var customServiceCharacteristics = customService.characteristics;
    // var batteryServiceCharacteristics = batteryService.characteristics;
    for(BluetoothCharacteristic characteristic in customServiceCharacteristics) {
      //print(characteristic);
      if(characteristic.uuid.toString() == customCharacteristicUUID){
        print("Custom characteristic found");
        customCharacteristic = characteristic;
      }

      if(characteristic.uuid.toString() == writeCharacteristicUUID){
        print("write characteristic found");
        writeCustomCharacteristic = characteristic;
      }
    }

  }

  String bytes2Str(List<int> arr) {
    var str = '';
    for (var byte in arr) {
      var tmp = byte.toRadixString(16); // Convert byte to hex
      if (tmp.length == 1) {
        tmp = '0$tmp'; // Pad with '0' if necessary
      }
      str += tmp;
    }
    return str;
  }


  setupListeners(BluetoothDevice device) async {

    // This sends a command to the device to enable notifications. So that the below code can read value changes
    customCharacteristicSubscription = customCharacteristic.onValueReceived.listen((value) {
      /// This listens to any changes that is received from the golf trainer device.
      /// When we receive data we will do something with it.
      print("Characteristic received from device: $value");
      String data = bytes2Str(value); // Translates data into a string of hex values
      final device = ref.read(golfDeviceProvider.notifier);

      // Pass all the data received from device here to handle it
      device.handleSwingData(data);
    });

    // cleanup: cancel subscription when disconnected
    device.cancelWhenDisconnected(customCharacteristicSubscription);


    // This enables notifications
    // Note: If a characteristic supports both **notifications** and **indications**,
    // it will default to **notifications**. This matches how CoreBluetooth works on iOS.
    await customCharacteristic.setNotifyValue(true); // This needs to go before writing to the characteristic

  }

  void cancelNotificationsSubscription() {
    try{
      customCharacteristicSubscription.cancel();
    } catch(e){
      print("Can't cancel notifications subscriptions $e");
    }
  }
  
  Future<bool> writeToDevice(List<int> values) async {
    try{
      await writeCustomCharacteristic.write(values);
      return true;
    } catch(e){
      print("Writing to device error: $e");
    }
    return false;
  }


//   export const powerMode=(deviceID,pmode)=>{
//   var bytes=[];
//   console.log("here1")
//
//   if(pmode)
//   bytes=[0xa5,0x50,0x01];
//   else
//   bytes=[0xa5,0x50,0x00];
//   return writeToBle(deviceID,bytes)
// }
  List<int> stringToHexList(String input) {
    List<int> hexList = [];

    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      final hexValue = char.codeUnitAt(0);
      hexList.add(hexValue);
    }

    return hexList;
  }

  int combinedHex(int highByte, lowByte){
    return (highByte << 8) | lowByte;
  }

  int toSignedInt8(int byte) {
    return byte < 128 ? byte : byte - 256;
  }

  double getDecimalCombined(int highByte, int lowByte){
    int combined = (highByte << 8) | lowByte;
    combined = combined.toSigned(16);
    double decimal = combined / 100;
    return decimal;
  }
  int combineValues(int highByte, int lowByte){
    print("high byte: $highByte Low Byte: $lowByte");
    int combined = (highByte << 8) | lowByte;
    combined = combined.toSigned(16);
    combined = (combined * .049).round();
    print("Combined $combined");

    return combined;
  }
}


