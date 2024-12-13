import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome, rootBundle;
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/providers/account_notifier.dart';
import 'package:golf_accelerator_app/providers/bluetooth_notifier.dart';
import 'package:golf_accelerator_app/screens/home/home.dart';
import 'package:golf_accelerator_app/screens/login/login.dart';
import 'package:golf_accelerator_app/screens/onboarding/welcome.dart';
import 'package:golf_accelerator_app/services/auth_service.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
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
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true, // Ensure offline persistence is enabled
  );
  // Lock orientation to portrait mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      /// Provider scope is from riverpod. See riverpod documentation for more details
        ProviderScope(
            observers: [
              // This allows me to see different statuses on my providers
              MyObserver()
            ],
            child: DevicePreview(
              enabled: false,
              builder: (context) => const MyApp(), // Wrap your app
            ),
        )
    );
  });
}


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late StreamSubscription<User?> _authSubscription;

  @override
  void initState() {
    super.initState();

    //AuthService.startAuthListener();

    // Set up the listener for authentication state changes
    // This listens to any changes throughout the app to see if user ever logs out
    // or is already signed in.
    _authSubscription = FirebaseAuth.instance.userChanges().listen((User? user) async {
      if (user == null) {
        print("User not logged in");

        // Navigate to the login screen if the user is signed out
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      } else {
        print("user logged in");
        bool isOnboardingComplete = await FirestoreService.checkOnboardingStatus();
        if(isOnboardingComplete){
          print("user onboarding not complete");
          Map<String, dynamic>? accountInfo = await FirestoreService.getUserInfoWithSwings();
          //print(accountInfo);
          if (accountInfo != null) {
            await ref.read(accountNotifierProvider.notifier).initializeAccountAndSwings(accountInfo);
            print("Account and swings initialized successfully.");
          } else {
            print("Failed to fetch user data.");
          }
          // Navigate to the Home screen if the user is signed in and their onboading is complete
          navigatorKey.currentState?.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeNavigationWrapper()),
                (route) => false,
          );
        } else if(await FirestoreService.validateUserInFirestore()) {
          // Navigate to the welcome screen if the user is signed in
          Map<String, dynamic>? accountInfo = await FirestoreService.getUserInfoWithSwings();
          if (accountInfo != null) {
            await ref.read(accountNotifierProvider.notifier).initializeAccountAndSwings(accountInfo);
            print("Account and swings initialized successfully.");
          } else {
            print("Failed to fetch user data.");
          }

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
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      navigatorKey: navigatorKey, // Attach the navigator key
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(), // Show a loader until we get the auth state
        ),
      ),
    );
  }
}
