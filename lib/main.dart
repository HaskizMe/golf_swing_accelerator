import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/screens/home/home.dart';
import 'package:golf_accelerator_app/screens/login/login.dart';
import 'package:golf_accelerator_app/screens/onboarding/welcome.dart';
import 'package:golf_accelerator_app/services/auth_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Observer/provider_observer.dart'; // Import flutter_riverpod for ProviderScope

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



/// This project uses riverpod heavily. If unfamiliar with it I recommend reading up on riverpod documentation
/// Its a state provider solution and helps create single instance classes to avoid setting classes globally
/// It also helps to update states based on changes. Its really helpful but can be confusing so take your time with it.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      /// Provider scope is from riverpod. See riverpod documentation for more details
      ProviderScope(
        observers: [
          // This allows me to see different statuses on my providers
          MyObserver()
        ],
      child: const MyApp()
  ));
}


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late StreamSubscription<User?> _authSubscription;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();

    // Set up the listener for authentication state changes
    // This listens to any changes throughout the app to see if user ever logs out
    // or is already signed in.
    _authSubscription = FirebaseAuth.instance.userChanges().listen((User? user) async {
      if (user == null) {
        // Navigate to the login screen if the user is signed out
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      } else {
        bool isOnboardingComplete = await _authService.checkOnboardingStatus();
        if(isOnboardingComplete){
          Map<String, dynamic>? accountInfo = await _authService.getUserInfoWithSwings();
          print(accountInfo);
          if (accountInfo != null) {
            await ref.read(accountProvider.notifier).initializeAccountAndSwings(accountInfo);
            print("Account and swings initialized successfully.");
          } else {
            print("Failed to fetch user data.");
          }
          // Navigate to the Home screen if the user is signed in and their onboading is complete
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
          );
        } else if(await _authService.validateUserInFirestore()) {
          // Navigate to the welcome screen if the user is signed in
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                (route) => false,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel(); // Cancel the subscription to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Attach the navigator key
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show a loader until we get the auth state
        ),
      ),
    );
  }
}
