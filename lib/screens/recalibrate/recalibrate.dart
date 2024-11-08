import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class RecalibrateScreen extends StatelessWidget {
  const RecalibrateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the back button color to white
          ),
        ),
        body: const Column(
          children: [
            Text("Recalibrate")
          ],
        ),
      ),
    );
  }
}
