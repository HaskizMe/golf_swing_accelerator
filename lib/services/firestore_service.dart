import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';

class FirestoreService {
  final _currentUser = FirebaseAuth.instance.currentUser;

  /// Initializes the user's Firestore document if it doesn't already exist.
  Future<void> initializeUserInFirestore() async {
    // Get the currently signed-in user
    //User? currentUser = FirebaseAuth.instance.currentUser;

    if (_currentUser != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(_currentUser.uid);

      // Check if the user document exists
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        //print("here");
        // Create a new document with initial fields
        await userDoc.set({
          'onboardingComplete': false,
          'displayName': _currentUser.displayName,
          'email': _currentUser.email,
          'skillLevel': null,
          'primaryHand': null,
          'heightCm': null,
          'createdAt': FieldValue.serverTimestamp(), // Add creation timestamp
        });

        print("User document initialized.");
      } else {
        print("Document already exists");
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  Future<void> addSwing(SwingData swing) async {
    if(_currentUser != null){
      final swingsCollection = FirebaseFirestore.instance
          .collection('users').doc(_currentUser.uid)
          .collection('swings');

      await swingsCollection.add(swing.toJson());
    }
  }

  Future<void> deleteSwing(String docId) async {
    print("doc id: $docId");
    if (_currentUser != null) {
      final swingsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .collection('swings');

      await swingsCollection.doc(docId).delete();
      print("Swing with ID $docId has been deleted.");
    }
  }
}