import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:golf_accelerator_app/screens/home/home.dart';
import 'package:golf_accelerator_app/screens/login/login.dart';
import 'package:golf_accelerator_app/screens/onboarding/welcome.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Observer/provider_observer.dart'; // Import flutter_riverpod for ProviderScope


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      ProviderScope(
        observers: [
          MyObserver()
        ],
      child: const MyApp()
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if user is authenticated
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading screen while checking the authentication status
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          // User is signed in, navigate to home screen
          return const WelcomeScreen();
        } else {
          // User is not signed in, navigate to login screen
          return const LoginScreen();
        }
      },
    );
  }
}