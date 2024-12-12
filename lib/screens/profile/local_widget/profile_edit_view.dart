import 'package:cupertino_height_picker/cupertino_height_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/providers/account_provider.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import 'package:golf_accelerator_app/widgets/height_picker.dart';
import 'package:golf_accelerator_app/widgets/text_field.dart';

import '../../../theme/app_colors.dart';

class ProfileEditView extends ConsumerStatefulWidget {
  final VoidCallback onTap;
  const ProfileEditView({super.key, required this.onTap});

  @override
  ConsumerState<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends ConsumerState<ProfileEditView> {
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _height = TextEditingController();
  int? feet;
  int? inches;
  double? totalHeightInCm;
  String _selectedSkillLevel = "Beginner"; // Default value for skill level dropdown
  String _selectedHand = "Right"; // Default value for primary hand toggle

  @override
  void initState() {
    super.initState();

    // Initialize based on accountProvider
// Initialize based on accountProvider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //final account = ref.read(accountProvider);
      final account = ref.read(accountNotifierProvider);

      setState(() {
        _selectedSkillLevel = account.skillLevel ?? "Beginner";
        _selectedHand = account.primaryHand ?? "Right";

        // Initialize text controllers if account data exists
        if (account.displayName != null) {
          List<String> nameParts = account.displayName!.split(' ');
          _firstName.text = nameParts.isNotEmpty ? nameParts[0] : '';
          _lastName.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
        }

        if (account.heightFt != null && account.heightIn != null) {
          _height.text = "${account.heightFt} ft ${account.heightIn} in";
        }
      });
    });
  }

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _height.dispose();
    super.dispose();
  }

  Future<void> updateAccount() async {
    Map<String, dynamic> updates = {};

    // Add non-empty fields to the updates map
    if (_firstName.text.isNotEmpty || _lastName.text.isNotEmpty) {
      print(_firstName.text);
      print(_lastName.text);
      updates["displayName"] = "${_firstName.text.trim()} ${_lastName.text.trim()}";
    }
    if (totalHeightInCm != null) {
      updates["heightCm"] = totalHeightInCm;
    }
    if (_selectedSkillLevel.isNotEmpty) {
      updates["skillLevel"] = _selectedSkillLevel;
    }
    if (_selectedHand.isNotEmpty) {
      updates["primaryHand"] = _selectedHand;
    }

    if (updates.isNotEmpty) {
      try {
        await FirestoreService.updateAccountFields(updates);
        print("Account updated successfully!");
      } catch (e) {
        print("Failed to update account: $e");
      }
    }

    widget.onTap();
  }


  // Function to convert height from cm to ft and in format
  String _convertHeightToFeetInches(double cm) {
    final totalInches = (cm / 2.54).round(); // Convert cm to inches
    feet = totalInches ~/ 12; // Get the feet part
    inches = totalInches % 12; // Get the remaining inches
    return "$feet ft $inches in";
  }


  @override
  Widget build(BuildContext context) {
    // final account = ref.watch(accountProvider);
    final account = ref.watch(accountNotifierProvider);


    // Assign the display name to the text fields
    // if (account.displayName != null) {
    //   List<String> nameParts = account.displayName!.split(' ');
    //   // Assign firstName and lastName
    //   _firstName.text = nameParts.isNotEmpty ? nameParts[0] : '';
    //   _lastName.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    // }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: [
          // First Name and Last Name on the same row
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: () => widget.onTap(), icon: Icon(Icons.arrow_back)),
              //ElevatedButton(onPressed: () {}, child: Text("Cancel")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // First Name Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("First Name"),
                        CustomTextField(
                          hintText: "First Name",
                          controller: _firstName,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10), // Spacing between columns
                  // Last Name Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Last Name"),
                        CustomTextField(
                          hintText: "Last Name",
                          controller: _lastName,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // Spacing below the row

              // Height Field
              const Text("Height"),
              CustomTextField(
                hintText: "${account.heightFt} ft ${account.heightIn} in",
                controller: _height,
                readOnly: true,
                onTap: () async => await showCupertinoHeightPicker(
                context: context,
                onHeightChanged: (cm) {
                  setState(() {
                    _height.text = _convertHeightToFeetInches(cm);
                    totalHeightInCm = cm;
                  });
                },
              )
              ),
              const SizedBox(height: 20),

              // Skill Level Dropdown
              const Text("Skill Level"),
              DropdownButtonFormField<String>(
                value: _selectedSkillLevel,
                dropdownColor: Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: Colors.grey, // Default border color
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.forestGreen, // Enabled border color
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: const BorderSide(
                      color: AppColors.forestGreen, // Focused border color
                      width: 2.0,
                    ),
                  ),
                ),
                items: ["Beginner", "Moderate", "Advanced"]
                    .map((level) => DropdownMenuItem(
                    value: level,
                    child: Text(level),
                  ),
                ).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSkillLevel = value!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Primary Hand Toggle Buttons
              const Text("Primary Hand"),
              const SizedBox(height: 10,),
              Center(
                child: LayoutBuilder(
                    builder: (context, constraints) => ToggleButtons(
                      color: Colors.black,
                      selectedColor: Colors.white,
                      fillColor: AppColors.forestGreen,
                      constraints: BoxConstraints.expand(width: constraints.maxWidth/2 - 20),
                      isSelected: [_selectedHand == "Left", _selectedHand == "Right"],
                      onPressed: (index) {
                        setState(() {
                          _selectedHand = index == 0 ? "Left" : "Right";
                          print(_selectedHand);
                        });
                      },
                      children: const [
                        Text("Left"),
                        Text("Right"),
                      ],
                    ),
                )
              ),
              const SizedBox(height: 20),
            ],
          ),
          // Update Button
          SizedBox(
            width: 200,
            child: ElevatedButton(
              onPressed: () => updateAccount(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Set border radius here
                ),
              ),
              child: const Text("Update"),
            ),
          ),
        ],
      ),
    );
  }
}