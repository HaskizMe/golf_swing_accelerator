import 'dart:math';

import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/providers/swings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'device.g.dart';

@Riverpod(keepAlive: true)
class GolfDevice extends _$GolfDevice {
  late Account _account;
  List<double> last20Packets = [];
  List<SwingData> last10Swings = [];
  List<double> tempSwingDataPoints = [];
  int tempSpeed = 0;
  String tempTimeStamp = "";
  final String endOfPacketHeader = "a545";
  final String startOfPacketHeader = "a553";
  final String mphPacketHeader = "a573";
  final String swingPointsHeader = "a572";

  @override
  GolfDevice build() {
    //_initialize();
    _account = ref.watch(accountProvider);
    return this;
  }
  // handleCalibration(receivedData)
  // handleBattery(receivedData)
  // handleWeight(receivedData)
  // handlePowerMode(receivedData)

  void handleSwingData(String data) {
    String packetHeader = data.substring(0, 4);

    // Validate header type and return if it's unrecognized
    if (packetHeader != startOfPacketHeader &&
        packetHeader != mphPacketHeader && packetHeader != endOfPacketHeader &&
        packetHeader != swingPointsHeader) {
      return;
    }

    // Use if-else to handle each header case
    if (packetHeader == startOfPacketHeader) {
      handleStartOfPacket();
    } else if (packetHeader == endOfPacketHeader) {
      handleEndOfPacket();
    } else if (packetHeader == swingPointsHeader) {
      handleSwingPoints(data);
    } else if (packetHeader == mphPacketHeader) {
      handleMphPacket(data);
    }
  }

  // Handles the start of a packet
  void handleStartOfPacket() {
    print("Start of Packet");
    tempSwingDataPoints.clear();
    tempTimeStamp = "";
  }

  // Handles the end of a packet and stores the swing data
  void handleEndOfPacket() {
    print("End of Packet");
    SwingData swing = SwingData(speed: tempSpeed, swingPoints: tempSwingDataPoints, timeStamp: tempTimeStamp,);
    print("Data points: $tempSwingDataPoints");
    ref.read(swingsNotifierProvider.notifier).addSwing(swing);
    last10Swings.add(swing);
  }

  // Handles swing points data
  void handleSwingPoints(String data) {
    print("Getting swing z data points");
    for (int i = 18; i < data.length; i += 4) {
      String segment = data.substring(i, i + 4);
      int zCombinedValue = int.parse(segment, radix: 16);
      double zGForce = zCombinedValue / 100;
      tempSwingDataPoints.add(zGForce);
    }
  }

  // Handles MPH packet and sets speed and timestamp
  void handleMphPacket(String data) {
    print("Getting MPH");

    String ts = data.substring(4, 16);
    String len = data.substring(16, 18);
    int combinedValue = int.parse(data.substring(18, 22), radix: 16);
    double gForce = combinedValue / 100.0;

    int totalHeightInches = (_account.heightFt * 12) + _account.heightIn;
    double radiusInMeters = 0.025 * ((totalHeightInches / 2.0) + 35.5);

    double angularVelocity = sqrt(9.81 * gForce / radiusInMeters);
    double linearVelocity = angularVelocity * radiusInMeters;

    double mph = (linearVelocity * 2.23694).roundToDouble();
    print("ts = $ts, len = $len, combinedValue = $mph");

    tempSpeed = mph.toInt();
    tempTimeStamp = ts;
  }
}