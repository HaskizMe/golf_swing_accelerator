import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/providers/account_notifier.dart';
import 'package:golf_accelerator_app/providers/bluetooth_notifier.dart';
import 'package:golf_accelerator_app/providers/swings_notifier.dart';
import 'package:golf_accelerator_app/screens/home/local_widgets/carousel_buttons.dart';
import 'package:golf_accelerator_app/screens/home/local_widgets/list_tile.dart';
import 'package:golf_accelerator_app/screens/home/local_widgets/swing_card.dart';
import 'package:golf_accelerator_app/screens/profile/local_widget/profile_picture.dart';
import 'package:golf_accelerator_app/screens/profile/profile.dart';
import 'package:golf_accelerator_app/services/auth_service.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import 'package:golf_accelerator_app/widgets/custom_button.dart';
import 'package:golf_accelerator_app/widgets/flat_button.dart';
import '../../models/bluetooth.dart';
import '../../theme/app_colors.dart';
import '../debug/debug.dart';
import '../login/login.dart';
import '../results/results.dart';
import '../scan/scan.dart';
import '../swing/swing.dart';
import '../swing_result/swing_result.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String firstName = "";

  @override
  Widget build(BuildContext context) {
    //final account = ref.watch(accountProvider);
    final account = ref.watch(accountNotifierProvider);
    final swings = ref.watch(swingsNotifierProvider);
    if (account.displayName != null) {
      List<String> nameParts = account.displayName!.split(' ');
      // Assign firstName and lastName
      firstName = nameParts.isNotEmpty ? nameParts[0] : '';

    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        leadingWidth: MediaQuery.of(context).size.width * 0.7, // Adjust dynamically based on screen width
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Container(
            //color: Colors.red,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// If there is no display name just show Welcome Back!
                if (firstName.isEmpty)
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis, // Handles overflow gracefully
                    ),
                  )

                /// If there is a display name then we say welcome back with their name
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Welcome",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis, // Handles overflow gracefully
                        ),
                      ),
                      Text(
                        "Back, $firstName!",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis, // Handles overflow gracefully
                        ),
                      ),
                    ],
                  )
              ],
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              /// This allows me to switch tabs in the bottom navigation
              BottomNavigationBar navigationBar =  bottomNavigatorKey.currentWidget as BottomNavigationBar;
              navigationBar.onTap!(4);
            }, child: ProfilePicture(size: 60)
          ),
          const SizedBox(width: 10),
        ],
        flexibleSpace: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              width: constraints.maxWidth,
              height: constraints.maxHeight,
              decoration: const BoxDecoration(
                //color: AppColors.forestGreen
              ),
            );
          },
        ),
      ),

      /// Main content of page
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              /// Golfer logo
              Center(child: SvgPicture.asset("assets/homeIcon.svg", width: 220)),
              const SizedBox(height: 40),

              /// Quick Start text
              const Text(
                "Quick Start:",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              /// Quick Start buttons row
              Row(
                children: [
                  Expanded(
                    child: CustomButton(title: "Scan For Device", onTap: () {
                      /// This allows me to switch tabs in the bottom navigation
                      BottomNavigationBar navigationBar =  bottomNavigatorKey.currentWidget as BottomNavigationBar;
                      navigationBar.onTap!(2);
                    }),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CustomButton(title: "Start Swinging", onTap: () {
                      /// This allows me to switch tabs in the bottom navigation
                      BottomNavigationBar navigationBar =  bottomNavigatorKey.currentWidget as BottomNavigationBar;
                      navigationBar.onTap!(1);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              /// Recent swings text and see more button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recent Swings:",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      /// This allows me to switch tabs in the bottom navigation
                      BottomNavigationBar navigationBar =  bottomNavigatorKey.currentWidget as BottomNavigationBar;
                      navigationBar.onTap!(3);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.forestGreen, // Font color
                      overlayColor: AppColors.forestGreen, // Overlay color
                    ),
                    child: const Text(
                      "See More",
                      style: TextStyle(
                        decoration: TextDecoration.underline, // Adds underline
                        decorationColor: AppColors.forestGreen,
                        fontSize: 16, // Optional: Adjust font size
                        fontWeight: FontWeight.bold, // Optional: Adjust font weight
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Swings Section
              if (swings.isNotEmpty)
                SizedBox(
                  height: 120, // Fixed height for horizontal scrolling
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal, // Enables horizontal scrolling
                    itemCount: min(swings.length, 10),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SwingResultScreen(quickView: false, swing: swings[index],),
                          ),
                        ),
                          child: SwingCard(swing: swings[index])
                      );
                    },
                  ),
                )
              else
                const Center(
                  child: Column(
                    children: [
                      Text("NO SWINGS YET", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              const SizedBox(height: 40),

              // ElevatedButton(onPressed: () {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => DebugScreen(deviceName: "Test",),
              //     ),
              //   );
              // }, child: Text("test"))
            ],
          ),
        ),
      ),
    );
  }
}


var bottomNavigatorKey = GlobalKey<State<BottomNavigationBar>>();



class HomeNavigationWrapper extends ConsumerStatefulWidget {
  const HomeNavigationWrapper({super.key});

  @override
  ConsumerState<HomeNavigationWrapper> createState() => _HomeNavigationWrapperState();
}

class _HomeNavigationWrapperState extends ConsumerState<HomeNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SwingScreen(),
    const ScanScreen(),
    const ResultsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Display the current screen
      bottomNavigationBar: BottomNavigationBar(
        key: bottomNavigatorKey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.platinum,
        selectedItemColor: AppColors.forestGreen,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_golf),
            label: "Swing",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth_audio_outlined),
            label: "Scan",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.area_chart),
            label: "Results",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: "Account",
          ),
        ],
      ),
    );
  }
}

