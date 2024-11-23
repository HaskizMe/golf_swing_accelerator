import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';

import '../models/account.dart';
import '../providers/swings.dart';



class AuthService {
  final firestore = FirestoreService();


  Future<String?> signup({required String email, required String password, required BuildContext context}) async {

    try {

      print("Creating new account");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      await Future.delayed(const Duration(seconds: 1));

    } on FirebaseAuthException catch(e) {
      print(e.code);
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      } else if(e.code == 'invalid-email'){
        message = 'Invalid Email.';
      }
      return message;
    }
    catch(e){

      print(e);
    }
    return null;

  }

  Future<String?> signin({required String email, required String password, required BuildContext context}) async {

    print("here");
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      if(FirebaseAuth.instance.currentUser == null){
        print("User not logged in");
      }

      print(FirebaseAuth.instance.currentUser?.email);
      // Explicitly reload the current user to ensure it's up-to-date
      //await FirebaseAuth.instance.currentUser?.reload();
      await firestore.initializeUserInFirestore(); // Store data in firestore
      await Future.delayed(const Duration(seconds: 1));

    } on FirebaseAuthException catch(e) {
      print(e.code);
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'The credentials that were provided were not valid.';
      }
      return message;
    }
    catch(e){
      print(e);

    }
    return null;

  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);

      UserCredential? userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      await firestore.initializeUserInFirestore(); // Store data in firestore

      return userCredential;

    } catch (e) {
      print("Error signing in with Google: $e");
    }
    return null;
  }

  Future<UserCredential?> signInWithFacebook() async {
    try{
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      UserCredential? userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      await firestore.initializeUserInFirestore(); // Store data in firestore

      return userCredential;
    } catch(e) {
      print("Error signing in with Facebook: $e");
    }
    return null;
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // Set these values appropriately
        clientId: 'com.golfaccelerator.golf_accelerator_app',
        redirectUri: Uri.parse(
          'https://your-backend-domain/callbacks/sign_in_with_apple',
        ),
      ),
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  // /// Initializes the user's Firestore document if it doesn't already exist.
  // Future<void> initializeUserInFirestore() async {
  //   // Get the currently signed-in user
  //   User? currentUser = _auth.currentUser;
  //
  //   if (currentUser != null) {
  //     final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
  //
  //     // Check if the user document exists
  //     final docSnapshot = await userDoc.get();
  //     if (!docSnapshot.exists) {
  //       //print("here");
  //       // Create a new document with initial fields
  //       await userDoc.set({
  //         'onboardingComplete': false,
  //         'displayName': currentUser.displayName,
  //         'email': currentUser.email,
  //         'skillLevel': null,
  //         'primaryHand': null,
  //         'heightCm': null,
  //         'createdAt': FieldValue.serverTimestamp(), // Add creation timestamp
  //       });
  //
  //       // print("here 2");
  //       // // Add a placeholder document to the swings subcollection
  //       // final swingsCollection = userDoc.collection('swings');
  //       // await swingsCollection.doc('placeholder').set({
  //       //   'speed': null,
  //       //   'carryDistance': null,
  //       //   'totalDistance': null,
  //       //   'timestamp': FieldValue.serverTimestamp(),
  //       // });
  //       //
  //       print("User document and swings subcollection initialized.");
  //     } else {
  //       print("Document already exists");
  //     }
  //   } else {
  //     print("No user is currently signed in.");
  //   }
  // }

  /// Updates specific fields in the user's Firestore document.
  Future<void> updateUserProperties(Map<String, dynamic> updatedFields) async {
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
  Future<Map<String, dynamic>?> getUserInfo() async {
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
  Future<Map<String, dynamic>?> getUserInfoWithSwings() async {
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

  Future<bool> checkOnboardingStatus() async {
    Map<String, dynamic>? info = await getUserInfo();

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

  Future<bool> validateUserInFirestore() async {
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

  Future<void> signout(WidgetRef ref) async {
    try {
      // Stop any active Firestore listeners
      await ref.read(accountProvider).cancelListeners();
      ref.invalidate(accountProvider); // Invalidate account listener
      ref.invalidate(swingsNotifierProvider); // Invalidate swings listener

      // Sign out the user
      await FirebaseAuth.instance.signOut();
      print("User signed out successfully.");
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  void setupLoginListener() {
    print("here1");
    FirebaseAuth.instance.userChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }
}