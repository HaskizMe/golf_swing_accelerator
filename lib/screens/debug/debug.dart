import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/providers/bluetooth_provider.dart';
import 'package:golf_accelerator_app/screens/debug/local_widgets/debug_buttons.dart';
import 'package:nordic_dfu/nordic_dfu.dart';

import '../../theme/app_colors.dart';

class DebugScreen extends ConsumerStatefulWidget {
  final String deviceName;
  const DebugScreen({super.key, required this.deviceName});

  @override
  ConsumerState<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends ConsumerState<DebugScreen> {
  // final _ble = BluetoothModel();
  //final _ble = ref.read(BluetoothNotifierProvider);
  bool dfuInProgress = false;
  int progress = 0;

  void powerMode({required bool wakeup}) {
    final ble = ref.read(bluetoothNotifierProvider.notifier);
    if(wakeup){
      ble.writeToDevice([0xa5,0x50,0x01]);
    } else{
      ble.writeToDevice([0xa5,0x50,0x00]);
    }
  }

  Future<void> updateFirmware() async {
    final ble = ref.read(bluetoothNotifierProvider.notifier);
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;
    try {
      setState(() {
        dfuInProgress = true;
      });
      final s = await NordicDfu().startDfu(
        ble.connectedDevice!.remoteId.toString(),
        result.files.single.path ?? '',
        onDeviceDisconnecting: (string) {
          print('deviceAddress: $string');
        },

        onProgressChanged: (
            deviceAddress,
            percent,
            speed,
            avgSpeed,
            currentPart,
            partsTotal,
            ) {
          setState(() {
            progress = percent;
          });
          print('deviceAddress: $deviceAddress, percent: $percent');
        },
      );
      print(s);
      //dfuRunning = false;
    } catch (e) {
      //dfuRunning = false;
      print(e.toString());
    }
    setState(() {
      dfuInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(
              color: Colors.black, // Set the back button color to white
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SingleChildScrollView(

              /// Main content
              child: Column(
                children: [

                  /// connected devices text
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Connected Device: ${widget.deviceName}", style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),

                  /// Need to implement calibration step
                  // Card(color: AppColors.honeydew,child: ListTile(title: Text("Calibrate Device"), onTap: () {}),),
                  Card(color: AppColors.honeydew,child: ListTile(title: Text("Wake-up"), onTap: () => powerMode(wakeup: true)),),
                  Card(color: AppColors.honeydew,child: ListTile(title: Text("Sleep"), onTap: () => powerMode(wakeup: false)),),
                  Card(color: AppColors.honeydew,child: ListTile(title: Text("Update Firmware"), onTap: () async => await updateFirmware()),),
                  //Card(child: ListTile(title: Text("Disconnect", style: TextStyle(color: Colors.white),), onTap: () {}), color: Colors.red,),

                  /// All debug buttons
                  // Wrap(
                  //   spacing: 5,
                  //   children: [
                  //     CustomDebugButton(title: "Set RTC Time", onTap: () {  },),
                  //     CustomDebugButton(title: "Calibrate", onTap: () {  },),
                  //     CustomDebugButton(title: "Data Rate", onTap: () {  },),
                  //     CustomDebugButton(title: "Version", onTap: () {  },),
                  //     CustomDebugButton(title: "Weight", onTap: () {  },),
                  //     CustomDebugButton(title: "Battery", onTap: () {  },),
                  //     CustomDebugButton(title: "Wake-up", onTap: () => powerMode(wakeup: true),),
                  //     CustomDebugButton(title: "Sleep", onTap: () => powerMode(wakeup: false),),
                  //     CustomDebugButton(title: "Update Firmware", onTap: () async => await updateFirmware(),),
                  //     CustomDebugButton(title: "Disconnect", color: Colors.red, onTap: () {  },),
                  //     //CustomDebugButton(title: "Set Height", onTap: () {  },),
                  //   ],
                  // ),

                  // /// MPH display
                  // Align(
                  //   alignment: Alignment.center,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       shape: BoxShape.circle,
                  //       color: Colors.white.withOpacity(.3),
                  //       border: Border.all(
                  //         color: Colors.white,
                  //         width: 2
                  //       )
                  //     ),
                  //     width: 200,
                  //     height: 200,
                  //     child: const Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Text("0", style: TextStyle(color: Colors.white, fontSize: 70),),
                  //           Text("MPH", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
                  //         ]
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 20,),
                  //
                  // /// captured packets text
                  // const Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text("Last 10 captured packets: ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
                  // ),
                  // const SizedBox(height: 20,),
                  //
                  // /// All Captured Packets
                  // Container(
                  //   decoration: BoxDecoration(
                  //     color: AppColors.teal,
                  //     borderRadius: BorderRadius.circular(20), // Set the corner radius
                  //     border: Border.all(
                  //       color: Colors.white, // Set the border color
                  //       width: 2.0, // Set the border width
                  //     ),
                  //   ),
                  //   //width: 200,
                  //   height: 80,
                  //   child: const Padding(
                  //     padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Text("No data received from the device so far.", style: TextStyle(color: Colors.white),),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 50,)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: dfuInProgress,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Align(
              alignment: Alignment.center,
              child: Container(
                width: 250,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Progress", style: TextStyle(fontSize: 20),),
                      const SizedBox(height: 10,),
                      Text("$progress%", style: TextStyle(fontSize: 18),),
                      const SizedBox(height: 20,),

                      ElevatedButton(
                        onPressed: () async {
                          await NordicDfu().abortDfu();
                          setState(() {
                            dfuInProgress = false;
                          });
                        },
                        child: Text("Cancel",),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
