import 'package:flutter/material.dart';

import '../screens/onboarding/primary_hand.dart';

class CustomFlatButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  const CustomFlatButton({super.key, required this.title, required this.onTap, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 70,
      width: width,
      child: OutlinedButton(
        onPressed: () {
          onTap();
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const PrimaryHand()));
        },
        style: OutlinedButton.styleFrom(
          overlayColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: Colors.white, width: 2), // Set your desired border color here
        ),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
