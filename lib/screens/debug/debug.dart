import 'package:flutter/material.dart';
import 'package:golf_accelerator_app/screens/debug/local_widgets/debug_buttons.dart';

import '../../theme/app_colors.dart';

class DebugScreen extends StatelessWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                const Wrap(
                  spacing: 5,
                  children: [
                    CustomDebugButton(title: "Set RTC Time"),
                    CustomDebugButton(title: "Calibrate"),
                    CustomDebugButton(title: "Data Rate"),
                    CustomDebugButton(title: "Version"),
                    CustomDebugButton(title: "Weight"),
                    CustomDebugButton(title: "Battery"),
                    CustomDebugButton(title: "Wake-up"),
                    CustomDebugButton(title: "Sleep"),
                    CustomDebugButton(title: "Update Firmware"),
                    CustomDebugButton(title: "Disconnect", color: Colors.red,),
                    CustomDebugButton(title: "Set Height"),
                  ],
                ),

                /// Height and connected devices text
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Height: ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                      Text("Connected Device: ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
                const SizedBox(height: 20,),

                /// MPH display
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.3),
                      border: Border.all(
                        color: Colors.white,
                        width: 2
                      )
                    ),
                    width: 200,
                    height: 200,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("0", style: TextStyle(color: Colors.white, fontSize: 70),),
                          Text("MPH", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
                        ]
                    ),
                  ),
                ),
                const SizedBox(height: 20,),

                /// captured packets text
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Last 10 captured packets: ", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),)
                ),
                const SizedBox(height: 20,),

                /// All Captured Packets
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.teal,
                    borderRadius: BorderRadius.circular(20), // Set the corner radius
                    border: Border.all(
                      color: Colors.white, // Set the border color
                      width: 2.0, // Set the border width
                    ),
                  ),
                  //width: 200,
                  height: 80,
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No data received from the device so far.", style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
