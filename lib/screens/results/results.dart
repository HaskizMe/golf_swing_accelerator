import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/providers/swings_notifier.dart';
import 'package:golf_accelerator_app/screens/swing_result/swing_result.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';


final List<SwingData> swings = [
  // SwingData(
  //   swingId: '1',
  //   speed: 80,
  //   swingPoints: [1.0, 2.0, 3.0],
  //   createdAt: Timestamp.fromDate(DateTime(2025, 1, 5)),
  // ),
  // SwingData(
  //   swingId: '2',
  //   speed: 85,
  //   swingPoints: [1.5, 2.5, 3.5],
  //   createdAt: Timestamp.fromDate(DateTime(2025, 1, 15)),
  // ),
  // SwingData(
  //   swingId: '3',
  //   speed: 75,
  //   swingPoints: [1.2, 2.2, 3.2],
  //   createdAt: Timestamp.fromDate(DateTime(2025, 1, 25)),
  // ),
  // SwingData(
  //   swingId: '3',
  //   speed: 75,
  //   swingPoints: [1.2, 2.2, 3.2],
  //   createdAt: Timestamp.fromDate(DateTime(2026, 1, 25)),
  // ),
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
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              color: AppColors.forestGreen,
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
                    child: Dismissible(
                      key: ValueKey(swing.swingId), // Unique key for each card
                      direction: DismissDirection.endToStart, // Only swipe from right to left
                      background: Container(
                        color: Colors.red, // Red background for delete
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.redAccent, // Slightly different shade of red
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onDismissed: (direction) {
                        // Call function to handle deletion
                        FirestoreService.deleteSwing(swing.swingId!);

                        // Show confirmation Snackbar
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Swing deleted"),
                            duration: Duration(seconds: 2),
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
                              Text("Carry Distance: ${swing.getCarryDistance()} yards"),
                              Text("Total Distance: ${swing.getTotalDistance()} yards"),
                            ],
                          ),
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
                        ),
                      ),
                    )

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