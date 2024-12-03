import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_accelerator_app/models/account.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/providers/swings.dart';
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
import '../recalibrate/recalibrate.dart';
import '../results/results.dart';
import '../scan/scan.dart';
import '../swing/swing.dart';
import '../swing_result/swing_result.dart';

// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends ConsumerState<HomeScreen> {
//   final _auth = AuthService();
//
//   // Define the carousel screens and associated navigation actions
//   final Map<String, Widget> carouselScreens = {
//     'Scan': Transform(
//       alignment: Alignment.center,
//       transform: Matrix4.identity()..scale(-1.0, 1.0),
//       child: SvgPicture.asset("assets/Vector.svg", height: 200),
//     ),
//     'Swing': Image.asset('assets/resultsCarousel.png'),
//     'Recalibrate': Image.asset('assets/swingCarousel.png'),
//     'Results': Image.asset('assets/resultsCarousel.png'),
//     'Debug': Image.asset('assets/resultsCarousel.png'),
//   };
//
//   final List<Widget> screenWidgets = [
//     ScanScreen(),
//     SwingScreen(),
//     RecalibrateScreen(),
//     ResultsScreen(),
//     DebugScreen(),
//   ];
//
//   late double buttonOffset;
//   bool _isTapped = false;
//
//   final CarouselController _carouselController = CarouselController(initialItem: 0);
//   int currentIndex = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _carouselController.addListener(_scrollListener); // Listen for scroll updates
//   }
//
//   @override
//   void dispose() {
//     _carouselController.removeListener(_scrollListener); // Clean up the listener
//     super.dispose();
//   }
//
//   void _scrollListener() {
//     // Calculate the current index based on the offset
//     int newIndex = (_carouselController.offset / buttonOffset).round();
//     if (newIndex != currentIndex) {
//       setState(() {
//         currentIndex = newIndex % carouselScreens.length; // Keep the index within bounds
//       });
//     }
//   }
//
//   void _onTapDown(TapDownDetails details) {
//     setState(() {
//       _isTapped = true;
//     });
//   }
//
//   void _onTapCancel() {
//     setState(() {
//       _isTapped = false;
//     });
//   }
//
//   void _previousItem() {
//     setState(() {
//       if (currentIndex > 0) {
//         currentIndex--;
//       } else {
//         currentIndex = carouselScreens.length - 1; // Loop back to the last item
//       }
//       _carouselController.animateTo(
//         buttonOffset * currentIndex,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     });
//   }
//
//   void _nextItem() {
//     setState(() {
//       if (currentIndex < carouselScreens.length - 1) {
//         currentIndex++;
//       } else {
//         currentIndex = 0; // Loop back to the first item
//       }
//       _carouselController.animateTo(
//         buttonOffset * currentIndex,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     buttonOffset = MediaQuery.of(context).size.width - 60;
//     return Container(
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           colors: [AppColors.silverLakeBlue, AppColors.skyBlue],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Stack(
//         children: [
//           Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               iconTheme: const IconThemeData(
//                 color: Colors.white,
//               ),
//               actions: [
//                 Builder(
//                   builder: (BuildContext context) {
//                     return GestureDetector(
//                       onTapDown: _onTapDown,
//                       onTap: () {
//                         setState(() {
//                           _isTapped = false;
//                         });
//                         Scaffold.of(context).openEndDrawer();
//                       },
//                       onTapCancel: _onTapCancel,
//                       child: SvgPicture.asset(
//                         "assets/drawerIcon.svg",
//                         colorFilter: _isTapped
//                             ? ColorFilter.mode(
//                             Colors.black.withOpacity(0.2), BlendMode.srcIn)
//                             : null,
//                       ),
//                     );
//                   },
//                 ),
//                 const SizedBox(width: 10),
//               ],
//             ),
//
//             /// Main content of page
//             body: Center(
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
//                 child: Column(
//                   children: [
//                     SvgPicture.asset("assets/homeIcon.svg", width: 220),
//                     const SizedBox(height: 40),
//
//                     /// Right and left arrows
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ElevatedButton(
//                           onPressed: _previousItem,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.carolinaBlue,
//                             overlayColor: Colors.black,
//                           ),
//                           child: SvgPicture.asset("assets/Left.svg"),
//                         ),
//                         ElevatedButton(
//                           onPressed: _nextItem,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.carolinaBlue,
//                             overlayColor: Colors.black,
//                           ),
//                           child: SvgPicture.asset("assets/Right.svg"),
//                         ),
//                       ],
//                     ),
//
//                     /// Carousel Buttons
//                     const SizedBox(height: 40),
//                     Expanded(
//                       child: SizedBox(
//                         child: CarouselView(
//                           onTap: (int index) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => screenWidgets[index],
//                               ),
//                             );
//                           },
//                           padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
//                           controller: _carouselController,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           backgroundColor: Colors.transparent,
//                           itemSnapping: true,
//                           itemExtent: double.infinity,
//                           children: carouselScreens.entries.map((carouselButton) {
//                             return CustomCarouselButton(
//                               title: carouselButton.key,
//                               image: carouselButton.value,
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//
//             /// This handles the drawer on the top right of the screen
//             endDrawer: Drawer(
//               backgroundColor: AppColors.babyBlue,
//               child: Padding(
//                 padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     CustomListTile(
//                         title: "Profile", navigation: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(),),)),
//                     CustomListTile(
//                         title: "Account Settings",
//                         navigation: () => Navigator.pop(context)),
//                     CustomListTile(
//                         title: "Swing History",
//                         navigation: () => Navigator.pop(context)),
//                     CustomListTile(
//                         title: "Recalibrate Swing",
//                         navigation: () => Navigator.pop(context)),
//                     CustomListTile(
//                         title: "Disconnect", navigation: () => Navigator.pop(context)),
//                     ListTile(
//                       title: const Text(
//                         "Log Out",
//                         style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//                       ),
//                       trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.red),
//                       splashColor: Colors.red.withOpacity(.3),
//                       onTap: () async {
//                         print("log out");
//                         await _auth.signout();
//                       },
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String firstName = "";

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
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



class HomeNavigationWrapper extends StatefulWidget {
  const HomeNavigationWrapper({super.key});

  @override
  State<HomeNavigationWrapper> createState() => _HomeNavigationWrapperState();
}

class _HomeNavigationWrapperState extends State<HomeNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const SwingScreen(),
    const ScanScreen(),
    const ResultsScreen(),
    const ProfileScreen(),
  ];

  void switchTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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

