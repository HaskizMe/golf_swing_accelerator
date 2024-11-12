import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/bluetooth.dart';
import 'package:golf_accelerator_app/screens/home/home.dart';
import 'package:golf_accelerator_app/screens/swing_result/swing_result.dart';
import '../../theme/app_colors.dart';

class SwingScreen extends ConsumerStatefulWidget {
  const SwingScreen({super.key});

  @override
  ConsumerState<SwingScreen> createState() => _SwingScreenState();
}

class _SwingScreenState extends ConsumerState<SwingScreen> {
  @override
  initState() {
    super.initState();
    _initialize();
  }
  @override
  dispose() {
    super.dispose();
    //_dispose();
  }

  void _initialize() {
    print("Init");
    BluetoothDevice? device = ref.read(bluetoothProvider).myConnectedDevice;
    if(device != null){
      ref.read(bluetoothProvider.notifier).setupListeners(device);
    } else {
      print("Null");
    }
  }
  // void _dispose() {
  //   print("dispose");
  //   ref.read(bluetoothProvider.notifier).cancelNotificationsSubscription();
  // }



  @override
  Widget build(BuildContext context) {
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width - 20;

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
          leading: IconButton(onPressed: () {
            ref.read(bluetoothProvider.notifier).cancelNotificationsSubscription();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }, icon: const Icon(Icons.arrow_back)),
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                ref.read(bluetoothProvider.notifier).cancelNotificationsSubscription();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SwingResultScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                side: const BorderSide(color: Colors.white, width: 2), // Set your desired border color here
              ),
              child: const Text("Results"),
            ),
            const SizedBox(width: 10,)
          ],
        ),
        body: Stack(
          children: [
            Align(
              alignment: const Alignment(0.0, -0.3), // Slightly above center
              child: Column(
                mainAxisSize: MainAxisSize.min, // Centers and minimizes the column height
                children: [
                  const Text(
                    "Swing when ready",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 45),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular((windowHeight * 0.7) / 2),
                    ),
                    height: windowWidth,
                    width: windowWidth,
                    alignment: Alignment.center,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(240),
                      ),
                      height: windowWidth * 0.8,
                      width: windowWidth * 0.8,
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(240),
                        ),
                        height: windowWidth * 0.6,
                        width: windowWidth * 0.6,
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(240),
                          ),
                          height: windowWidth * 0.4,
                          width: windowWidth * 0.4,
                          alignment: Alignment.center,
                          child: const Text(
                            'SWING',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}