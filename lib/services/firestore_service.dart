import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  Future<void> initializeUserInFirestore(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Check if the user document exists
    final docSnapshot = await userDoc.get();
    if (!docSnapshot.exists) {
      // Create a new document with initial fields
      await userDoc.set({
        'onboardingComplete': false,
        'displayName': user.displayName,
        'email': user.email,
        // Add any other initial fields you need
      });
    }
  }
}