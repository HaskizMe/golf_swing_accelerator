import 'package:flutter/material.dart';
import 'package:golf_accelerator_app/screens/onboarding/calibrate_club.dart';

class CustomPrimaryHandButton extends StatelessWidget {
  final Widget image;
  final String title;
  const CustomPrimaryHandButton({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CalibrateClub()));
      },
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white, width: 2), // Set the border color to white
        overlayColor: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              image,
              const SizedBox(height: 5,),
              Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
            ],
          ),
        ),
      ),
    );
  }
}
