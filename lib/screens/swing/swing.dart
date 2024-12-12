import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/bluetooth.dart';
import 'package:golf_accelerator_app/providers/bluetooth_provider.dart';
import 'package:golf_accelerator_app/providers/device_collecting_status.dart';
import 'package:golf_accelerator_app/providers/swings.dart';
import 'package:golf_accelerator_app/screens/swing_result/swing_result.dart';
import '../../theme/app_colors.dart';

class SwingScreen extends ConsumerStatefulWidget {
  const SwingScreen({super.key});

  @override
  ConsumerState<SwingScreen> createState() => _SwingScreenState();
}

class _SwingScreenState extends ConsumerState<SwingScreen> {
  //final _ble = BluetoothModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialize();
    });
  }


  @override
  dispose() {
    print("Page Disposed");
    //_ble.cancelNotificationsSubscription();
    super.dispose();
  }

  @override
  void deactivate() {
    ref.read(bluetoothNotifierProvider.notifier).cancelNotificationsSubscription();
    print("Deactivating");
    super.deactivate();
  }


  void _initialize() {
    final ble = ref.read(bluetoothNotifierProvider.notifier);
    print("Init");
    // BluetoothDevice? device = _ble.myConnectedDevice;
    BluetoothDevice? device = ref.read(bluetoothNotifierProvider).connectedDevice;
    if (device != null) {
      ble.setupListeners(device, context);

      //_ble.setupListeners(device, ref);
    } else {
      print("Null");
    }
  }

  @override
  Widget build(BuildContext context) {
    final swings = ref.watch(swingsNotifierProvider);
    final loader = ref.watch(deviceCollectingStatusProvider); // Tracks loading state
    double windowHeight = MediaQuery.of(context).size.height;
    double windowWidth = MediaQuery.of(context).size.width - 20;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          print("did pop");

          return;
        }
        print("Popping");
        //final bool shouldPop = await _showBackDialog() ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          actions: [
            if (swings.isNotEmpty)
              Row(
                children: [

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SwingResultScreen(quickView: false, swing: swings.first,),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestGreen,
                      foregroundColor: Colors.white
                    ),
                    child: const Text("Last Swing"),
                  ),
                  // OutlinedButton(
                  //   onPressed: () {
                  //     ref.read(bluetoothProvider.notifier).cancelNotificationsSubscription();
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => SwingResultScreen(quickView: false, swing: swings.last,),
                  //       ),
                  //     );
                  //   },
                  //   style: OutlinedButton.styleFrom(
                  //     foregroundColor: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     side: const BorderSide(color: Colors.white, width: 2),
                  //   ),
                  //   child: const Text("Last Swing"),
                  // ),
                  const SizedBox(width: 10),
                ],
              ),
          ],
        ),
        body:

        Stack(
          children: [
            // Main content
            Align(
              alignment: const Alignment(0.0, -0.3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Swing your club when ready",
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColors.forestGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 45),
                  Image.asset("assets/golf swing.jpg")
                  // ElevatedButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => const SwingResultScreen(quickView: true),
                  //       ),
                  //     );
                  //   },
                  //   child: const Text("Test"),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.white, width: 2),
                  //     borderRadius: BorderRadius.circular((windowHeight * 0.7) / 2),
                  //   ),
                  //   height: windowWidth,
                  //   width: windowWidth,
                  //   alignment: Alignment.center,
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       border: Border.all(color: Colors.white, width: 2),
                  //       borderRadius: BorderRadius.circular(360),
                  //     ),
                  //     height: windowWidth * 0.8,
                  //     width: windowWidth * 0.8,
                  //     alignment: Alignment.center,
                  //     child: Container(
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.white, width: 2),
                  //         borderRadius: BorderRadius.circular(240),
                  //       ),
                  //       height: windowWidth * 0.6,
                  //       width: windowWidth * 0.6,
                  //       alignment: Alignment.center,
                  //       child: Container(
                  //         decoration: BoxDecoration(
                  //           border: Border.all(color: Colors.white, width: 2),
                  //           borderRadius: BorderRadius.circular(240),
                  //         ),
                  //         height: windowWidth * 0.4,
                  //         width: windowWidth * 0.4,
                  //         alignment: Alignment.center,
                  //         child: const Text(
                  //           'SWING',
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // Loader overlay
            if (loader)
              Container(
                color: Colors.black54, // Semi-transparent background
                alignment: Alignment.center,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}