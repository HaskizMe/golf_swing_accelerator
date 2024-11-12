import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/device.dart';
import 'package:golf_accelerator_app/providers/swings.dart';
import '../../theme/app_colors.dart';

class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    final swings = ref.watch(swingsNotifierProvider);

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
              style: TextStyle(color: Colors.white),
            ),
          )
              : ListView.builder(
            itemCount: swings.length,
            itemBuilder: (context, index) {
              final swing = swings[index];
              return Card(
                color: Colors.white.withOpacity(0.9),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    "Swing ${index + 1}",
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
              );
            },
          ),
        ),
      ),
    );
  }
}