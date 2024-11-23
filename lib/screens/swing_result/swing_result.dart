import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/screens/swing_result/local_widgets/stats_row.dart';
import 'package:golf_accelerator_app/screens/swing_result/local_widgets/swing_graph.dart';
import 'package:golf_accelerator_app/widgets/flat_button.dart';
import '../../theme/app_colors.dart';
import '../home/home.dart';

class SwingResultScreen extends StatefulWidget {
  final bool quickView;
  final SwingData swing;

  const SwingResultScreen({super.key, required this.quickView, required this.swing});

  @override
  State<SwingResultScreen> createState() => _SwingResultScreenState();
}

class _SwingResultScreenState extends State<SwingResultScreen> {
  int _remainingTime = 5; // Time remaining for the timer
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    if (widget.quickView) {
      // Start a timer for 5 seconds
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
          } else {
            timer.cancel();
            Navigator.pop(context); // Automatically pop the page after 5 seconds
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
        ),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 10),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Spacing applied to all elements
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if(widget.quickView)
                      const Text(
                        "Nice Swing!",
                        style: TextStyle(color: Colors.black, fontSize: 34),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.forestGreen,
                        border: Border.all(color: Colors.black, width: 2),
                      ),
                      width: 200,
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${widget.swing.speed}',
                            style: const TextStyle(color: Colors.white, fontSize: 70),
                          ),
                          const Text(
                            "MPH",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        CustomStatsRow(title: 'Total Carry Distance', result: '${widget.swing.getCarryDistance()} Yards'),
                        const SizedBox(height: 15),
                        CustomStatsRow(title: 'Total Distance', result: '${widget.swing.getTotalDistance()} Yards'),
                        const SizedBox(height: 20),

                        const Text("Swing Graph", style: TextStyle(color: Colors.white, fontSize: 20),),
                        const SizedBox(height: 10,),
                        SwingGraph(swing: widget.swing),
                        const SizedBox(height: 30,)
                      ],
                    ),
                    // Visibility(
                    //   visible: !widget.quickView,
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       CustomFlatButton(title: "Reswing", onTap: () {}, width: 110),
                    //       CustomFlatButton(title: "Home", onTap: () {
                    //         Navigator.pushAndRemoveUntil(
                    //           context,
                    //           MaterialPageRoute(builder: (context) => const HomeScreen()),
                    //               (Route<dynamic> route) => false, // This condition removes all previous routes.
                    //         );
                    //       }, width: 110),
                    //       CustomFlatButton(title: "Graph", onTap: () {
                    //         Navigator.push(context, MaterialPageRoute(builder: (context) => SwingGraphScreen(swing: widget.swing)),);
                    //       }, width: 110),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          if (widget.quickView)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$_remainingTime',
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}