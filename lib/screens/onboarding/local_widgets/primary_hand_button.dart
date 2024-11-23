import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class CustomPrimaryHandButton extends StatelessWidget {
  final Widget image;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const CustomPrimaryHandButton({
    super.key,
    required this.image,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: isSelected ? Colors.white : Colors.transparent,
        side: BorderSide(color: Colors.white, width: 2), // Border color
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
              isSelected
                  ? ColorFiltered(
                colorFilter: const ColorFilter.mode(AppColors.forestGreen, BlendMode.srcIn),
                child: image,
              )
                  : image,
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.forestGreen : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}