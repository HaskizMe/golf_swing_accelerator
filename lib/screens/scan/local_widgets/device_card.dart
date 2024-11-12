import 'package:flutter/material.dart';

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final String status;
  final String? rssi;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.status,
    required this.onTap,
    required this.deviceName,
    this.rssi,
  });

  // Helper function to determine status color
  Color _getStatusColor(String status) {
    switch (status) {
      case "Connected":
        return Colors.green;
      case "Connecting...":
        return Colors.amber[900]!;
      case "Unable to connect":
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: ListTile(
              title: Text(
                deviceName,
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
              leading: const Icon(Icons.bluetooth),
              subtitle: Text(
                "Status: $status",
                style: TextStyle(color: _getStatusColor(status)),
              ),
              trailing: Text(
                rssi ?? "",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }
}