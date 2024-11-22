import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/screens/profile/local_widget/profile_attribute.dart';

class ProfileView extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  const ProfileView({super.key, required this.onTap});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => widget.onTap(),
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white
          ),
          child: Text("Edit Profile"),
        ),
        const SizedBox(height: 20),
        Text("${account.displayName}", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),),
        const SizedBox(height: 20),
        ProfileAttribute(title: "Display Name", data: "${account.displayName}"),
        const SizedBox(height: 10,),
        ProfileAttribute(title: "Email", data: "${account.email}"),
        const SizedBox(height: 10,),
        ProfileAttribute(title: "Height", data: "${account.heightFt} ft ${account.heightIn} in"),
        const SizedBox(height: 10,),
        ProfileAttribute(title: "Primary Hand", data: "${account.primaryHand}"),
        const SizedBox(height: 10,),
        ProfileAttribute(title: "Skill Level", data: "${account.skillLevel}"),
        const SizedBox(height: 20),
        // Delete Account Button
        ElevatedButton(
          onPressed: () {
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