import 'package:flutter/material.dart';

class SignInButton extends StatefulWidget {
  final Widget image;
  final String text;
  const SignInButton({super.key, required this.text, required this.image});

  @override
  State<SignInButton> createState() => _SignInButtonState();
}

class _SignInButtonState extends State<SignInButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            overlayColor: Colors.black
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.image,
                const SizedBox(width: 20,),
                Text(widget.text, style: TextStyle(color: Colors.black),)
              ],

            ),
          )
      ),
    );
  }
}
