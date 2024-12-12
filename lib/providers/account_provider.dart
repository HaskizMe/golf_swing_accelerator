import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/providers/swings.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/swing_data.dart';

part 'account_provider.g.dart';

@Riverpod(keepAlive: true)
class AccountNotifier extends _$AccountNotifier {
  StreamSubscription? _accountSubscription;
  StreamSubscription? _swingsSubscription;

  @override
  Account build() {
    return const Account(); // Initial state: No account data loaded
  }

  /// --------------------------------------------------------------------------
  /// Getters and Setters
  /// --------------------------------------------------------------------------
  int? get heightFt => state.heightFt;
  int? get heightIn => state.heightIn;
  double? get height => state.heightCm;

  String? get primaryHand => state.primaryHand;
  void setPrimaryHand(String? hand) => _updateState(primaryHand: hand);

  String? get skillLevel => state.skillLevel;
  void setSkillLevel(String? level) => _updateState(skillLevel: level);

  String? get email => state.email;
  void setEmail(String? email) => _updateState(email: email);

  String? get displayName => state.displayName;
  void setDisplayName(String? name) => _updateState(displayName: name);

  bool get isCalibrated => state.isCalibrated;
  void setCalibrated(bool value) => _updateState(isCalibrated: value);

  // Set height of person by converting cm in to feet and inches
  void setHeight(double heightCm) {
    final totalInches = (heightCm / 2.54).round();
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    _updateState(heightCm: heightCm, heightFt: feet, heightIn: inches);
  }


  /// --------------------------------------------------------------------------
  /// State Management
  /// --------------------------------------------------------------------------

  // Updates the account model class attributes in this provider
  void _updateState({
    double? heightCm,
    int? heightFt,
    int? heightIn,
    String? primaryHand,
    String? skillLevel,
    String? displayName,
    String? email,
    bool? isCalibrated,
  }) {
    state = state.copyWith(
      heightCm: heightCm ?? state.heightCm,
      heightFt: heightFt ?? state.heightFt,
      heightIn: heightIn ?? state.heightIn,
      primaryHand: primaryHand ?? state.primaryHand,
      skillLevel: skillLevel ?? state.skillLevel,
      displayName: displayName ?? state.displayName,
      email: email ?? state.email,
      isCalibrated: isCalibrated ?? state.isCalibrated,
    );
  }

  // Updates the account with new data
  void updateAccount(Map<String, dynamic> updatedData) {
    if (updatedData.containsKey('heightCm') && updatedData['heightCm'] != null) {
      setHeight(updatedData['heightCm'] as double);
    }
    if (updatedData.containsKey('primaryHand') && updatedData['primaryHand'] != null) {
      setPrimaryHand(updatedData['primaryHand'] as String);
    }
    if (updatedData.containsKey('skillLevel') && updatedData['skillLevel'] != null) {
      setSkillLevel(updatedData['skillLevel'] as String);
    }
    if (updatedData.containsKey('displayName')) {
      setDisplayName(updatedData['displayName'] ?? "");
    }
    if (updatedData.containsKey('onboardingComplete') && updatedData['onboardingComplete'] != null) {
      setCalibrated(updatedData['onboardingComplete'] as bool);
    }
    if (updatedData.containsKey('email') && updatedData['email'] != null) {
      setEmail(updatedData['email'] as String);
    }
  }

  // Grabs all account info from database
  void _initializeAccount(Map<String, dynamic> accountInfo) {
    if (accountInfo['heightCm'] != null) {
      double height = accountInfo['heightCm'] as double;
      setHeight(height); // Convert height and set feet/inches
    }
    setDisplayName(accountInfo['displayName'] as String?);
    setPrimaryHand(accountInfo['primaryHand'] as String?);
    setSkillLevel(accountInfo['skillLevel'] as String?);
    setCalibrated(accountInfo['onboardingComplete'] as bool? ?? false);
    setEmail(accountInfo['email'] as String);
  }

  // Grabs all account info from database including swings and populates variables
  Future<void> initializeAccountAndSwings(Map<String, dynamic> accountData) async {
    // Start real-time listener for swings
    await startSwingsListener();
    await startAccountListener();
  }

  // --------------------------------------------------------------------------
  // Firestore Listeners
  // --------------------------------------------------------------------------

  Future<void> startSwingsListener() async {
    User? user = FirebaseAuth.instance.currentUser;
    final swingsNotifier = ref.read(swingsNotifierProvider.notifier);

    _swingsSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .collection('swings')
        .snapshots()
        .listen((snapshot) {

      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          // Pass the document ID explicitly to SwingData
          swingsNotifier.addSwing(
            SwingData.fromJson({
              ...change.doc.data()!,
              'docId': change.doc.id, // Add the doc ID to the data
            }),
          );
        } else if (change.type == DocumentChangeType.modified) {
          // Update swing
          swingsNotifier.updateSwing(
            SwingData.fromJson({
              ...change.doc.data()!,
              'docId': change.doc.id, // Add the doc ID to the data
            }),
          );
        } else if (change.type == DocumentChangeType.removed) {
          print("SWING DELETED");
          // Remove swing
          swingsNotifier.removeSwing(change.doc.id);
        }
      }
    });
  }

  Future<void> startAccountListener() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is logged in");
      return;
    }

    _accountSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid) // Target only the logged-in user's document
        .snapshots() // Listen to changes in the user's document
        .listen((snapshot) {
      if (!snapshot.exists) {
        print("User document does not exist");
        return;
      }

      final accountData = snapshot.data();

      if (accountData != null) {
        // Update the account state in your notifier or UI
        updateAccount(accountData);
      }
    });
  }


  // --------------------------------------------------------------------------
  // Cleanup
  // --------------------------------------------------------------------------
  Future<void> cancelListeners() async {
    await _swingsSubscription?.cancel();
    _swingsSubscription = null;

    await _accountSubscription?.cancel();
    _accountSubscription = null;

    print("Listeners canceled");
  }

}