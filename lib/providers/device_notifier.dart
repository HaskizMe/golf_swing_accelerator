import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:golf_accelerator_app/providers/account_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../main.dart';
import '../models/account.dart';
import '../models/device.dart';
import '../models/device.dart';
import '../models/swing_data.dart';
import '../screens/swing_result/swing_result.dart';
import '../services/firestore_service.dart';
import '../utils/utility_functions.dart';

part 'device_notifier.g.dart';

@Riverpod(keepAlive: true)
class GolfDeviceNotifier extends _$GolfDeviceNotifier {

  late Account _account;

  @override
  GolfDevice build() {
    _account = ref.read(accountNotifierProvider);
    return const GolfDevice(); // Initial state: No account data loaded
  }

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
  void handleSwingData(String data, BuildContext context) {
    String packetHeader = data.substring(0, 4);

    // Validate header type and return if it's unrecognized
    if (packetHeader != state.startOfPacketHeader &&
        packetHeader != state.mphPacketHeader && packetHeader != state.endOfPacketHeader &&
        packetHeader != state.swingPointsHeader) {
      return;
    }

    // Use if-else to handle each header case
    if (packetHeader == state.startOfPacketHeader) {
      handleStartOfPacket();
    } else if (packetHeader == state.endOfPacketHeader) {
      handleEndOfPacket(context);
    } else if (packetHeader == state.swingPointsHeader) {
      handleSwingPoints(data);
    } else if (packetHeader == state.mphPacketHeader) {
      handleMphPacket(data);
    }
  }

  // Handles the start of a packet
  void handleStartOfPacket() {
    print("Start of Packet");

    // This tells our Swing Screen UI to show a loading screen
    startReceivingData();

    // At every start we will clear the tempSwingDataPoints array and also the temp speed
    state = state.copyWith(tempSwingDataPoints: [], tempSpeed: 0);
  }

  // Handles the end of a packet and stores the swing data
  Future<void> handleEndOfPacket(BuildContext context) async {
    print("End of Packet");
    SwingData swing = SwingData(speed: state.tempSpeed, swingPoints: state.tempSwingDataPoints);

    // Add the swing to database
    await FirestoreService.addSwing(swing);

    // This tells our UI to hide the loading screen
    stopReceivingData();

    // Check if the SwingResultScreen is already displayed
    bool isScreenAlreadyPresent = false;
    Navigator.popUntil(context, (route) {
      if (route.settings.name == '/swingResultScreen') {
        isScreenAlreadyPresent = true;
      }
      return true;
    });

    if (isScreenAlreadyPresent) {
      // Pop the existing screen
      Navigator.pop(context);
    }

    navigatorKey.currentState?.push(
      MaterialPageRoute(
        settings: const RouteSettings(name: '/swingResultScreen'),
        builder: (context) => SwingResultScreen(quickView: true, swing: swing,), // Replace with your SwingScreen widget
      ),
    );
    print("Data points: ${state.tempSwingDataPoints}");
  }

  // Handles swing points data
  void handleSwingPoints(String data) {
    print(data);
    print("Getting swing z data points");

    // Extract new points from the data
    List<double> newPoints = [];
    for (int i = 18; i < data.length; i += 4) {
      String hexSegment = data.substring(i, i + 4);
      print(hexSegment);

      int zCombinedValue = hexToString(hexSegment);
      print("z combined value: $zCombinedValue");

      double zGForce = zCombinedValue / 100;
      newPoints.add(zGForce); // Add new points
    }

    // Update state with accumulated points
    state = state.copyWith(
      tempSwingDataPoints: [...state.tempSwingDataPoints, ...newPoints],
    );
  }

  // This calculates mph from g-force
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

    state = state.copyWith(tempSpeed: mph.toInt());
  }

  // Set the status to `true`, indicating data is being received.
  void startReceivingData() {
    state = state.copyWith(collectingData: true);
  }

  // Set the status to `false`, indicating data is no longer being received.
  void stopReceivingData() {
    state = state.copyWith(collectingData: false);
  }

}