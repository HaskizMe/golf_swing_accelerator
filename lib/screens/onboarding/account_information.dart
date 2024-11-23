import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AccountInformation extends StatefulWidget {
  const AccountInformation({super.key});

  @override
  State<AccountInformation> createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  @override
  Widget build(BuildContext context) {
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
            // const Text("Let's get some more information about you", style: TextStyle(color: Colors.white, fontSize: 20),),
            // const SizedBox(height: 50,),
            // CustomFlatButton(title: "Beginner", onTap: () {
            //   ref.read(accountProvider.notifier).setSkillLevel("Beginner");
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => const PrimaryHand()));
            // },),
            // const SizedBox(height: 20,),
            // CustomFlatButton(title: "Moderate", onTap: () {
            //   ref.read(accountProvider.notifier).setSkillLevel("Moderate");
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => const PrimaryHand()));
            // },),
            // const SizedBox(height: 20,),
            // CustomFlatButton(title: "Advanced", onTap: () {
            //   ref.read(accountProvider.notifier).setSkillLevel("Advanced");
            //   Navigator.push(context, MaterialPageRoute(builder: (context) => const PrimaryHand()));
            // },),

          ],
        ),
      ),
    );
  }
}

