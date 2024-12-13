import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/device.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/providers/swings_notifier.dart';
import 'package:golf_accelerator_app/screens/swing_result/swing_result.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import 'package:intl/intl.dart';
import '../../theme/app_colors.dart';
import '../home/home.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {

  void onSlideDismissed(SwingData swing){
    // Handle the deletion
    FirestoreService.deleteSwing(swing.swingId!);

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Swing deleted"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Function to format the date
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat("MMM dd, yyyy 'AT' hh:mma");
    return formatter.format(date).toUpperCase(); // Convert "am/pm" to uppercase
  }


  @override
  Widget build(BuildContext context) {
    final swings = ref.watch(swingsNotifierProvider);

    //print("${swings[0].createdAt?.toDate()}");
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: swings.isEmpty
            ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "No swing data available.",
                style: TextStyle(color: AppColors.forestGreen, fontSize: 20),
              ),
              const SizedBox(height: 10,),
              ElevatedButton(
                  onPressed: () {
                    /// This allows me to switch tabs in the bottom navigation
                    BottomNavigationBar navigationBar =  bottomNavigatorKey.currentWidget as BottomNavigationBar;
                    navigationBar.onTap!(1);
                    },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.forestGreen,
                    foregroundColor: Colors.white
                  ),
                  child: const Text("Practice Swinging Club"))
            ],
          ),
        )
            : ListView.builder(
          itemCount: swings.length,
          itemBuilder: (context, index) {
            final swing = swings[index];
            return Dismissible(
              key: ValueKey(swing.swingId), // Ensure each item has a unique key
              direction: DismissDirection.endToStart, // Allow swiping only to the right
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              onDismissed: (direction) => onSlideDismissed(swing),
              child: InkWell(
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
                  elevation: 2,
                  color: Colors.white.withOpacity(0.9),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Optional: Adjust corner radius
                    side: const BorderSide(
                      color: Colors.grey, // Border color
                      width: 1.5, // Border width
                    ),
                  ),
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
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}