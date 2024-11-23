import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_colors.dart';

class ProfilePicture extends StatelessWidget {
  final double size;
  const ProfilePicture({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, // Adjust the size of the circle
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle, // Makes the container circular
        border: Border.all(
          color: Colors.white, // White border color
          width: 4.0, // Border width
        ),
      ),
      child: Stack(
        children: [
          // Background color
          Container(
            decoration: const BoxDecoration(
              color: AppColors.forestGreen, // Background color
              shape: BoxShape.circle, // Keep the background circular
            ),
          ),
          // SVG on top
          Align(
            alignment: Alignment.center,
            child: ClipOval(
              child: SvgPicture.asset(
                'assets/profile image.svg', // Replace with your SVG asset path
                fit: BoxFit.cover, // Ensures the SVG scales properly
              ),
            ),
          ),
        ],
      ),
    );
  }
}
