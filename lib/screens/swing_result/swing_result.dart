import 'package:flutter/material.dart';
import 'package:golf_accelerator_app/screens/swing/swing.dart';
import 'package:golf_accelerator_app/screens/swing_result/local_widgets/stats_row.dart';
import 'package:golf_accelerator_app/widgets/flat_button.dart';

import '../../theme/app_colors.dart';

class SwingResultScreen extends StatelessWidget {
  const SwingResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.blue, AppColors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(onPressed: () {
            Navigator.pop(context);
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const SwingScreen()),
            // );
          }, icon: Icon(Icons.arrow_back)),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
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
                    const SizedBox(height: 30,),
                    const CustomStatsRow(title: 'Total Carry Distance', result: '95 Yards',),
                    const SizedBox(height: 15,),
                    const CustomStatsRow(title: 'Total Distance', result: '105 Yards',),
                    const SizedBox(height: 15,),
                    const CustomStatsRow(title: 'Swing 1', result: '39 MPH',),
                  ],
                ),

                //const SizedBox(height: 30,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomFlatButton(title: "Reswing", onTap: () {}, width: 110,),
                    CustomFlatButton(title: "Home", onTap: () {}, width: 110),
                    CustomFlatButton(title: "Result", onTap: () {}, width: 110),

                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}



