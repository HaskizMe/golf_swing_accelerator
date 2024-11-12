import 'dart:async';
import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:golf_accelerator_app/models/device.dart';
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
          //Get.to(() => const ConnectDevice(wasDisconnected: true,));
          print("Device Disconnected");
          print("Error disconnection description: ${device.disconnectReason}");
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
      /// This is where I will add the code to get the battery percentage. Right now
      /// this is only called when readFromDevice() is called anywhere in the program.
      /// I need to add a notifier function to the Firmware
      //print("Characteristic received: $value");
      String data = bytes2Str(value);
      //print(data);
      final device = ref.read(golfDeviceProvider.notifier);
      device.handleSwingData(data);
      //device.handleSwingDataPoints(data);
      //device.handleEndOfSwingData(data);
      // packets++;
      // print(packets);
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

  Future<void> writeToDevice(List<int> hexValues) async {
    await writeCustomCharacteristic.write(hexValues);
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


// import 'dart:async';
// import 'dart:collection';
// import 'dart:io';
// import 'package:get/get.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// //import 'package:pain_drain_mobile_app/controllers/stimulus.dart';
// import 'package:pain_drain_mobile_app/models/stimulus.dart';
// import 'package:pain_drain_mobile_app/screens/connect_device/connect_to_device.dart';
//
//
// class Bluetooth extends GetxController {
//   final Stimulus _stimulusController = Get.find();
//   Function? onDisconnectedCallback;
//   Function? onReconnectedCallback;
//   final Queue<List<int>> _queue = Queue<List<int>>();
//   String customServiceUUID = "3bf00c21-d291-4688-b8e9-5a379e3d9874";
//   String customCharacteristicUUID = "93c836a2-695a-42cc-95ac-1afa0eef6b0a";
//   // String batteryServiceUUID = "0000180f-0000-1000-8000-00805f9b34fb";
//   // String batteryCharacteristicUUID = "00002a19-0000-1000-8000-00805f9b34fb";
//   String batteryServiceUUID = "180f";
//   String batteryCharacteristicUUID = "2a19";
//   String characteristicConfigurationUUID = "2902";
//   //String batteryConfigurationUUID = "2902";
//   //late BluetoothCharacteristic customConfigurationCharacteristic;
//   late BluetoothDescriptor customConfigurationDescriptor;
//
//   late BluetoothService customService;
//   late BluetoothService batteryService;
//   late BluetoothCharacteristic customCharacteristic;
//   late BluetoothCharacteristic batteryCharacteristic;
//   BluetoothDevice? myConnectedDevice;
//   late List<BluetoothService> services;
//   final RxList<BluetoothDevice> connectedDevices = RxList<BluetoothDevice>();
//   final RxList<ScanResult> notConnectedDevices = RxList<ScanResult>();
//   List<ScanResult> scanResults = [];
//   var isCharging = false.obs;
//   var showChargingAnimation = false.obs;
//
//   Future<void> scanForDevices() async {
//     print("Scanning for devices");
//     var scanSubscription = FlutterBluePlus.onScanResults.listen((results) {
//       scanResults = results.toList(); // Store scan results in the list
//     },
//       onError: (e) => print(e),
//     );
//
//     FlutterBluePlus.cancelWhenScanComplete(scanSubscription);
//
//     await FlutterBluePlus.startScan(
//         withNames:["PainDrain"],
//         timeout: const Duration(seconds: 5)
//     );
//
//     // wait for scanning to stop
//     await FlutterBluePlus.isScanning.where((val) => val == false).first;
//
//     if(scanResults.isNotEmpty){
//       print("not empty");
//     }
//     else{
//       print("empty");
//     }
//   }
//
//   Future<bool> connectDevice(BluetoothDevice device) async {
//     print("Here");
//     bool success = false;
//     try {
//       myConnectedDevice = device;
//       await device.connect();
//       print("after connection");
//       var connectionSubscription = device.connectionState.listen((BluetoothConnectionState state) async {
//         if (state == BluetoothConnectionState.disconnected) {
//           Get.to(() => const ConnectDevice(wasDisconnected: true,));
//           print("Device Disconnected");
//           print("Error disconnection description: ${device.disconnectReason}");
//         } else if (state == BluetoothConnectionState.connected) {
//           success = true;
//         }
//
//       });
//       device.cancelWhenDisconnected(connectionSubscription, delayed: true, next: true);
//       print("before discovering services");
//       await discoverServices(device);
//       print("after discovering services");
//       success = true;
//       print("test");
//       setupListeners(device);
//     } catch (e) {
//       success = false;
//       print("Error Cannot Connect $e");
//     }
//
//     return success;
//   }
//
//   Future<bool> disconnectDevice() async {
//     if(myConnectedDevice != null){
//       try{
//         await myConnectedDevice!.disconnect();
//         return true;
//       } catch(e){
//         print("Couldn't disconnect $e");
//       }
//     }
//     return false;
//   }
//
//   Future<void> discoverServices(BluetoothDevice connectedDevice) async {
//     services = await connectedDevice.discoverServices();
//
//     print("after actually discovering services");
//
//     // Reads all services and finds the custom service uuid
//     for (BluetoothService service in services) {
//       //print("Services: ${service.uuid.toString()}");
//       //print("Services: $service");
//       if(service.uuid.toString() == customServiceUUID){
//         print("Custom service found");
//         customService = service;
//       } else if(service.uuid.toString() == batteryServiceUUID){
//         batteryService = service;
//       }
//
//     }
//     // Reads all characteristics
//     var customServiceCharacteristics = customService.characteristics;
//     // var batteryServiceCharacteristics = batteryService.characteristics;
//     for(BluetoothCharacteristic characteristic in customServiceCharacteristics) {
//       //print(characteristic);
//       if(characteristic.uuid.toString() == customCharacteristicUUID){
//         print("Custom characteristic found");
//         customCharacteristic = characteristic;
//         for(BluetoothDescriptor descriptor in customCharacteristic.descriptors){
//           if(descriptor.uuid.toString() == characteristicConfigurationUUID){
//             customConfigurationDescriptor = descriptor;
//           }
//         }
//       }
//     }
//     var batteryServiceCharacteristics = batteryService.characteristics;
//
//     for(BluetoothCharacteristic characteristic in batteryServiceCharacteristics) {
//       if(characteristic.uuid.toString() == batteryCharacteristicUUID){
//         print("Battery characteristic found: $characteristic");
//         batteryCharacteristic = characteristic;
//       }
//     }
//   }
//
//   @override
//   void onClose() {
//     // luna3.disconnect();
//     // painDrain.disconnect();
//     FlutterBluePlus.stopScan();
//     print("on close");
//     super.onClose();
//   }
//
//
//   Future writeToDevice(String stimulus, List<int> hexValues) async {
//     switch (stimulus){
//       case "tens":
//         await customCharacteristic.write(hexValues);
//         print("tens");
//         break;
//       case "temperature":
//         await customCharacteristic.write(hexValues);
//         print("temperature");
//         break;
//       case "vibration":
//         print('vibration $hexValues');
//         await customCharacteristic.write(hexValues);
//         print("vibration");
//         break;
//       case "register":
//         print('register $hexValues');
//         await customCharacteristic.write(hexValues);
//         print("register");
//         break;
//       case "notifications":
//         await customCharacteristic.write(hexValues);
//         break;
//       case "B":
//         await customCharacteristic.write(hexValues);
//       default:
//         print("error");
//         break;
//     }
//   }
//
//   Future<void> newWriteToDevice(String command) async {
//     try {
//       //String command = getCommand(stimulus);
//       List<int> hexValues = stringToHexList(command);
//       // Add the command to the queue
//       _queue.add(hexValues);
//       // Process each element in the queue until it's empty
//       while (_queue.isNotEmpty) {
//         print("Elements in queue: ${_queue.length}");
//         List<int> currentHexValues = _queue.removeFirst();
//
//         if(currentHexValues.length > 20){
//           print("Big data");
//           await customCharacteristic.write(currentHexValues, allowLongWrite: true);
//         } else {
//           print("not big data");
//           await customCharacteristic.write(currentHexValues);
//         }
//         // Remove the processed command from the queue
//       }
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   void devDebugPrint(String readString) {
//     if(readString[0] == "T") {
//       // if(readString[2] == "p"){
//       //   _stimulusController.readPhase = readString;
//       // } else {
//       //   _stimulusController.readTens = readString;
//       // }
//       _stimulusController.readTens = readString;
//     } else if(readString[0] == "v"){
//       _stimulusController.readVibe = readString;
//     } else if(readString[0] == "t") {
//       _stimulusController.readTemp = readString;
//     } else {
//       print("no value");
//     }
//   }
//
//   String getCommand(String stimulus){
//     String command = "";
//
//     // if(_stimulusController.getStimulus(_stimulusController.currentChannel).toInt() == 1){
//     //   channel = 1;
//     //   mode = _stimulusController.getStimulus(_stimulusController.tensModeChannel1).toInt();
//     //   playButton = _stimulusController.getStimulus(_stimulusController.tensPlayButtonChannel1).toInt();
//     // } else if(_stimulusController.getStimulus(_stimulusController.currentChannel).toInt() == 2) {
//     //   channel = 2;
//     //   mode = _stimulusController.getStimulus(_stimulusController.tensModeChannel2).toInt();
//     //   playButton = _stimulusController.getStimulus(_stimulusController.tensPlayButtonChannel2).toInt();
//     // } else{
//     //   print("ERROR!");
//     //   //return command;
//     // }
//
//
//     switch (stimulus){
//       case "tens":
//         String mode = "";
//         String playButton = "";
//         String channel = "";
//         //String phase = '';
//
//         if(_stimulusController.getStimulus(_stimulusController.currentChannel).toInt() == 1){
//           channel = "1";
//           mode = _stimulusController.getStimulus(_stimulusController.tensModeChannel1).toInt().toString();
//           playButton = _stimulusController.getStimulus(_stimulusController.tensPlayButtonChannel1).toInt().toString();
//         } else if(_stimulusController.getStimulus(_stimulusController.currentChannel).toInt() == 2) {
//           channel = "2";
//           mode = _stimulusController.getStimulus(_stimulusController.tensModeChannel2).toInt().toString();
//           playButton = _stimulusController.getStimulus(_stimulusController.tensPlayButtonChannel2).toInt().toString();
//         } else{
//           print("ERROR!");
//         }
//         print("tens");
//         command = "T "
//             "${_stimulusController.getStimulus(_stimulusController.tensIntensity).toInt()} "
//             "$mode "
//             "$playButton "
//             "$channel "
//             "${_stimulusController.getStimulus(_stimulusController.tensPhase).toInt().toString()}";
//
//
//         //"${_stimulusController.getStimulus(_stimulusController.tensMode).toInt()} ";
//         //"${_stimulusController.getStimulus(channel)} "
//         //"${_stimulusController.getStimulus(_stimulusController.tensPeriod).toInt()} "
//         //"${_stimulusController.getCurrentChannel()}";
//         print("Command: stimulus: T, "
//             "Intensity: ${_stimulusController.getStimulus(_stimulusController.tensIntensity).toInt()}, "
//             "Mode: $mode, "
//             "Play/pause: $playButton, "
//             "Channel: $channel, "
//             "Phase: ${_stimulusController.getStimulus(_stimulusController.tensPhase).toInt().toString()}");
//         break;
//     // case "phase":
//     //   command = "T p ${_stimulusController.getStimulus(_stimulusController.tensPhase).toInt()}";
//     //   print(command);
//
//     //  break;
//       case "temperature":
//         print("temperature");
//         command = "t "
//             "${_stimulusController.getStimulus(_stimulusController.temp).toInt()} ";
//
//         break;
//       case "vibration":
//         print("vibration");
//         //String shortenedWaveType = _stimulusController.getAbbreviation(_stimulusController.getCurrentWaveType());
//         command = "v "
//             "${_stimulusController.getStimulus(_stimulusController.vibeIntensity).toInt()} "
//             "${_stimulusController.getStimulus(_stimulusController.vibeFreq).toInt()} ";
//         //"${_stimulusController.getStimulus(_stimulusController.vibeWaveform).toInt()} ";
//         break;
//
//       default:
//         print("error: Stimulus doesn't exist. Use 'tens', 'vibration', 'phase', or 'temperature'");
//         break;
//     }
//     print(command);
//     print("sending");
//     return command;
//   }
//
//   Future<List<int>> readFromDevice() async {
//     try {
//       List<int> rspHexValues = await customCharacteristic.read();
//
//       // Remove elements after the null terminator ('\0')
//       if (rspHexValues.contains(0)) {
//         rspHexValues = rspHexValues.sublist(0, rspHexValues.indexOf(0));
//       }
//
//       return rspHexValues;
//     } catch (e) {
//       print('Error during readFromDevice: $e');
//       rethrow; // Rethrow the exception after logging or handle it appropriately
//     }
//   }
//   List<int> stringToHexList(String input) {
//     List<int> hexList = [];
//
//     for (int i = 0; i < input.length; i++) {
//       final char = input[i];
//       final hexValue = char.codeUnitAt(0);
//       hexList.add(hexValue);
//     }
//
//     return hexList;
//   }
//
//   String hexToString(List<int> list){
//     String asciiString = "";
//
//     for (int hexValue in list) {
//       // Convert each hex value to its corresponding ASCII character
//       asciiString += String.fromCharCode(hexValue);
//     }
//     return asciiString;
//   }
//
//   setupListeners(BluetoothDevice device) async {
//     // This sends a command to the device to enable notifications. So that the below code can read value changes
//     // await customConfigurationDescriptor.write([1]);
//     // print("subscribing to custom characteristic");
//
//
//     final customCharacteristicSubscription = customCharacteristic.onValueReceived.listen((value) {
//       /// This is where I will add the code to get the battery percentage. Right now
//       /// this is only called when readFromDevice() is called anywhere in the program.
//       /// I need to add a notifier function to the Firmware
//       print("Battery Characteristic received: $value");
//       print("Battery Characteristic received String: ${hexToString(value)}");
//       String read = hexToString(value);
//       devDebugPrint(read);
//       print("Read Values: $read");
//       print("Value received!!!!!!!!!!");
//
//       if(read == "charge"){
//         _stimulusController.disableAllStimuli();
//         //isCharging.value = true; // Update the state variable when the device is charging
//         //showChargingAnimation.value = true;
//         //Future.delayed(const Duration(seconds: 5), () => showChargingAnimation.value = false);
//       } else if(read == "no charge" || read == "normal") {
//         isCharging.value = false; // Update the state variable when the device is not charging
//       }
//     });
//
//     // cleanup: cancel subscription when disconnected
//     device.cancelWhenDisconnected(customCharacteristicSubscription);
//
//
//     // This enables notifications
//     // Note: If a characteristic supports both **notifications** and **indications**,
//     // it will default to **notifications**. This matches how CoreBluetooth works on iOS.
//     await customCharacteristic.setNotifyValue(true); // This needs to go before writing to the characteristic
//
//     // This sends a command to the device to enable notifications.
//     await customConfigurationDescriptor.write([1]);
//   }
//
// // void sendDisableCommand(){
// //   String command = getCommand("tens");
// //   newWriteToDevice(command);
// //   command = getCommand("phase");
// //   newWriteToDevice(command);
// //   command = getCommand("temperature");
// //   newWriteToDevice(command);
// //   command = getCommand("vibration");
// //   newWriteToDevice(command);
// // }
//
//
//
// }







// Future<void> discoverServices(BluetoothDevice connectedDevice) async {
//   services = await connectedDevice.discoverServices();
//
//   // Reads all services and finds the custom service uuid
//   for (BluetoothService service in services) {
//     //print("Services: ${service.uuid.toString()}");
//     if(service.uuid.toString() == customServiceUUID){
//       print("Custom service found");
//       customService = service;
//     }
//   }
//   // Reads all characteristics
//   var customServiceCharacteristics = customService.characteristics;
//   // var batteryServiceCharacteristics = batteryService.characteristics;
//   for(BluetoothCharacteristic characteristic in customServiceCharacteristics) {
//     //print("Characteristics $characteristic");
//     if(characteristic.uuid.toString() == customCharacteristicUUID){
//       print("Custom characteristic found");
//       print(characteristic);
//       customCharacteristic = characteristic;
//     } if(characteristic.uuid.toString() == writeCharacteristicUUID){
//       print("Write Custom service found");
//       writeCustomCharacteristic = characteristic;
//     }
//   }
//   final subscription = customCharacteristic.onValueReceived.listen((value) async {
//     print("VALUE RECEIVED!!!!");
//
//     // Check if the value has enough elements
//     if (value.length > 11) {
//       print("Length: ${value.length}");
//       // Modify according to the expected indices
//       // int xValue = toSignedInt8(value[8]);
//       // int yValue = toSignedInt8(value[9]);
//       // int zValue = toSignedInt8(value[10]);
//       int xValue = combineValues(value[0], value[1]);
//       int yValue = combineValues(value[2], value[3]);
//       int zValue = combineValues(value[4], value[5]);
//
//       await writeToExcel(xValue.toDouble(), yValue.toDouble(), zValue.toDouble());
//
//       print("x value: $xValue");
//       print("y value: $yValue");
//       print("z value: $zValue");
//       print("raw x high value: ${value[6]}");
//       print("raw x low value: ${value[7]}");
//       print("raw y high value: ${value[8]}");
//       print("raw y low value: ${value[9]}");
//       print("raw z high value: ${value[10]}");
//       print("raw z low value: ${value[11]}");
//       //print("reg 0x31: ${value[20]}");
//       //print("reg 0x00: ${value[21]}");
//       data.add(DataRow(cells: [
//         DataCell(Text(xValue.toString())),
//         DataCell(Text(yValue.toString())),
//         DataCell(Text(zValue.toString())),
//       ]));
//     } else if(value.length < 4) {
//       if(value[0] == 0x1){
//         //stopMeasuring.value = false;
//         startMeasuring.value = true;
//         double z1 = getDecimalCombined(value[1], value[2]);
//         await writeToExcel(0, 0, z1);
//
//         data.add(DataRow(cells: [
//           DataCell(Text(0.toString())),
//           DataCell(Text(0.toString())),
//           DataCell(Text(z1.toString())),
//         ]));
//         //print("Value: $value");
//         print("[1] $z1");
//       } else if(value[0] == 0x2){
//         startMeasuring.value = false;
//         double zGForce = getDecimalCombined(value[1], value[2]);
//         double radiusInMeters = 1.8288;
//         double angularVelocity = sqrt(9.81 * zGForce / radiusInMeters);
//         double linearVelocity = angularVelocity * radiusInMeters;
//         //double meters = 6 * 0.3048;
//         double mph = linearVelocity * 2.23694;
//         print("Max Speed w/ Radius of 6ft: ${mph}");
//         print("g-force: $zGForce");
//         maxG.value = zGForce;
//         speed.value = mph.roundToDouble();
//         //await writeToExcel(0, 0, 0, zMaxValue);
//         //stopMeasuring.value = true;
//       }
//
//     } else if(value.length == 1 && value[0] == 3){
//       print("SHOCK DETECTED");
//     }
//     else{
//       print("Value: $value");
//     }
//   });
//
//   // cleanup: cancel subscription when disconnected
//   //connectedDevice.cancelWhenDisconnected(subscription, delayed: true, next: true);
//   connectedDevice.cancelWhenDisconnected(subscription);
//   await customCharacteristic.setNotifyValue(true);
// }


