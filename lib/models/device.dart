import 'dart:math';

import 'package:flutter/material.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/providers/device_collecting_status.dart';
import 'package:golf_accelerator_app/providers/swings.dart';
import 'package:golf_accelerator_app/screens/results/results.dart';
import 'package:golf_accelerator_app/screens/swing_result/swing_result.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import 'package:golf_accelerator_app/utils/utility_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../main.dart';
import '../screens/swing/swing.dart';
part 'device.g.dart';

@Riverpod(keepAlive: true)
class GolfDevice extends _$GolfDevice {

  // Attributes
  late Account _account;
  final db = FirestoreService();
  List<double> tempSwingDataPoints = []; // Used to hold the data swing points only temporarily
  int tempSpeed = 0; // Used to hold the speed only temporarily
  String tempTimeStamp = ""; // We can probably remove the timestamp all together since our database will handle that
  final String endOfPacketHeader = "a545";
  final String startOfPacketHeader = "a553";
  final String mphPacketHeader = "a573";
  final String swingPointsHeader = "a572";

  @override
  GolfDevice build() {
    //_initialize(); // Can add an initialize method if needed.
    // This allows us to get data from the account class
    _account = ref.watch(accountProvider);
    return this;
  }
  // handleCalibration(receivedData)
  // handleBattery(receivedData)
  // handleWeight(receivedData)
  // handlePowerMode(receivedData)

  /// This function is is the entry point to what we should do with data received from device
  /// If the header doesn't match any in the attributes we will just ignore it.
  /// Based on the header we will direct it to different functions
  /// Basically when a swing occurs a few things happen
  /// 1. We receive a start of packet header which clears the previous data
  ///   if any was store in our temp variables and shows a sets a loader variable to true to show a loading screen
  /// 2. We will get a stream of data which are the data points of the swing. This helps us see the path of the club during swing
  ///   We store these points until as long as we have that swingPointsHeader showing
  /// 3. When the swing is done we grab the highest z g-force that was collected and assume that was the peak of their swing.
  ///   We then calculate the speed based on the g-force
  /// 4. We receive the end of packet header meaning we shouldn't be collecting data anymore and we save that swing and send it to our database.
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

    // This tells our Swing Screen UI to show a loading screen
    ref.read(deviceCollectingStatusProvider.notifier).startReceivingData();

    tempSwingDataPoints.clear();
    tempTimeStamp = "";
  }

  // Handles the end of a packet and stores the swing data
  Future<void> handleEndOfPacket() async {
    print("End of Packet");
    SwingData swing = SwingData(speed: tempSpeed, swingPoints: tempSwingDataPoints);
    await db.addSwing(swing);

    // This tells our UI to hide the loading screen
    ref.read(deviceCollectingStatusProvider.notifier).stopReceivingData();

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => SwingResultScreen(quickView: true, swing: swing,), // Replace with your SwingScreen widget
      ),
    );
    print("Data points: $tempSwingDataPoints");
    ref.read(swingsNotifierProvider.notifier).addSwing(swing);
  }

  // Handles swing points data
  void handleSwingPoints(String data) {
    print(data);
    print("Getting swing z data points");
    for (int i = 18; i < data.length; i += 4) {
      String hexSegment = data.substring(i, i + 4);
      print(hexSegment);

      int zCombinedValue = hexToString(hexSegment);
      print("z combined value: $zCombinedValue");

      double zGForce = zCombinedValue / 100;
      tempSwingDataPoints.add(zGForce);
    }
  }

  // Handles MPH packet and sets speed and timestamp
  /// This calculates mph from g-force
  void handleMphPacket(String data) {
    print("Getting MPH");

    String ts = data.substring(4, 16);
    String len = data.substring(16, 18);
    int combinedValue = hexToString(data.substring(18, 22));
    double gForce = combinedValue / 100.0;

    int totalHeightInches = (_account.heightFt! * 12) + _account.heightIn!;
    double radiusInMeters = 0.025 * ((totalHeightInches / 2.0) + 35.5);

    double angularVelocity = sqrt(9.81 * gForce / radiusInMeters);
    double linearVelocity = angularVelocity * radiusInMeters;

    double mph = (linearVelocity * 2.23694).roundToDouble();
    print("ts = $ts, len = $len, combinedValue = $mph");

    tempSpeed = mph.toInt();
    tempTimeStamp = ts;
  }




}