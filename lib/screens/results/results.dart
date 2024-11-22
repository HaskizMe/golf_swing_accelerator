import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/device.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/providers/swings.dart';
import 'package:golf_accelerator_app/screens/swing_result/swing_result.dart';
import 'package:golf_accelerator_app/services/firestore_service.dart';
import '../../theme/app_colors.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {

  void onSlideDismissed(SwingData swing){
    // Handle the deletion
    final db = FirestoreService();
    db.deleteSwing(swing.swingId!);

    // Show a snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Swing deleted"),
        duration: Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final swings = ref.watch(swingsNotifierProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.silverLakeBlue, AppColors.skyBlue],
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
          title: const Text("Results", style: TextStyle(color: Colors.white)),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: swings.isEmpty
              ? const Center(
            child: Text(
              "No swing data available.",
              style: TextStyle(color: Colors.white, fontSize: 20),
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
                    color: Colors.white.withOpacity(0.9),
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        "${swing.createdAt?.toDate()}",
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
      ),
    );
  }
}