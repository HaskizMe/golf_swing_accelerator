import 'package:flutter/material.dart';
import 'package:golf_accelerator_app/screens/onboarding/primary_hand.dart';

import '../../theme/app_colors.dart';
import '../../widgets/flat_button.dart';

class GolferSkill extends StatefulWidget {
  const GolferSkill({super.key});

  @override
  State<GolferSkill> createState() => _GolferSkillState();
}

class _GolferSkillState extends State<GolferSkill> {
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
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("What type of golfer are you?", style: TextStyle(color: Colors.white, fontSize: 20),),
                const SizedBox(height: 50,),
                CustomFlatButton(title: "Beginner", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PrimaryHand()));
                },),
                const SizedBox(height: 20,),
                CustomFlatButton(title: "Moderate", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PrimaryHand()));
                },),
                const SizedBox(height: 20,),
                CustomFlatButton(title: "Advanced", onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PrimaryHand()));
                },),

              ],
            ),
          ),
        ),
      );
  }
}