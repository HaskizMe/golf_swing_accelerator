import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/bluetooth.dart';
import 'package:golf_accelerator_app/models/swing_data.dart';
import 'package:golf_accelerator_app/screens/swing_result/local_widgets/stats_row.dart';
import 'package:golf_accelerator_app/screens/swing_result/local_widgets/swing_graph.dart';
import 'package:golf_accelerator_app/widgets/flat_button.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../home/home.dart';
import '../test/test.dart';

class SwingResultScreen extends ConsumerStatefulWidget {
  final bool quickView;
  final SwingData swing;

  const SwingResultScreen({super.key, required this.quickView, required this.swing});

  @override
  ConsumerState<SwingResultScreen> createState() => _SwingResultScreenState();
}

class _SwingResultScreenState extends ConsumerState<SwingResultScreen> {
  int _remainingTime = 5; // Time remaining for the timer
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    print("INIT STATE");
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

    //printValues();
    Map<String, List<double>> values = widget.swing.swingPoints;
    List<Map<String, double>> path = calculateSwingPath(xValues: values['x']!, yValues: values['y']!, zValues: values['z']!, deltaT: .01);
    print(path);

  }

  void printValues(){
    widget.swing.swingPoints.forEach((key, values) {
      print('$key: ${values.join(', ')}');
    });
  }

  List<Map<String, double>> calculateSwingPath({
    required List<double> xValues,
    required List<double> yValues,
    required List<double> zValues,
    required double deltaT, // Time difference in seconds (0.01 for 10ms)
  }) {
    const double gForceToAcceleration = 9.81; // Conversion factor
    List<Map<String, double>> path = []; // To store positions (x, y, z)

    // Initialize velocity and position
    double vx = 0, vy = 0, vz = 0;
    double px = 0, py = 0, pz = 0;

    for (int i = 0; i < xValues.length; i++) {
      // Convert g-force to acceleration (m/s²)
      double ax = xValues[i] * gForceToAcceleration;
      double ay = yValues[i] * gForceToAcceleration;
      double az = zValues[i] * gForceToAcceleration;

      // Update velocity (trapezoidal integration)
      if (i > 0) {
        double prevAx = xValues[i - 1] * gForceToAcceleration;
        double prevAy = yValues[i - 1] * gForceToAcceleration;
        double prevAz = zValues[i - 1] * gForceToAcceleration;

        vx += (deltaT / 2) * (ax + prevAx);
        vy += (deltaT / 2) * (ay + prevAy);
        vz += (deltaT / 2) * (az + prevAz);
      }

      // Update position (trapezoidal integration)
      if (i > 0) {
        double prevVx = vx - (deltaT / 2) * ax;
        double prevVy = vy - (deltaT / 2) * ay;
        double prevVz = vz - (deltaT / 2) * az;

        px += (deltaT / 2) * (vx + prevVx);
        py += (deltaT / 2) * (vy + prevVy);
        pz += (deltaT / 2) * (vz + prevVz);
      }

      // Store position in the path
      path.add({'x': px, 'y': py, 'z': pz});
    }

    return path;
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
          color: Colors.black,
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
                        const SizedBox(height: 30,),
                        ElevatedButton(onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ThreeD(
                                swingPoints: widget.swing.swingPoints,
                              ),
                            ),
                          );
                        }, child: Text("See 3D Graph"))
                      ],
                    ),
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
                  border: Border.all(color: Colors.black, width: 2),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$_remainingTime',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
        ],
      ),
    );
  }
}