import 'package:flutter/material.dart';
import 'package:golf_accelerator_app/screens/profile/local_widget/profile_picture.dart';
import '../../theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Profile attributes
  double? _height = 180.0;
  String? _primaryHand = "Right";
  String? _skillLevel = "Intermediate";
  String? _displayName = "John Doe";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
        title: const Text("Profile", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
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
                  color: AppColors.blue, // Background color
                ),
              ),
              // Profile picture
              Positioned(
                bottom: -40, // Overlap the profile picture
                left: MediaQuery.of(context).size.width / 2 - 50, // Center the picture
                child: ProfilePicture(),
              ),
            ],
          ),
          // Spacing after the profile picture
          const SizedBox(height: 60),
          // Additional content in a column
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    _displayName ?? "N/A",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Profile attributes with edit icons
                  _buildProfileAttribute(
                    "Display Name",
                    _displayName,
                        () => _editField(
                      context,
                      "Edit Display Name",
                      _displayName,
                          (value) => setState(() => _displayName = value),
                    ),
                  ),
                  _buildProfileAttribute(
                    "Height",
                    "${_height?.toStringAsFixed(1)} cm",
                        () => _editField(
                      context,
                      "Edit Height",
                      _height?.toString(),
                          (value) => setState(() => _height = double.tryParse(value)),
                    ),
                  ),
                  _buildProfileAttribute(
                    "Primary Hand",
                    _primaryHand,
                        () => _editField(
                      context,
                      "Edit Primary Hand",
                      _primaryHand,
                          (value) => setState(() => _primaryHand = value),
                    ),
                  ),
                  _buildProfileAttribute(
                    "Skill Level",
                    _skillLevel,
                        () => _editField(
                      context,
                      "Edit Skill Level",
                      _skillLevel,
                          (value) => setState(() => _skillLevel = value),
                    ),
                  ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget for profile attributes with edit icons
  Widget _buildProfileAttribute(String title, String? value, VoidCallback onEdit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "N/A",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  // Edit field dialog
  void _editField(BuildContext context, String title, String? initialValue, Function(String) onSave) {
    final TextEditingController controller = TextEditingController(text: initialValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context); // Save and close dialog
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }
}