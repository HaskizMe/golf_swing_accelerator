import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/providers/account_notifier.dart';
import 'package:golf_accelerator_app/screens/onboarding/primary_hand.dart';

import '../../theme/app_colors.dart';
import '../../widgets/flat_button.dart';

class GolferSkill extends ConsumerWidget {
  const GolferSkill({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.forestGreen,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("What type of golfer are you?", style: TextStyle(color: Colors.white, fontSize: 20),),
            const SizedBox(height: 50,),
            CustomFlatButton(title: "Beginner", onTap: () {
              //ref.read(accountProvider.notifier).setSkillLevel("Beginner");
              ref.read(accountNotifierProvider.notifier).setSkillLevel("Beginner");
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrimaryHand()));
            },),
            const SizedBox(height: 20,),
            CustomFlatButton(title: "Moderate", onTap: () {
              //ref.read(accountProvider.notifier).setSkillLevel("Moderate");
              ref.read(accountNotifierProvider.notifier).setSkillLevel("Moderate");

              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrimaryHand()));
            },),
            const SizedBox(height: 20,),
            CustomFlatButton(title: "Advanced", onTap: () {
              //ref.read(accountProvider.notifier).setSkillLevel("Advanced");
              ref.read(accountNotifierProvider.notifier).setSkillLevel("Advanced");

              Navigator.push(context, MaterialPageRoute(builder: (context) => const PrimaryHand()));
            },),

          ],
        ),
      ),
    );
  }
}