import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/providers/account_notifier.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:crypto/crypto.dart';
import '../providers/swings_notifier.dart';

// Utility class for authentication
class AuthService {
  // Private constructor to prevent instantiation
  AuthService._();

  // --------------------------------------------------------------------------
  // Static Variables
  // --------------------------------------------------------------------------
  static StreamSubscription<User?>? _authSubscription;


  // --------------------------------------------------------------------------
  // Account Creation and Sign-In
  // --------------------------------------------------------------------------

  /// Signs up a new user with email and password.
  static Future<String?> signup({required String email, required String password, required BuildContext context}) async {
    try {
      print("Creating new account");
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Future.delayed(const Duration(seconds: 1));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'email-already-in-use':
          return 'An account already exists with that email.';
        case 'invalid-email':
          return 'Invalid Email.';
        default:
          return 'An unknown error occurred.';
      }
    } catch (e) {
      print(e);
      return 'An error occurred during signup.';
    }
    return null;
  }

  /// Signs in an existing user with email and password.
  static Future<String?> signin({required String email, required String password, required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (FirebaseAuth.instance.currentUser == null) {
        print("User not logged in");
      }

      print(FirebaseAuth.instance.currentUser?.email);
      await FirestoreService.initializeUserInFirestore(); // Initialize Firestore for the user
      await Future.delayed(const Duration(seconds: 1));
    } on FirebaseAuthException catch (e) {
      print(e.code);
      switch (e.code) {
        case 'invalid-email':
          return 'No user found for that email.';
        case 'invalid-credential':
          return 'Invalid credentials provided.';
        default:
          return 'An unknown error occurred.';
      }
    } catch (e) {
      print(e);
      return 'An error occurred during sign-in.';
    }
    return null;
  }


  // --------------------------------------------------------------------------
  // Social Sign-In
  // --------------------------------------------------------------------------

  /// Signs in a user with Google authentication.
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      if (googleAuth == null) return null;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await FirestoreService.initializeUserInFirestore();
      return userCredential;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  /// Signs in a user with Facebook authentication.
  static Future<UserCredential?> signInWithFacebook() async {
    try {
      final loginResult = await FacebookAuth.instance.login();

      if (loginResult.accessToken == null) return null;

      final facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      await FirestoreService.initializeUserInFirestore();
      return userCredential;
    } catch (e) {
      print("Error signing in with Facebook: $e");
      return null;
    }
  }

  /// Signs in a user with Apple authentication.
  static Future<UserCredential> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken!,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      await FirestoreService.initializeUserInFirestore();
      return userCredential;
    } catch (e) {
      print("Error during Apple Sign-In: $e");
      rethrow;
    }
  }

  // --------------------------------------------------------------------------
  // Utility Methods
  // --------------------------------------------------------------------------

  /// Generates a cryptographically secure random nonce.
  static String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  static String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }


  // --------------------------------------------------------------------------
  // Authentication Management
  // --------------------------------------------------------------------------

  /// Signs out the user and invalidates providers.
  static Future<void> signout(WidgetRef ref) async {
    try {
      // Stop other Firestore listeners
      await ref.read(accountNotifierProvider.notifier).cancelListeners();
      ref.invalidate(accountNotifierProvider);
      ref.invalidate(swingsNotifierProvider);

      // Sign out the user
      await FirebaseAuth.instance.signOut();

      print("User signed out successfully.");
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  /// Reauthenticates the user really useful when deleting an account or updating email.
  static Future<void> reauthenticate(BuildContext context, User currentUser) async {
    try {
      for (final provider in currentUser.providerData) {
        print("Provider ID: ${provider.providerId}");

        if (provider.providerId == 'google.com') {
          // Reauthenticate with Google
          final googleUser = await GoogleSignIn().signIn();
          if (googleUser == null) {
            throw Exception("Google sign-in was canceled.");
          }

          final googleAuth = await googleUser.authentication;
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          await currentUser.reauthenticateWithCredential(credential);
          print("Reauthenticated with Google.");
        } else if (provider.providerId == 'apple.com') {
          // Reauthenticate with Apple
          final rawNonce = generateNonce(); // Helper function to generate nonce
          final nonce = AuthService.sha256ofString(rawNonce);

          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [AppleIDAuthorizationScopes.email],
            nonce: nonce,
          );

          final credential = OAuthProvider("apple.com").credential(
            idToken: appleCredential.identityToken,
            rawNonce: rawNonce,
          );

          await currentUser.reauthenticateWithCredential(credential);
          print("Reauthenticated with Apple.");
        } else if (provider.providerId == 'password') {
          // Reauthenticate with Email/Password
          final password = await _promptForPassword(context);
          final credential = EmailAuthProvider.credential(
            email: currentUser.email!,
            password: password,
          );

          await currentUser.reauthenticateWithCredential(credential);
          print("Reauthenticated with Email/Password.");
        } else {
          print("No reauthentication flow for provider: ${provider.providerId}");
        }
      }
    } catch (e) {
      print("Reauthentication failed: $e");
      throw Exception("Reauthentication failed.");
    }
  }

  /// Helper method to prompt for a password
  static Future<String> _promptForPassword(BuildContext context) async {
    String password = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reauthenticate"),
        content: TextField(
          obscureText: true,
          decoration: const InputDecoration(labelText: "Enter your password"),
          onChanged: (value) {
            password = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Submit"),
          ),
        ],
      ),
    );
    return password;
  }

  /// Method to reset password
  static Future<String?> forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (err) {
      //print(err.message.toString());
      return err.message.toString();
      //throw Exception(err.message.toString());
    } catch (err) {
      print(err.toString());

      return "Unknown Error";
      //throw Exception(err.toString());
    }
  }
}