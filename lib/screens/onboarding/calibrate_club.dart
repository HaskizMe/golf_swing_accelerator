import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/providers/account_notifier.dart';
import 'package:golf_accelerator_app/screens/home/home.dart';
import 'package:golf_accelerator_app/services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../../theme/app_colors.dart';

class CalibrateClub extends ConsumerStatefulWidget {
  const CalibrateClub({super.key});

  @override
  ConsumerState<CalibrateClub> createState() => _CalibrateClubState();
}

class _CalibrateClubState extends ConsumerState<CalibrateClub> {
  bool _isTapped = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isTapped = true;
    });
  }

  Future<void> _onTapUp(TapUpDetails details) async {
    //final account = ref.read(accountProvider.notifier);
    final account = ref.read(accountNotifierProvider.notifier);

    setState(() => _isTapped = false);

    account.setCalibrated(true);
    String? skillLevel = account.skillLevel;
    String? primaryHand = account.primaryHand;
    double? heightInCm = account.height;
    bool onBoardingIsComplete = false;
    if(skillLevel != null && primaryHand != null && heightInCm != null){
      onBoardingIsComplete = true;
    }

    await FirestoreService.updateUserProperties({
      'skillLevel': skillLevel,
      'primaryHand': primaryHand,
      'onboardingComplete': onBoardingIsComplete,
      'heightCm': heightInCm,
    });

    if(!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const HomeNavigationWrapper()),
          (Route<dynamic> route) => false, // This condition removes all previous routes.
    );
  }

  void _onTapCancel() {
    setState(() {
      _isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.forestGreen,
      appBar: AppBar(
        backgroundColor: AppColors.forestGreen,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Calibrate with SVG",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(-1.0, 1.0), // Flip on the X-axis
                child: SvgPicture.asset(
                  "assets/Vector.svg",
                  height: 300,
                  colorFilter: _isTapped
                      ? ColorFilter.mode(Colors.black.withOpacity(.2), BlendMode.srcIn)
                      : const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}