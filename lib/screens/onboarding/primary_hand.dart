import 'package:cupertino_height_picker/cupertino_height_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/screens/onboarding/calibrate_club.dart';
import 'package:golf_accelerator_app/screens/onboarding/local_widgets/primary_hand_button.dart';
import 'package:golf_accelerator_app/utils/error_dialog.dart';
import '../../theme/app_colors.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class PrimaryHand extends ConsumerStatefulWidget {
  const PrimaryHand({super.key});

  @override
  ConsumerState<PrimaryHand> createState() => _PrimaryHandState();
}

class _PrimaryHandState extends ConsumerState<PrimaryHand> {
  final TextEditingController _heightController = TextEditingController();
  String selectedHand = ""; // Stores the selected hand: "Left" or "Right"
  int? feet;
  int? inches;

  @override
  void dispose() {
    _heightController.dispose();
    super.dispose();
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
    final account = ref.watch(accountProvider);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the back button color to white
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "The Club needs to be",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "calibrated first",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  const Text(
                    "Select your primary hand",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomPrimaryHandButton(
                        image: SvgPicture.asset("assets/leftHand.svg"),
                        title: "Left",
                        isSelected: selectedHand == "Left",
                        onTap: () {
                          setState(() {
                            selectedHand = "Left";
                          });
                        },
                      ),
                      const SizedBox(width: 20),
                      CustomPrimaryHandButton(
                        image: SvgPicture.asset("assets/rightHand.svg"),
                        title: "Right",
                        isSelected: selectedHand == "Right",
                        onTap: () {
                          setState(() {
                            selectedHand = "Right";
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    "Input your Height",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: 200,
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _heightController,
                      readOnly: true,
                      onTap: () async {
                        await showCupertinoHeightPicker(
                          context: context,
                          onHeightChanged: (cm) {
                            setState(() {
                              _heightController.text = _convertHeightToFeetInches(cm);
                            });
                          },
                        );
                      },
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white), // Always white
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white), // Always white
                        ),
                        hintText: "Height",
                        hintStyle: const TextStyle(color: Colors.white),
                        fillColor: Colors.white,
                        filled: false,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        if(feet != null && inches != null && selectedHand.isNotEmpty) {
                          ref.read(accountProvider.notifier).setHeight(feet!, inches!);
                          ref.read(accountProvider.notifier).setPrimaryHand(selectedHand);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const CalibrateClub()));
                        } else {
                          showErrorDialog(context: context, errorMessage: "Incomplete Information", solution: "Please ensure that both your primary hand and height are entered to proceed.");
                        }
                        },
                      style: ElevatedButton.styleFrom(
                        overlayColor: Colors.black,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text(
                        "Next",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}