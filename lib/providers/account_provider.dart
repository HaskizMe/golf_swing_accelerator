
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:golf_accelerator_app/models/accountModel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'account_provider.g.dart';


@Riverpod(keepAlive: true)
class AccountNotifier extends _$AccountNotifier {
  StreamSubscription? _accountSubscription;

  @override
  AccountModel? build() {
    _initialize();
    return null; // Initial state: No account data loaded
  }

  Future<void> _initialize() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      state = null; // No user is logged in
      return;
    }

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Listen to Firestore document changes
    _accountSubscription = docRef.snapshots().listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          state = AccountModel.fromJson(data); // Update state
        }
      } else {
        state = null; // User document does not exist
      }
    });
  }

}