import 'package:flutter/material.dart';

class CustomCarouselButton extends StatelessWidget {
  final String title;
  final Widget image;
  const CustomCarouselButton({super.key, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(color: Colors.white, width: 2), // Set your desired border color here
        ),
        onPressed: () {  },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title, style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),),
                const SizedBox(height: 40,),
                image,
              ],
            ),
          ),
        )
    );
  }
}
