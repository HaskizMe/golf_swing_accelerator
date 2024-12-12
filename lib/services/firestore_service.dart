import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/providers/account_provider.dart';
import 'package:golf_accelerator_app/services/auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';

class FirestoreService {
  // Private constructor to prevent instantiation
  FirestoreService._();

  // --------------------------------------------------------------------------
  // User Initialization
  // --------------------------------------------------------------------------

  /// Initializes the user's Firestore document if it doesn't already exist.
  static Future<void> initializeUserInFirestore() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      print("No user is currently signed in.");
      return;
    }

    final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

    // Check if the user document exists
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      // Create a new document with initial fields
      await userDoc.set({
        'onboardingComplete': false,
        'displayName': currentUser.displayName,
        'email': currentUser.email,
        'skillLevel': null,
        'primaryHand': null,
        'heightCm': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print("User document initialized.");
    } else {
      print("Document already exists");
    }
  }


  // --------------------------------------------------------------------------
  // Swing Management
  // --------------------------------------------------------------------------

  /// Adds a swing document to the Firestore 'swings' subcollection.
  static Future<void> addSwing(SwingData swing) async {
    if(FirebaseAuth.instance.currentUser != null){
      final swingsCollection = FirebaseFirestore.instance
          .collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('swings');

      await swingsCollection.add(swing.toJson());
    }
  }

  /// Deletes a swing document from the Firestore 'swings' subcollection.
  static Future<void> deleteSwing(String docId) async {
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


  // --------------------------------------------------------------------------
  // Account Management
  // --------------------------------------------------------------------------

  /// Updates a specific field in the user's Firestore document.
  static Future<void> updateAccountFields(Map<String, dynamic> fields) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) throw Exception("No user is logged in");

    try {
      await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update(fields);
    } catch (e) {
      throw Exception("Failed to update account fields: $e");
    }
  }

  /// Deletes the user's Firestore data and authentication account.
  static Future<void> deleteAccount(BuildContext context, WidgetRef ref) async {
    User? user = FirebaseAuth.instance.currentUser;

    try {
      if (user == null) {
        throw FirebaseAuthException(code: 'no-user', message: 'No user is signed in.');
      }
      String userId = user.uid;

      // Cancels listeners to the account so we don't get permissions errors after deleting account
      ref.read(accountNotifierProvider.notifier).cancelListeners();

      // Delete user's Firestore data (including subcollections)
      await deleteUserWithSubcollections(userId);

      try {
        // Attempt to delete the user
        print("Deleting user auth");
        await user.delete();

        await FirebaseAuth.instance.signOut();

        // Notify the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully.")),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'requires-recent-login') {
          // Reauthentication is needed and then we can delete account
          await AuthService.reauthenticate(context, user);
          await user.delete(); // Delete user auth

          await FirebaseAuth.instance.signOut(); // Sign out

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Account deleted successfully.")),
          );
        } else {
          throw e; // Rethrow other exceptions
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }


  // --------------------------------------------------------------------------
  // Firestore Deletion Helpers
  // --------------------------------------------------------------------------

  /// Deletes the user's Firestore document and its subcollections.
  static Future<void> deleteUserWithSubcollections(String userId) async {
    final firestore = FirebaseFirestore.instance;

    // Reference to the user's document
    DocumentReference userDocRef = firestore.collection('users').doc(userId);

    // Delete the swings subcollection
    CollectionReference swingsSubcollection = userDocRef.collection('swings');
    await deleteSubcollection(swingsSubcollection);

    // Delete the user's document
    await userDocRef.delete();
  }

  /// Deletes all documents within a subcollection.
  static Future<void> deleteSubcollection(CollectionReference subcollection) async {
    print("Deleting subcollections");
    QuerySnapshot snapshot = await subcollection.get();
    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // --------------------------------------------------------------------------
  // Firestore Utility Functions
  // --------------------------------------------------------------------------

  /// Updates specific fields in the user's Firestore document.
  static Future<void> updateUserProperties(Map<String, dynamic> updatedFields) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      try {
        await userDoc.update(updatedFields);
        print("User properties updated: $updatedFields");
      } catch (e) {
        print("Failed to update user properties: $e");
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  /// Reads all user information from Firestore.
  static Future<Map<String, dynamic>?> _getUserInfo() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      try {
        final docSnapshot = await userDoc.get();
        if (docSnapshot.exists) {
          return docSnapshot.data(); // Return the document data as a Map
        } else {
          print("User document does not exist.");
          return null;
        }
      } catch (e) {
        print("Failed to read user information: $e");
        return null;
      }
    } else {
      print("No user is currently signed in.");
      return null;
    }
  }


  /// Reads all user information and associated swings from Firestore.
  static Future<Map<String, dynamic>?> getUserInfoWithSwings() async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
      final swingsCollection = userDoc.collection('swings');

      try {
        // Fetch user information
        final userSnapshot = await userDoc.get();
        if (!userSnapshot.exists) {
          print("User document does not exist.");
          return null;
        }

        final userData = userSnapshot.data();

        // Fetch swings
        final swingsSnapshot = await swingsCollection.get();
        final swings = swingsSnapshot.docs.map((doc) {
          final swingData = doc.data();
          swingData['docId'] = doc.id; // Add the document ID for reference
          return swingData;
        }).toList();

        // Combine user data and swings
        return {
          ...?userData, // Add user data
          'swings': swings, // Add swings as a list
        };
      } catch (e) {
        print("Failed to fetch user information and swings: $e");
        return null;
      }
    } else {
      print("No user is currently signed in.");
      return null;
    }
  }

  static Future<bool> checkOnboardingStatus() async {
    Map<String, dynamic>? info = await _getUserInfo();

    if (info != null) {
      // Safely access the 'onboardingComplete' property
      bool onboardingComplete = info['onboardingComplete'] ?? false;

      if (onboardingComplete) {
        print("Onboarding is complete!");
        return true;
        // Perform actions for completed onboarding
      } else {
        print("Onboarding is not complete.");
        // Perform actions for incomplete onboarding
      }
    } else {
      print("Failed to retrieve user information.");
    }
    return false;
  }

  static Future<bool> validateUserInFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        // User does not exist in Firestore, sign them out
        await FirebaseAuth.instance.signOut();
        print("User not found in Firestore. Signed out.");
        return false;
      }
      return true;
    }
    return false;
  }
}