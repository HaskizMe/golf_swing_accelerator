import 'package:flutter/material.dart';

class SignInButton extends StatelessWidget {
  final Widget image;
  final String text;
  final VoidCallback onTap;
  const SignInButton({super.key, required this.text, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: OutlinedButton(
          onPressed: () => onTap(),
          style: OutlinedButton.styleFrom(
            overlayColor: Colors.black
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                image,
                const SizedBox(width: 20,),
                Text(text, style: TextStyle(color: Colors.black),)
              ],

            ),
          )
      ),
    );
  }
}
