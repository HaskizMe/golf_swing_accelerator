// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AccountImpl _$$AccountImplFromJson(Map<String, dynamic> json) =>
    _$AccountImpl(
      heightFt: (json['heightFt'] as num?)?.toInt(),
      heightIn: (json['heightIn'] as num?)?.toInt(),
      heightCm: (json['heightCm'] as num?)?.toDouble(),
      primaryHand: json['primaryHand'] as String?,
      skillLevel: json['skillLevel'] as String?,
      displayName: json['displayName'] as String?,
      email: json['email'] as String?,
      isCalibrated: json['isCalibrated'] as bool? ?? false,
    );

Map<String, dynamic> _$$AccountImplToJson(_$AccountImpl instance) =>
    <String, dynamic>{
      'heightFt': instance.heightFt,
      'heightIn': instance.heightIn,
      'heightCm': instance.heightCm,
      'primaryHand': instance.primaryHand,
      'skillLevel': instance.skillLevel,
      'displayName': instance.displayName,
      'email': instance.email,
      'isCalibrated': instance.isCalibrated,
    };
