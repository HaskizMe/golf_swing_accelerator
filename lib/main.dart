import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:golf_accelerator_app/screens/home/home.dart';
import 'package:golf_accelerator_app/screens/login/login.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'Observer/provider_observer.dart'; // Import flutter_riverpod for ProviderScope


void main() {
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
      home: LoginScreen(),
    );
  }
}