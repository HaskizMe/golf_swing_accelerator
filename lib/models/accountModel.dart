import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'accountModel.freezed.dart'; // This is for Freezed code generation.
part 'accountModel.g.dart';

@freezed
class AccountModel with _$AccountModel {
  const factory AccountModel({
    int? heightFt,
    int? heightIn,
    double? heightCm,
    String? primaryHand,
    String? skillLevel,
    String? displayName,
    required String email,
    @Default(false) bool isCalibrated,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}