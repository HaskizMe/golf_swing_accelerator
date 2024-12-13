import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

@freezed
class Account with _$Account {
  const factory Account({
    int? heightFt,
    int? heightIn,
    double? heightCm,
    String? primaryHand,
    String? skillLevel,
    String? displayName,
    String? email,
    @Default(false) bool isCalibrated,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
}