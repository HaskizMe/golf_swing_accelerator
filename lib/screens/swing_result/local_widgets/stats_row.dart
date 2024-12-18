import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class CustomStatsRow extends StatelessWidget {
  final String title;
  final String result;
  const CustomStatsRow({super.key, required this.title, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      //width: 300,
      decoration: BoxDecoration(
        color: AppColors.forestGreen,
        borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),),
            Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                  color: AppColors.emerald.withOpacity(.9),
                  borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(result, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
            )
          ],
        ),
      ),
    );
  }
}
