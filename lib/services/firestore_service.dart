import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';

class FirestoreService {
  /// Initializes the user's Firestore document if it doesn't already exist.
  Future<void> initializeUserInFirestore() async {
    // Get the currently signed-in user
    //User? currentUser = FirebaseAuth.instance.currentUser;
    print("in firestore ${FirebaseAuth.instance.currentUser?.email}");
    if (FirebaseAuth.instance.currentUser != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid);

      // Check if the user document exists
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        //print("here");
        // Create a new document with initial fields
        await userDoc.set({
          'onboardingComplete': false,
          'displayName': FirebaseAuth.instance.currentUser!.displayName,
          'email': FirebaseAuth.instance.currentUser!.email,
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
    if(FirebaseAuth.instance.currentUser != null){
      final swingsCollection = FirebaseFirestore.instance
          .collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('swings');

      await swingsCollection.add(swing.toJson());
    }
  }

  Future<void> deleteSwing(String docId) async {
    print("doc id: $docId");
    if (FirebaseAuth.instance.currentUser != null) {
      final swingsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('swings');

      await swingsCollection.doc(docId).delete();
      print("Swing with ID $docId has been deleted.");
    }
  }

  Future<void> updateAccountField(String field, dynamic value) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print("No user is logged in");
      return;
    }

    try {
      // Update the specific field in the user's account document
      await FirebaseFirestore.instance
          .collection('users') // Access the 'users' collection
          .doc(user.uid) // Target the logged-in user's document
          .update({field: value}); // Update the field with the new value

      print("Account field '$field' updated successfully");
    } catch (e) {
      print("Failed to update account field: $e");
    }
  }

  Future<void> updateAccountFields(Map<String, dynamic> fields) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("No user is logged in");
    }

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(fields); // Update only the provided fields
    } catch (e) {
      throw Exception("Failed to update account fields: $e");
    }
  }

}