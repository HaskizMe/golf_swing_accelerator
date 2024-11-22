import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_accelerator_app/screens/onboarding/golfer_skill.dart';

import '../../theme/app_colors.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [AppColors.silverLakeBlue, AppColors.skyBlue],
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
              SvgPicture.asset("assets/whiteLogin.svg", width: MediaQuery.of(context).size.width * .7,),
              const SizedBox(height: 40,),
              const Text("Welcome!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
              const SizedBox(height: 30,),
              const Text("Tap Let's Go, select your primary hand then", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
              const Text("begin your swing.", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
              const SizedBox(height: 60,),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const GolferSkill()));
                    },
                    style: ElevatedButton.styleFrom(
                      overlayColor: Colors.black,
                      foregroundColor: Colors.black
                    ),
                    child: const Text("Let's Go", style: TextStyle(fontWeight: FontWeight.bold),)
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
