import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/services/auth_service.dart';

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

  Future<void> deleteAccount(BuildContext context, WidgetRef ref) async {
    final _auth = AuthService();
    User? user = FirebaseAuth.instance.currentUser;
    try {

      if (user == null) {
        throw FirebaseAuthException(
          code: 'no-user',
          message: 'No user is signed in.',
        );
      }

      String userId = user.uid;

      // Delete user's Firestore data (including subcollections)
      await deleteUserWithSubcollections(userId);

      // Try to delete the user
      print("Deleting user auth");
      await user.delete();

      // Sign out the user
      _auth.signout(ref);

      // Notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account deleted successfully.")),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        // Prompt reauthentication
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please reauthenticate to delete your account.")),
        );
        //User? user = FirebaseAuth.instance.currentUser;
        // Trigger reauthentication flow
        await _reauthenticate(context, user!);
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

  Future<void> _reauthenticate(BuildContext context, User user) async {
    try {
      // Ensure the user has an email address (for email/password authentication)
      final email = user.email;
      if (email == null) {
        throw Exception("User email not found. Cannot reauthenticate.");
      }

      // Prompt the user for their password
      final password = await _promptForPassword(context);

      // Create the credential
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      // Reauthenticate the user
      await user.reauthenticateWithCredential(credential);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reauthentication successful. Try deleting the account again.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reauthentication failed: $e")),
      );
    }
  }

// Helper method to prompt for a password
  Future<String> _promptForPassword(BuildContext context) async {
    String password = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Reauthenticate"),
        content: TextField(
          obscureText: true,
          decoration: InputDecoration(labelText: "Enter your password"),
          onChanged: (value) {
            password = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Submit"),
          ),
        ],
      ),
    );
    return password;
  }

  Future<void> deleteUserWithSubcollections(String userId) async {
    print("deleting user with subcollections");
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
    print("deleting subcollections");

    QuerySnapshot snapshot = await subcollection.get();

    for (DocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

}