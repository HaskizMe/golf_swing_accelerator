import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/providers/account_notifier.dart';
import 'package:golf_accelerator_app/screens/profile/local_widget/profile_attribute.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import 'package:golf_accelerator_app/utils/error_dialog.dart';

import '../../../services/auth_service.dart';

class ProfileView extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  const ProfileView({super.key, required this.onTap});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {

  @override
  Widget build(BuildContext context) {
    // final account = ref.watch(accountProvider);
    final account = ref.watch(accountNotifierProvider);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () => widget.onTap(),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white
          ),
          child: const Text("Edit Profile"),
        ),
        const SizedBox(height: 20),
        if(account.displayName != null)
          Text("${account.displayName}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
        const SizedBox(height: 20),
        ProfileAttribute(title: "Display Name", data: account.displayName == null || account.displayName!.isEmpty ? "No Name" :"${account.displayName}"),
        const SizedBox(height: 10,),
        ProfileAttribute(title: "Email", data: "${account.email}"),
        const SizedBox(height: 10,),
        ProfileAttribute(title: "Height", data: "${account.heightFt} ft ${account.heightIn} in"),
        const SizedBox(height: 10,),
        ProfileAttribute(title: "Primary Hand", data: "${account.primaryHand}"),
        const SizedBox(height: 10,),
        ProfileAttribute(title: "Skill Level", data: "${account.skillLevel}"),
        //const SizedBox(height: 20),
        ListTile(
          onTap: () async {
            await AuthService.signout(ref);
          },
          leading: const Text(
            "Logout", style: TextStyle(fontSize: 16,
            color: Colors.red,),),
          trailing: const Icon(Icons.logout, color: Colors.red,),
        ),
        SizedBox(height: 30,),
        // Delete Account Button
        ElevatedButton(
          onPressed: () {
            showErrorDialogOptions(
                context: context,
                errorMessage: "Delete Account",
                solution: "Are you sure you want to delete your account? Your information will be deleted forever.",
                onTap: () {
                  FirestoreService.deleteAccount(context, ref);
                });
            // Delete account action
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text("Delete Account"),
        ),
      ],
    );
  }
}
