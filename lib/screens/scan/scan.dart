import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golf_accelerator_app/models/bluetooth.dart';
import 'package:golf_accelerator_app/screens/scan/local_widgets/device_card.dart';
import '../../theme/app_colors.dart';

class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  List<ScanResult> _scanResults = [];
  List<BluetoothDevice> _connectedDevices = [];
  //final Bluetooth _ble = Bluetooth();

  Map<String, String> connectionStatuses = {}; // Tracks each device's connection status
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;

  late StreamSubscription<BluetoothAdapterState> _adapterStateSubscription;
  StreamSubscription<List<ScanResult>>? _scanResultsSubscription;

  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _checkDevicePermissions();
    _scanDevices();
  }

  @override
  void dispose() {
    _adapterStateSubscription.cancel();
    if(_scanResultsSubscription != null){
      _scanResultsSubscription!.cancel();
    }
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  Future<void> _checkDevicePermissions() async {
    // first, check if bluetooth is supported by your hardware
    // Note: The platform is initialized on the first call to any FlutterBluePlus method.
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }

    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      setState(() {
        _adapterState = state;
      });
      // turn on bluetooth ourself if we can
      // for iOS, the user controls bluetooth enable/disable
      print("Bluetooth $state");
    });
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  Future<void> _scanDevices() async {
    if(_adapterState == BluetoothAdapterState.unknown || _adapterState == BluetoothAdapterState.unavailable) return;
    _connectedDevices = FlutterBluePlus.connectedDevices;

    setState(() {
      _isScanning = true;
      _scanResults = [];
      connectionStatuses.clear();
    });

    print("Starting device scan...");

    _scanResultsSubscription = FlutterBluePlus.onScanResults.listen((results) {
      setState(() {
        _scanResults = results.where((result) => result.device.advName.isNotEmpty).toList();
      });
    }, onError: (e) => print("Scan error: $e"));

    FlutterBluePlus.cancelWhenScanComplete(_scanResultsSubscription!);

    await FlutterBluePlus.startScan(
      withKeywords: ["Golf_"],
      timeout: const Duration(seconds: 5),
    );

    await FlutterBluePlus.isScanning.where((val) => val == false).first;

    setState(() {
      _isScanning = false;
    });

    print(_scanResults.isNotEmpty ? "Devices found" : "No devices found");
  }

  void _connectToDevice(BluetoothDevice device) async {
    final deviceId = device.remoteId.toString();

    setState(() {
      connectionStatuses[deviceId] = "Connecting..."; // Update status to Connecting
    });

    //bool connected = await _ble.connectDevice(device);
    bool connected = await ref.read(bluetoothProvider.notifier).connectDevice(device);

    setState(() {
      if (connected) {
        connectionStatuses[deviceId] = "Connected"; // Update status to Connected
        _connectedDevices.add(device); // Add to connected devices list
        _scanResults.removeWhere((result) => result.device.remoteId == device.remoteId);
      } else {
        connectionStatuses[deviceId] = "Unable to connect"; // Update status to Unable to connect
      }
    });
  }

  void _disconnectFromDevice(BluetoothDevice device) async {
    final deviceId = device.remoteId.toString();

    setState(() {
      connectionStatuses[deviceId] = "Disconnecting..."; // Update status to Disconnecting
    });

    await device.disconnect();

    _scanDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            if (_isScanning)
              const Column(
                children: [
                  Text(
                    "Scanning for Golf Device",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  CircularProgressIndicator(
                    color: AppColors.forestGreen,
                  ),
                ],
              )
            else if (_scanResults.isEmpty && _connectedDevices.isEmpty)
              Column(
                children: [
                  const Text(
                    "No devices found. Please try again.",
                    style: TextStyle(color: AppColors.forestGreen, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _scanDevices,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.forestGreen,
                    ),
                    child: const Text(
                      "Scan Again",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              )
            else
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.forestGreen,
                  onRefresh: _scanDevices,
                  child: ListView(
                    children: [
                      // Connected Devices Section
                      if (_connectedDevices.isNotEmpty) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            "Connected Devices",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        ..._connectedDevices.map((device) {
                          final status = connectionStatuses[device.remoteId.toString()] ?? "Connected";
                          return DeviceCard(
                            status: status,
                            onTap: () => _disconnectFromDevice(device), // Disconnect on tap
                            deviceName: device.advName,
                          );
                        }),
                      ],

                      // Available Devices Section
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        child: Text(
                          "Available Devices",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      ..._scanResults.map((result) {
                        final status = connectionStatuses[result.device.remoteId.toString()] ?? "Available";
                        return DeviceCard(
                          status: status,
                          onTap: () => _connectToDevice(result.device), // Connect on tap
                          deviceName: result.device.advName,
                        );
                      }),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}