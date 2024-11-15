import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/screens/home/local_widgets/carousel_buttons.dart';
import 'package:golf_accelerator_app/screens/home/local_widgets/list_tile.dart';
import 'package:golf_accelerator_app/services/auth_service.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import '../../models/bluetooth.dart';
import '../../theme/app_colors.dart';
import '../debug/debug.dart';
import '../login/login.dart';
import '../recalibrate/recalibrate.dart';
import '../results/results.dart';
import '../scan/scan.dart';
import '../swing/swing.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _auth = AuthService();

  // Define the carousel screens and associated navigation actions
  final Map<String, Widget> carouselScreens = {
    'Scan': Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scale(-1.0, 1.0),
      child: SvgPicture.asset("assets/Vector.svg", height: 200),
    ),
    'Swing': Image.asset('assets/resultsCarousel.png'),
    'Recalibrate': Image.asset('assets/swingCarousel.png'),
    'Results': Image.asset('assets/resultsCarousel.png'),
    'Debug': Image.asset('assets/resultsCarousel.png'),
  };

  final List<Widget> screenWidgets = [
    ScanScreen(),
    SwingScreen(),
    RecalibrateScreen(),
    ResultsScreen(),
    DebugScreen(),
  ];

  late double buttonOffset;
  bool _isTapped = false;

  final CarouselController _carouselController = CarouselController(initialItem: 0);
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carouselController.addListener(_scrollListener); // Listen for scroll updates
  }

  @override
  void dispose() {
    _carouselController.removeListener(_scrollListener); // Clean up the listener
    super.dispose();
  }

  void _scrollListener() {
    // Calculate the current index based on the offset
    int newIndex = (_carouselController.offset / buttonOffset).round();
    if (newIndex != currentIndex) {
      setState(() {
        currentIndex = newIndex % carouselScreens.length; // Keep the index within bounds
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isTapped = true;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isTapped = false;
    });
  }

  void _previousItem() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
      } else {
        currentIndex = carouselScreens.length - 1; // Loop back to the last item
      }
      _carouselController.animateTo(
        buttonOffset * currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _nextItem() {
    setState(() {
      if (currentIndex < carouselScreens.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0; // Loop back to the first item
      }
      _carouselController.animateTo(
        buttonOffset * currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    buttonOffset = MediaQuery.of(context).size.width - 60;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              actions: [
                Builder(
                  builder: (BuildContext context) {
                    return GestureDetector(
                      onTapDown: _onTapDown,
                      onTap: () {
                        setState(() {
                          _isTapped = false;
                        });
                        Scaffold.of(context).openEndDrawer();
                      },
                      onTapCancel: _onTapCancel,
                      child: SvgPicture.asset(
                        "assets/drawerIcon.svg",
                        colorFilter: _isTapped
                            ? ColorFilter.mode(
                            Colors.black.withOpacity(0.2), BlendMode.srcIn)
                            : null,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
              ],
            ),

            /// Main content of page
            body: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 0, 30, 50),
                child: Column(
                  children: [
                    SvgPicture.asset("assets/homeIcon.svg", width: 220),
                    const SizedBox(height: 40),

                    /// Right and left arrows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _previousItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lighterBlue,
                            overlayColor: Colors.black,
                          ),
                          child: SvgPicture.asset("assets/Left.svg"),
                        ),
                        ElevatedButton(
                          onPressed: _nextItem,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lighterBlue,
                            overlayColor: Colors.black,
                          ),
                          child: SvgPicture.asset("assets/Right.svg"),
                        ),
                      ],
                    ),

                    /// Carousel Buttons
                    const SizedBox(height: 40),
                    // ElevatedButton(onPressed: () async {
                    //   FirestoreService test = FirestoreService();
                    //   SwingData s1 = SwingData(speed: 100, swingPoints: [0,35,22,5,1,22,5]);
                    //   SwingData s2 = SwingData(speed: 120, swingPoints: [1,33,22,1,1,22,2]);
                    //   SwingData s3 = SwingData(speed: 130, swingPoints: [2,33,22,1,1,22,2]);
                    //   SwingData s4 = SwingData(speed: 60, swingPoints: [3,33,22,1,1,22,2]);
                    //
                    //   await test.addSwing(s1);
                    //   await test.addSwing(s2);
                    //
                    //   await test.addSwing(s3);
                    //   await test.addSwing(s4);
                    //
                    // }, child: Text("Test")),
                    Expanded(
                      child: SizedBox(
                        child: CarouselView(
                          onTap: (int index) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => screenWidgets[index],
                              ),
                            );
                          },
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          controller: _carouselController,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.transparent,
                          itemSnapping: true,
                          itemExtent: double.infinity,
                          children: carouselScreens.entries.map((carouselButton) {
                            return CustomCarouselButton(
                              title: carouselButton.key,
                              image: carouselButton.value,
                            );
                          }).toList(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            /// This handles the drawer on the top right of the screen
            endDrawer: Drawer(
              backgroundColor: AppColors.lightererBlue,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    CustomListTile(
                        title: "Profile", navigation: () => Navigator.pop(context)),
                    CustomListTile(
                        title: "Account Settings",
                        navigation: () => Navigator.pop(context)),
                    CustomListTile(
                        title: "Swing History",
                        navigation: () => Navigator.pop(context)),
                    CustomListTile(
                        title: "Recalibrate Swing",
                        navigation: () => Navigator.pop(context)),
                    CustomListTile(
                        title: "Disconnect", navigation: () => Navigator.pop(context)),
                    ListTile(
                      title: const Text(
                        "Log Out",
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.red),
                      splashColor: Colors.red.withOpacity(.3),
                      onTap: () async {
                        print("log out");
                        await _auth.signout();
                        // Navigator.pop(context);
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                        //       (Route<dynamic> route) => false, // This condition removes all previous routes.
                        // );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}