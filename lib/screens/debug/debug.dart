import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/bluetooth.dart';
import 'package:golf_accelerator_app/screens/debug/local_widgets/debug_buttons.dart';
import 'package:nordic_dfu/nordic_dfu.dart';

import '../../theme/app_colors.dart';

class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the back button color to white
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: SingleChildScrollView(

            /// Main content
            child: Column(
              children: [

                /// All debug buttons
                Wrap(
                  spacing: 5,
                  children: [
                    CustomDebugButton(title: "Set RTC Time", onTap: () {  },),
                    CustomDebugButton(title: "Calibrate", onTap: () {  },),
                    CustomDebugButton(title: "Data Rate", onTap: () {  },),
                    CustomDebugButton(title: "Version", onTap: () {  },),
                    CustomDebugButton(title: "Weight", onTap: () {  },),
                    CustomDebugButton(title: "Battery", onTap: () {  },),
                    CustomDebugButton(title: "Wake-up", onTap: () {  },),
                    CustomDebugButton(title: "Sleep", onTap: () {  },),
                    CustomDebugButton(title: "Update Firmware", onTap: () async {
                      //dfuRunning = true;

                      final result = await FilePicker.platform.pickFiles();

                      if (result == null) return;
                      try {
                        final s = await NordicDfu().startDfu(
                          ref.read(bluetoothProvider.notifier).myConnectedDevice!.remoteId.toString(),
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
                            print('deviceAddress: $deviceAddress, percent: $percent');
                          },
                          // androidSpecialParameter: const AndroidSpecialParameter(rebootTime: 1000),
                        );
                        debugPrint(s);
                        //dfuRunning = false;
                      } catch (e) {
                        //dfuRunning = false;
                        print(e.toString());
                      }
                    },),
                    CustomDebugButton(title: "Disconnect", color: Colors.red, onTap: () {  },),
                    //CustomDebugButton(title: "Set Height", onTap: () {  },),
                  ],
                ),

                /// Height and connected devices text
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Connected Device: ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),

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
    );
  }
}
