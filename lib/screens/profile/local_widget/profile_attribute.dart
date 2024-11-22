import 'package:flutter/material.dart';

class ProfileAttribute extends StatefulWidget {
  final String title;
  final String data;
  const ProfileAttribute({super.key, required this.title, required this.data});

  @override
  State<ProfileAttribute> createState() => _ProfileAttributeState();
}

class _ProfileAttributeState extends State<ProfileAttribute> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              widget.data,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          // IconButton(
          //   icon: const Icon(Icons.edit, color: Colors.black),
          //   onPressed: () {},
          // ),
        ],
      ),
    );
  }
}
