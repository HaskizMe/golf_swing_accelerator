import 'package:flutter/material.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';

import '../../../theme/app_colors.dart';
class SwingCard extends StatelessWidget {
  final SwingData swing;
  const SwingCard({super.key, required this.swing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20), // Spacing between items
      width: 150,
      decoration: BoxDecoration(
        color: AppColors.honeydew,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.sports_golf_rounded),
            Text("Speed", style: TextStyle(fontSize: 14),),
            Text("${swing.speed} MPH", style: TextStyle(fontSize: 22),),
            Text("${swing.getTotalDistance()} YDS", style: TextStyle(fontSize: 16),),

          ],
        ),
      ),
    );
  }
}

