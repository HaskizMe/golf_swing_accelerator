// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCNCScA4_Nt-r43TegiOb_n5OxWmnb7Zcg',
    appId: '1:1048309130949:web:51f92c2ac0336cf07f32ac',
    messagingSenderId: '1048309130949',
    projectId: 'golf-accelerator',
    authDomain: 'golf-accelerator.firebaseapp.com',
    storageBucket: 'golf-accelerator.firebasestorage.app',
    measurementId: 'G-GC5K4MN96R',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyANz2XtVsLxmOrGSvWZGRmJzi-jNNs5RtI',
    appId: '1:1048309130949:android:03c86cb2fff857867f32ac',
    messagingSenderId: '1048309130949',
    projectId: 'golf-accelerator',
    storageBucket: 'golf-accelerator.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBFq8D-8JEbp-zOUTB2aht-yAy7TPsdyq4',
    appId: '1:1048309130949:ios:436acace90bdae987f32ac',
    messagingSenderId: '1048309130949',
    projectId: 'golf-accelerator',
    storageBucket: 'golf-accelerator.firebasestorage.app',
    iosBundleId: 'com.golfaccelerator.golfAcceleratorApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBFq8D-8JEbp-zOUTB2aht-yAy7TPsdyq4',
    appId: '1:1048309130949:ios:436acace90bdae987f32ac',
    messagingSenderId: '1048309130949',
    projectId: 'golf-accelerator',
    storageBucket: 'golf-accelerator.firebasestorage.app',
    iosBundleId: 'com.golfaccelerator.golfAcceleratorApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCNCScA4_Nt-r43TegiOb_n5OxWmnb7Zcg',
    appId: '1:1048309130949:web:6c689ada5c3d82c57f32ac',
    messagingSenderId: '1048309130949',
    projectId: 'golf-accelerator',
    authDomain: 'golf-accelerator.firebaseapp.com',
    storageBucket: 'golf-accelerator.firebasestorage.app',
    measurementId: 'G-SYPEXV4DXH',
  );
}