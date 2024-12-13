import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

part 'bluetooth.freezed.dart';

@freezed
class Bluetooth with _$Bluetooth {
  const factory Bluetooth({
    @Default("6e400001-b5a3-f393-e0a9-e50e24dcca9e") String customServiceUUID,
    @Default("6e400003-b5a3-f393-e0a9-e50e24dcca9e") String customCharacteristicUUID,
    @Default("6e400002-b5a3-f393-e0a9-e50e24dcca9e") String writeCharacteristicUUID,
    BluetoothDevice? connectedDevice,
    @Default([]) List<BluetoothService> services,
    BluetoothService? customService,
    BluetoothCharacteristic? customCharacteristic,
    BluetoothCharacteristic? writeCustomCharacteristic,
    StreamSubscription<List<int>>? customCharacteristicSubscription
  }) = _Bluetooth;
}