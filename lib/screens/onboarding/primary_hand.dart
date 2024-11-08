import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golf_accelerator_app/screens/onboarding/local_widgets/primary_hand_button.dart';

import '../../theme/app_colors.dart';

class PrimaryHand extends StatelessWidget {
  const PrimaryHand({super.key});

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
        body: Column(
          children: [
            const SizedBox(height: 40,),

            const Text(
              "The Club needs to be",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "calibrated first",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              "Select your primary hand",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomPrimaryHandButton(image: SvgPicture.asset("assets/leftHand.svg"), title: "Left"),
                const SizedBox(width: 20),
                CustomPrimaryHandButton(image: SvgPicture.asset("assets/rightHand.svg"), title: "Right"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}