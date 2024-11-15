import 'package:cloud_firestore/cloud_firestore.dart';


/// This class is used to store swing information
class SwingData {

  // Attributes
  final String? swingId;
  final int speed;
  final List<double> swingPoints;
  final Timestamp? createdAt; // Make createdAt optional

  // Constructor
  SwingData({
    required this.speed,
    required this.swingPoints,
    this.createdAt,
    this.swingId,
  });

  // Methods


  // Method to calculate carry distance
  int getCarryDistance() {
    return (speed * 2.45).toInt();
  }

  // Method to calculate total distance
  int getTotalDistance() {
    return (speed * 2.7).toInt();
  }

  // Method to convert to JSON (Firestore-compatible format)
  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'swingPoints': swingPoints,
      'carryDistance': getCarryDistance(),
      'totalDistance': getTotalDistance(),
      'createdAt': FieldValue.serverTimestamp(), // Automatically set by Firestore
    };
  }

  // Factory constructor to create an instance from JSON (useful for Firestore reads)
  factory SwingData.fromJson(Map<String, dynamic> json) {
    return SwingData(
      swingId: json['docId'],
      speed: json['speed'],
      swingPoints: List<double>.from(json['swingPoints']),
      createdAt: json['createdAt'] as Timestamp?,
    );
  }
}