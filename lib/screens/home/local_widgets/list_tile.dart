import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final VoidCallback navigation;
  const CustomListTile({super.key, required this.title, required this.navigation});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,),
      splashColor: Colors.grey,
      onTap: () {
        navigation();
      },
    );
  }
}
