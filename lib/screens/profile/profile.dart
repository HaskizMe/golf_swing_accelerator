import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/screens/profile/local_widget/profile_attribute.dart';
import 'package:golf_accelerator_app/screens/profile/local_widget/profile_edit_view.dart';
import 'package:golf_accelerator_app/screens/profile/local_widget/profile_picture.dart';
import 'package:golf_accelerator_app/screens/profile/local_widget/profile_view.dart';
import '../../theme/app_colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool isEditing = false;
  // Profile attributes

  @override
  Widget build(BuildContext context) {
    //final account = ref.watch(accountProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.forestGreen,
      ),
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Stack for the background and overlapping profile picture
          Stack(
            clipBehavior: Clip.none, // Allows the profile picture to overlap
            children: [
              // Background image or color
              Container(
                width: double.infinity,
                height: 100, // Height of the background
                decoration: const BoxDecoration(
                  color: AppColors.forestGreen, // Background color
                ),
              ),
              // Profile picture
              Positioned(
                bottom: -40, // Overlap the profile picture
                left: MediaQuery.of(context).size.width / 2 - 50, // Center the picture
                child: const ProfilePicture(size: 100,),
              ),
            ],
          ),
          // Spacing after the profile picture
          const SizedBox(height: 60),
          // Additional content in a column
          Expanded(
            child: SingleChildScrollView(
              child: isEditing
                  ? ProfileEditView(onTap: () => setState(() => isEditing = false))
                  : ProfileView(onTap: () => setState(() => isEditing = true))
            ),
          ),
        ],
      ),
    );
  }
}