import 'package:flutter/material.dart';
import 'package:golf_accelerator_app/theme/app_colors.dart';

class CustomDebugButton extends StatelessWidget {
  final String title;
  final Color? color;
  final VoidCallback onTap;
  const CustomDebugButton({super.key, required this.title, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: OutlinedButton(
          onPressed: () {
            onTap();
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(0),
            foregroundColor: Colors.white,
            backgroundColor: color ?? AppColors.moonstone,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: const BorderSide(color: Colors.white, width: 2), // Set your desired border color here
          ),
          child: Text(title, style: TextStyle(fontSize: 12),)
      ),
    );
  }
}
