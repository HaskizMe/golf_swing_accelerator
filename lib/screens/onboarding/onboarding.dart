import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppColors.blue, AppColors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("What type of golfer are you?", style: TextStyle(color: Colors.white, fontSize: 20),),
                SizedBox(height: 50,),
                SizedBox(
                  height: 70,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Beginner",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      overlayColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(color: Colors.white, width: 2), // Set your desired border color here
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                SizedBox(
                  height: 70,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Moderate",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      overlayColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(color: Colors.white, width: 2), // Set your desired border color here
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                SizedBox(
                  height: 70,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text(
                      "Advanced",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: OutlinedButton.styleFrom(
                      overlayColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(color: Colors.white, width: 2), // Set your desired border color here
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}