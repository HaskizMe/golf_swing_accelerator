import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final double? height;
  const CustomButton({super.key, required this.title, required this.onTap, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 60,
      child: ElevatedButton(
        onPressed: () => onTap(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.forestGreen,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Set border radius here
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
