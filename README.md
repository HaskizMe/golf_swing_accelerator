# Flutter Golf Accelerator App

## Overview
The Golf Accelerator App is a Flutter-based application that helps users analyze their golf swings and track performance metrics. The app leverages Firebase for authentication and data storage, and uses Riverpod for state management.

### Features
- Analyze swing speed, carry distance, and total distance.
- Bluetooth-enabled data collection.
- User authentication via Firebase.
- View historical swing data and performance metrics.

---

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# key Information
This project uses Firebase authentication, Firestore database, and riverpod. If unfamiliar with these things I recommend going over their documentation. 

# My Build Settings
- Flutter version 3.24.1 
- Dart version 3.5.1
- DevTools version 2.37.2

## Folder Structure

Below is an overview of the main folders in the `lib/` directory and their purpose:

```
assets/                  # Images, svgs, etc.
lib/                
  models/                # Data models and classes (e.g., SwingData, account)
  providers/             # Riverpod providers
  screens/               # UI screens
    screen 1/            
        local_widgets    # Widgets associated with that screen
        screen1.dart     # Screen UI file
    screen 2/
        local_widgets
        screen2.dart
  widgets/               # Global Reusable widgets
  theme/                 # App theme (colors)
  services/              # Firebase, API integration
  utils/                 # Global Functions used
  observer/              # Riverpod observer for all providers
```
