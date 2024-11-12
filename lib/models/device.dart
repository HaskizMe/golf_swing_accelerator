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

  @override
  GolfDevice build() {
    //_initialize();
    print("Init here");
    _account = ref.watch(accountProvider);
    return this;
  }
  // handleSpeed(receivedData)
  // grabGforce(receivedData)
  // endOfData(receivedData)
  // handleCalibration(receivedData)
  // handleBattery(receivedData)
  // handleWeight(receivedData)
  // handlePowerMode(receivedData)

  void handleSpeed(String data) {
    // Check if the data starts with "a573"
    if (data.substring(0, 4) != "a573") {
      return;
    }

    // Initialize variables
    String ts = "";
    String len;
    int combinedValue;

    // Ensure data length is at least 22 characters
    if (data.length < 22) return;

    // Extract parts of the data string
    ts = data.substring(4, 16); // Extract Time Stamp
    len = data.substring(16, 18); // Extract Length
    combinedValue = int.parse(data.substring(18, 22), radix: 16); // Convert hex substring to integer
    double gForce = combinedValue / 100.0;

    print("g force: $gForce");
    //print("feet: $heightFt Inches: $heightIn");
    print("Account feet: ${_account.heightFt} Inches: ${_account.heightIn}");

    // Convert height to total inches
    int totalHeightInches = (_account.heightFt * 12) + _account.heightFt;
    print("total height in inches: $totalHeightInches");

    // Calculate radius in meters and velocity values
    double clubLength = 35.5;
    double armLength = totalHeightInches / 2.0;
    double radiusInMeters = 0.025 * (armLength + clubLength);

    //double angularVelocity = (9.81 * gForce / radiusInMeters).sqrt();
    double angularVelocity = sqrt(9.81 * gForce / radiusInMeters);

    double linearVelocity = angularVelocity * radiusInMeters;

    // Convert meters per second to miles per hour
    double mph = (linearVelocity * 2.23694).roundToDouble();
    print("ts = $ts, len = $len, combinedValue = $mph");

    tempSpeed = mph.toInt();
    tempTimeStamp = ts;
    //setSpeed(mph);
    // Example: store last 10 swings in a list, if needed
    // setLast10Swings((current) => [combinedValue, ...current].take(10).toList());
  }

  void handleSwingDataPoints(String data) {
    // Check if the data prefix matches "a572"
    if (data.substring(0, 4) != "a572") {
      return;
    }

    print("Grabbing g-force data: $data");

    // Loop through the data starting from index 18, incrementing by 4 each time
    for (int i = 18; i < data.length; i += 4) {
      String segment = data.substring(i, i + 4);
      int zCombinedValue = int.parse(segment, radix: 16); // Convert hex to integer
      double zGForce = zCombinedValue / 100;

      // Assuming `Globals.zDataArray` exists in your Flutter project
      //Globals.zDataArray.add(zGForce);
      tempSwingDataPoints.add(zGForce);

      print("Z-axis g-force: $zGForce");
    }

    print("Number of Z-axis data points: ${tempSwingDataPoints.length}");
  }

  void handleEndOfSwingData(String data) {
    // Check if the data prefix matches "a545"
    if (data.substring(0, 4) != "a545") {
      return;
    }

    SwingData swing = SwingData(speed: tempSpeed, swingPoints: tempSwingDataPoints, timeStamp: tempTimeStamp);
    ref.read(swingsNotifierProvider.notifier).addSwing(swing);
    last10Swings.add(swing);
    print("End of Data: $data");
    //print("Number of Z-axis data points: ${tempSwingDataPoints.length}");

    //print("Z-axis data array: ${Globals.zDataArray}");

    // Clear the data array after the end of data if needed
    tempSwingDataPoints.clear();

    print("END OF DATA!!!!!!");
  }
}