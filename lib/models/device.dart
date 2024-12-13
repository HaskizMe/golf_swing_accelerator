import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

part 'device.freezed.dart';

@freezed
class GolfDevice with _$GolfDevice {
  const factory GolfDevice({
    @Default("a545") String endOfPacketHeader,
    @Default("a553") String startOfPacketHeader,
    @Default("a573") String mphPacketHeader,
    @Default("a572") String swingPointsHeader,
    @Default([]) List<double> tempSwingDataPoints,
    @Default(0) int tempSpeed,
    @Default(false) bool collectingData,
  }) = _GolfDevice;
}