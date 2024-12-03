import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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

  Future<void> deleteAccount(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user is signed in.',
        );
      }

      String userId = user.uid;

      // Delete user's Firestore data (including subcollections)
      await deleteUserWithSubcollections(userId);

      // Delete the user from Firebase Authentication
      await user.delete();

      // Sign out the user
      await FirebaseAuth.instance.signOut();

      // Notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account deleted successfully.")),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please reauthenticate to delete your account.")),
        );

        // Optionally trigger a reauthentication flow here
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  Future<void> deleteUserWithSubcollections(String userId) async {
    final firestore = FirebaseFirestore.instance;

    // Reference to the user's document
    DocumentReference userDocRef = firestore.collection('users').doc(userId);

    // Delete the swings subcollection
    CollectionReference swingsSubcollection = userDocRef.collection('swings');
    await deleteSubcollection(swingsSubcollection);

    // Delete the user's document
    await userDocRef.delete();
  }

  Future<void> deleteSubcollection(CollectionReference subcollection) async {
    QuerySnapshot snapshot = await subcollection.get();

    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

}