import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'device_collecting_status.g.dart';

/// This riverpod provider is to help update any ui elements when the device is
/// collecting data. When we set it to true we will show a loader on the swing screen

@Riverpod(keepAlive: true)
class DeviceCollectingStatus extends _$DeviceCollectingStatus {
  /// The initial state is `false`, indicating no data is being received.
  @override
  bool build() {
    return false;
  }

  /// Set the status to `true`, indicating data is being received.
  void startReceivingData() {
    state = true;
  }

  /// Set the status to `false`, indicating data is no longer being received.
  void stopReceivingData() {
    state = false;
  }
}