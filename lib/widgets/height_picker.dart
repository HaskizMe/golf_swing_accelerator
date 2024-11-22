import 'package:flutter/material.dart';

class HeightPicker extends StatefulWidget {
  @override
  _HeightPickerState createState() => _HeightPickerState();
}

class _HeightPickerState extends State<HeightPicker> {
  String _selectedUnit = "Feet & Inches"; // Default unit
  int _feet = 5; // Default feet value
  int _inches = 6; // Default inches value
  double _meters = 1.70; // Default meters value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Height Picker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Dropdown for unit selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Choose Unit: "),
                DropdownButton<String>(
                  value: _selectedUnit,
                  items: ["Feet & Inches", "Meters"].map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedUnit = value;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Feet & Inches Picker
            if (_selectedUnit == "Feet & Inches")
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Select Height (Feet & Inches)",
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Feet Dropdown
                      Column(
                        children: [
                          const Text("Feet"),
                          DropdownButton<int>(
                            value: _feet,
                            items: List.generate(10, (index) => index).map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _feet = value!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // Inches Dropdown
                      Column(
                        children: [
                          const Text("Inches"),
                          DropdownButton<int>(
                            value: _inches,
                            items: List.generate(12, (index) => index).map((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _inches = value!;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Selected Height: $_feet' $_inches\"",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

            // Meters Picker
            if (_selectedUnit == "Meters")
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Select Height (Meters)",
                    style: TextStyle(fontSize: 18),
                  ),
                  Slider(
                    value: _meters,
                    min: 0.5,
                    max: 2.5,
                    divisions: 200,
                    label: "${_meters.toStringAsFixed(2)} meters",
                    onChanged: (value) {
                      setState(() {
                        _meters = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Selected Height: ${_meters.toStringAsFixed(2)} meters",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}