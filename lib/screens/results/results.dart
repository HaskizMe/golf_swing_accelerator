import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:golf_accelerator_app/models/device.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/providers/swings_notifier.dart';
import 'package:golf_accelerator_app/screens/swing_result/swing_result.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/providers/swings_notifier.dart';
import 'package:golf_accelerator_app/screens/swing_result/swing_result.dart';
import 'package:intl/intl.dart';


final List<SwingData> swings = [
  SwingData(
    swingId: '1',
    speed: 80,
    swingPoints: [1.0, 2.0, 3.0],
    createdAt: Timestamp.fromDate(DateTime(2025, 1, 5)),
  ),
  SwingData(
    swingId: '2',
    speed: 85,
    swingPoints: [1.5, 2.5, 3.5],
    createdAt: Timestamp.fromDate(DateTime(2025, 1, 15)),
  ),
  SwingData(
    swingId: '3',
    speed: 75,
    swingPoints: [1.2, 2.2, 3.2],
    createdAt: Timestamp.fromDate(DateTime(2025, 1, 25)),
  ),
  SwingData(
    swingId: '3',
    speed: 75,
    swingPoints: [1.2, 2.2, 3.2],
    createdAt: Timestamp.fromDate(DateTime(2026, 1, 25)),
  ),
  // SwingData(
  //   swingId: '3',
  //   speed: 75,
  //   swingPoints: [1.2, 2.2, 3.2],
  //   createdAt: Timestamp.fromDate(DateTime(2024, 11, 25)),
  // ),
  // SwingData(
  //   swingId: '3',
  //   speed: 75,
  //   swingPoints: [1.2, 2.2, 3.2],
  //   createdAt: Timestamp.fromDate(DateTime(2025, 12, 25)),
  // ),
];
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  /// Group swings by month and year
  Map<String, List<SwingData>> groupSwingsByMonth(List<SwingData> swings) {
    final Map<String, List<SwingData>> groupedSwings = {};

    for (var swing in swings) {
      final DateTime date = swing.createdAt!.toDate();
      final String key = "${DateFormat.yMMM().format(date)}"; // Example: "Jan 2025"

      if (!groupedSwings.containsKey(key)) {
        groupedSwings[key] = [];
      }
      groupedSwings[key]!.add(swing);
    }

    return groupedSwings;
  }

  /// Format Date for Swing Details
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat("MMM dd, yyyy 'AT' hh:mma");
    return formatter.format(date).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final swings = ref.watch(swingsNotifierProvider);

    if (swings.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "No swing data available.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
    }

    // Group swings by month and year
    final groupedSwings = groupSwingsByMonth(swings);

    return Scaffold(
      appBar: AppBar(),
      body: CustomScrollView(
        slivers: groupedSwings.entries.map((entry) {
          final String header = entry.key; // Month-Year
          final List<SwingData> swingsForMonth = entry.value;

          return SliverStickyHeader(
            header: Container(
              height: 60,
              color: Colors.green[800],
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                header, // Header title
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  final SwingData swing = swingsForMonth[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SwingResultScreen(
                            quickView: false,
                            swing: swing,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 16,
                      ),
                      elevation: 2,
                      child: ListTile(
                        title: Text(
                          swing.createdAt != null
                              ? formatDate(swing.createdAt!.toDate())
                              : "Unknown Date",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Speed: ${swing.speed} mph"),
                            Text(
                                "Carry Distance: ${swing.getCarryDistance()} yards"),
                            Text("Total Distance: ${swing.getTotalDistance()} yards"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: swingsForMonth.length,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
// class ResultsScreen extends ConsumerStatefulWidget {
//   const ResultsScreen({super.key});
//
//   @override
//   ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
// }
//
// class _ResultsScreenState extends ConsumerState<ResultsScreen> {
//
//   void onSlideDismissed(SwingData swing){
//     // Handle the deletion
//     FirestoreService.deleteSwing(swing.swingId!);
//
//     // Show a snackbar
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Swing deleted"),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   // Function to format the date
//   String formatDate(DateTime date) {
//     final DateFormat formatter = DateFormat("MMM dd, yyyy 'AT' hh:mma");
//     return formatter.format(date).toUpperCase(); // Convert "am/pm" to uppercase
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final swings = ref.watch(swingsNotifierProvider);
//
//     //print("${swings[0].createdAt?.toDate()}");
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: swings.isEmpty
//             ? Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text(
//                 "No swing data available.",
//                 style: TextStyle(color: AppColors.forestGreen, fontSize: 20),
//               ),
//               const SizedBox(height: 10,),
//               ElevatedButton(
//                   onPressed: () {
//                     /// This allows me to switch tabs in the bottom navigation
//                     BottomNavigationBar navigationBar =  bottomNavigatorKey.currentWidget as BottomNavigationBar;
//                     navigationBar.onTap!(1);
//                     },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.forestGreen,
//                     foregroundColor: Colors.white
//                   ),
//                   child: const Text("Practice Swinging Club"))
//             ],
//           ),
//         )
//             : ListView.builder(
//           itemCount: swings.length,
//           itemBuilder: (context, index) {
//             final swing = swings[index];
//             return Dismissible(
//               key: ValueKey(swing.swingId), // Ensure each item has a unique key
//               direction: DismissDirection.endToStart, // Allow swiping only to the right
//               background: Container(
//                 color: Colors.red,
//                 alignment: Alignment.centerRight,
//                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                 child: const Icon(
//                   Icons.delete,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//               ),
//               onDismissed: (direction) => onSlideDismissed(swing),
//               child: InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SwingResultScreen(
//                         quickView: false,
//                         swing: swing,
//                       ),
//                     ),
//                   );
//                 },
//                 child: Card(
//                   elevation: 2,
//                   color: Colors.white.withOpacity(0.9),
//                   margin: const EdgeInsets.symmetric(vertical: 8.0),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0), // Optional: Adjust corner radius
//                     side: const BorderSide(
//                       color: Colors.grey, // Border color
//                       width: 1.5, // Border width
//                     ),
//                   ),
//                   child: ListTile(
//                     title: Text(
//                       swing.createdAt != null
//                           ? formatDate(swing.createdAt!.toDate())
//                           : "Unknown Date",
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Speed: ${swing.speed} mph"),
//                         Text("Carry Distance: ${swing.getCarryDistance()} yards"),
//                         Text("Total Distance: ${swing.getTotalDistance()} yards"),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



class SettingsAppBarApp extends StatelessWidget {
  const SettingsAppBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SettingsAppBarExample());
  }
}

class SettingsAppBarExample extends StatefulWidget {
  const SettingsAppBarExample({super.key});

  @override
  State<SettingsAppBarExample> createState() => _SettingsAppBarExampleState();
}

class _SettingsAppBarExampleState extends State<SettingsAppBarExample> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverStickyHeader.builder(
            builder: (context, state) => Container(
              height: 60.0,
              color: (state.isPinned ? AppColors.forestGreen : Colors.grey)
                  .withOpacity(1.0 - state.scrollPercentage),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Header #1',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) => ListTile(
                  leading: CircleAvatar(
                    child: Text('0'),
                  ),
                  title: Text('List tile #$i'),
                ),
                childCount: 4,
              ),
            ),
          ),
          SliverStickyHeader.builder(
            builder: (context, state) => Container(
              height: 60.0,
              color: (state.isPinned ? AppColors.forestGreen : Colors.grey)
                  .withOpacity(1.0 - state.scrollPercentage),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Header #1',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) => ListTile(
                  leading: CircleAvatar(
                    child: Text('0'),
                  ),
                  title: Text('List tile #$i'),
                ),
                childCount: 4,
              ),
            ),
          ),
          SliverStickyHeader.builder(
            builder: (context, state) => Container(
              height: 60.0,
              color: (state.isPinned ? AppColors.forestGreen : Colors.grey)
                  .withOpacity(1.0 - state.scrollPercentage),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Header #1',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) => ListTile(
                  leading: CircleAvatar(
                    child: Text('0'),
                  ),
                  title: Text('List tile #$i'),
                ),
                childCount: 4,
              ),
            ),
          ),
          SliverStickyHeader.builder(
            builder: (context, state) => Container(
              height: 60.0,
              color: (state.isPinned ? Colors.pink : Colors.lightBlue)
                  .withOpacity(1.0 - state.scrollPercentage),
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                'Header #1',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, i) => ListTile(
                  leading: CircleAvatar(
                    child: Text('0'),
                  ),
                  title: Text('List tile #$i'),
                ),
                childCount: 4,
              ),
            ),
          )
        ],
      )
    );
  }
}
