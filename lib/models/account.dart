import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../providers/swings.dart';
part 'account.g.dart';

@Riverpod(keepAlive: true)
class Account extends _$Account {
  int? _heightFt;
  int? _heightIn;
  double? _height;
  String? _primaryHand;
  String? _skillLevel;
  String? _displayName;
  bool _isCalibrated = false;

  @override
  Account build() {
    _initialize();
    return this;
  }

  // Initialize method (currently empty)
  void _initialize() async {
    // Add initialization logic if needed
  }

  // Getters and setters for height
  int? get heightFt => _heightFt; // Getter for height in feet
  int? get heightIn => _heightIn; // Getter for height in inches
  double? get height => _height; // Getter for total height in cm

  void setHeight(double height) {
    _height = height;
    _convertHeightToFeetInches(height);
    state = this; // Notify listeners of state change
  }

  // Function to convert height from cm to ft and in format
  void _convertHeightToFeetInches(double cm) {
    final totalInches = (cm / 2.54).round(); // Convert cm to inches
    _heightFt = totalInches ~/ 12; // Get the feet part
    _heightIn = totalInches % 12; // Get the remaining inches
  }

  // Getter and setter for primary hand
  String? get primaryHand => _primaryHand; // Getter

  void setPrimaryHand(String hand) {
    _primaryHand = hand;
    state = this; // Notify listeners of state change
  }

  // Getter and setter for skill level
  String? get skillLevel => _skillLevel; // Getter

  void setSkillLevel(String level) {
    _skillLevel = level;
    state = this; // Notify listeners of state change
  }

  // Getter and setter for isCalibrated
  bool get isCalibrated => _isCalibrated; // Getter

  void setCalibrated(bool value) {
    _isCalibrated = value;
    state = this; // Notify listeners of state change
  }

  /// Grabs all account info from database
  void initializeAccount(Map<String, dynamic> accountInfo) {
    if (accountInfo['heightCm'] != null) {
      _height = accountInfo['heightCm'] as double?;
      setHeight(_height!); // Convert height and set feet/inches
    }
    _displayName = accountInfo['displayName'] as String?;
    _primaryHand = accountInfo['primaryHand'] as String?;
    _skillLevel = accountInfo['skillLevel'] as String?;
    _isCalibrated = accountInfo['onboardingComplete'] as bool? ?? false;

    state = this; // Notify listeners of state change
  }

  /// Grabs all account info from database including swings and populates variables
  Future<void> initializeAccountAndSwings(Map<String, dynamic> accountData) async {
    // Initialize Account
    ref.read(accountProvider.notifier).initializeAccount(accountData);

    // Initialize Swings
    if (accountData['swings'] != null) {
      ref.read(swingsNotifierProvider.notifier).setSwings(accountData['swings']);
    }
  }
}