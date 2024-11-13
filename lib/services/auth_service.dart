import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {
  final _auth = FirebaseAuth.instance;


  Future<String?> signup({required String email, required String password, required BuildContext context}) async {

    try {

      await _auth.createUserWithEmailAndPassword(
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

    try {

      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      await initializeUserInFirestore(); // Store data in firestore
      await Future.delayed(const Duration(seconds: 1));

    } on FirebaseAuthException catch(e) {
      print(e.code);
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email.';
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password provided for that user.';
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

      UserCredential? userCredential = await _auth.signInWithCredential(credential);

      await initializeUserInFirestore(); // Store data in firestore

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
      UserCredential? userCredential = await _auth.signInWithCredential(facebookAuthCredential);

      await initializeUserInFirestore(); // Store data in firestore

      return userCredential;
    } catch(e) {
      print("Error signing in with Facebook: $e");
    }
    return null;
  }

  Future<void> initializeUserInFirestore() async {
    // Get the currently signed-in user
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      final userDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

      // Check if the user document exists
      final docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        // Create a new document with initial fields
        await userDoc.set({
          'onboardingComplete': false,
          'displayName': currentUser.displayName,
          'email': currentUser.email,
          // Add any other initial fields you need
        });
      } else {
        print("Document already exists");
      }
    } else {
      print("No user is currently signed in.");
    }
  }

  Future<void> signout() async {

    await _auth.signOut();
    await Future.delayed(const Duration(seconds: 1));
  }
}