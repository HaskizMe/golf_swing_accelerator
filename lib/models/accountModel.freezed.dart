// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accountModel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) {
  return _AccountModel.fromJson(json);
}

/// @nodoc
mixin _$AccountModel {
  int? get heightFt => throw _privateConstructorUsedError;
  int? get heightIn => throw _privateConstructorUsedError;
  double? get heightCm => throw _privateConstructorUsedError;
  String? get primaryHand => throw _privateConstructorUsedError;
  String? get skillLevel => throw _privateConstructorUsedError;
  String? get displayName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  bool get isCalibrated => throw _privateConstructorUsedError;

  /// Serializes this AccountModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountModelCopyWith<AccountModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountModelCopyWith<$Res> {
  factory $AccountModelCopyWith(
          AccountModel value, $Res Function(AccountModel) then) =
      _$AccountModelCopyWithImpl<$Res, AccountModel>;
  @useResult
  $Res call(
      {int? heightFt,
      int? heightIn,
      double? heightCm,
      String? primaryHand,
      String? skillLevel,
      String? displayName,
      String email,
      bool isCalibrated});
}

/// @nodoc
class _$AccountModelCopyWithImpl<$Res, $Val extends AccountModel>
    implements $AccountModelCopyWith<$Res> {
  _$AccountModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heightFt = freezed,
    Object? heightIn = freezed,
    Object? heightCm = freezed,
    Object? primaryHand = freezed,
    Object? skillLevel = freezed,
    Object? displayName = freezed,
    Object? email = null,
    Object? isCalibrated = null,
  }) {
    return _then(_value.copyWith(
      heightFt: freezed == heightFt
          ? _value.heightFt
          : heightFt // ignore: cast_nullable_to_non_nullable
              as int?,
      heightIn: freezed == heightIn
          ? _value.heightIn
          : heightIn // ignore: cast_nullable_to_non_nullable
              as int?,
      heightCm: freezed == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double?,
      primaryHand: freezed == primaryHand
          ? _value.primaryHand
          : primaryHand // ignore: cast_nullable_to_non_nullable
              as String?,
      skillLevel: freezed == skillLevel
          ? _value.skillLevel
          : skillLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      isCalibrated: null == isCalibrated
          ? _value.isCalibrated
          : isCalibrated // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountModelImplCopyWith<$Res>
    implements $AccountModelCopyWith<$Res> {
  factory _$$AccountModelImplCopyWith(
          _$AccountModelImpl value, $Res Function(_$AccountModelImpl) then) =
      __$$AccountModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? heightFt,
      int? heightIn,
      double? heightCm,
      String? primaryHand,
      String? skillLevel,
      String? displayName,
      String email,
      bool isCalibrated});
}

/// @nodoc
class __$$AccountModelImplCopyWithImpl<$Res>
    extends _$AccountModelCopyWithImpl<$Res, _$AccountModelImpl>
    implements _$$AccountModelImplCopyWith<$Res> {
  __$$AccountModelImplCopyWithImpl(
      _$AccountModelImpl _value, $Res Function(_$AccountModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? heightFt = freezed,
    Object? heightIn = freezed,
    Object? heightCm = freezed,
    Object? primaryHand = freezed,
    Object? skillLevel = freezed,
    Object? displayName = freezed,
    Object? email = null,
    Object? isCalibrated = null,
  }) {
    return _then(_$AccountModelImpl(
      heightFt: freezed == heightFt
          ? _value.heightFt
          : heightFt // ignore: cast_nullable_to_non_nullable
              as int?,
      heightIn: freezed == heightIn
          ? _value.heightIn
          : heightIn // ignore: cast_nullable_to_non_nullable
              as int?,
      heightCm: freezed == heightCm
          ? _value.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double?,
      primaryHand: freezed == primaryHand
          ? _value.primaryHand
          : primaryHand // ignore: cast_nullable_to_non_nullable
              as String?,
      skillLevel: freezed == skillLevel
          ? _value.skillLevel
          : skillLevel // ignore: cast_nullable_to_non_nullable
              as String?,
      displayName: freezed == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String?,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      isCalibrated: null == isCalibrated
          ? _value.isCalibrated
          : isCalibrated // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountModelImpl with DiagnosticableTreeMixin implements _AccountModel {
  const _$AccountModelImpl(
      {this.heightFt,
      this.heightIn,
      this.heightCm,
      this.primaryHand,
      this.skillLevel,
      this.displayName,
      required this.email,
      this.isCalibrated = false});

  factory _$AccountModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountModelImplFromJson(json);

  @override
  final int? heightFt;
  @override
  final int? heightIn;
  @override
  final double? heightCm;
  @override
  final String? primaryHand;
  @override
  final String? skillLevel;
  @override
  final String? displayName;
  @override
  final String email;
  @override
  @JsonKey()
  final bool isCalibrated;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AccountModel(heightFt: $heightFt, heightIn: $heightIn, heightCm: $heightCm, primaryHand: $primaryHand, skillLevel: $skillLevel, displayName: $displayName, email: $email, isCalibrated: $isCalibrated)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AccountModel'))
      ..add(DiagnosticsProperty('heightFt', heightFt))
      ..add(DiagnosticsProperty('heightIn', heightIn))
      ..add(DiagnosticsProperty('heightCm', heightCm))
      ..add(DiagnosticsProperty('primaryHand', primaryHand))
      ..add(DiagnosticsProperty('skillLevel', skillLevel))
      ..add(DiagnosticsProperty('displayName', displayName))
      ..add(DiagnosticsProperty('email', email))
      ..add(DiagnosticsProperty('isCalibrated', isCalibrated));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountModelImpl &&
            (identical(other.heightFt, heightFt) ||
                other.heightFt == heightFt) &&
            (identical(other.heightIn, heightIn) ||
                other.heightIn == heightIn) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.primaryHand, primaryHand) ||
                other.primaryHand == primaryHand) &&
            (identical(other.skillLevel, skillLevel) ||
                other.skillLevel == skillLevel) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isCalibrated, isCalibrated) ||
                other.isCalibrated == isCalibrated));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, heightFt, heightIn, heightCm,
      primaryHand, skillLevel, displayName, email, isCalibrated);

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountModelImplCopyWith<_$AccountModelImpl> get copyWith =>
      __$$AccountModelImplCopyWithImpl<_$AccountModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountModelImplToJson(
      this,
    );
  }
}

abstract class _AccountModel implements AccountModel {
  const factory _AccountModel(
      {final int? heightFt,
      final int? heightIn,
      final double? heightCm,
      final String? primaryHand,
      final String? skillLevel,
      final String? displayName,
      required final String email,
      final bool isCalibrated}) = _$AccountModelImpl;

  factory _AccountModel.fromJson(Map<String, dynamic> json) =
      _$AccountModelImpl.fromJson;

  @override
  int? get heightFt;
  @override
  int? get heightIn;
  @override
  double? get heightCm;
  @override
  String? get primaryHand;
  @override
  String? get skillLevel;
  @override
  String? get displayName;
  @override
  String get email;
  @override
  bool get isCalibrated;

  /// Create a copy of AccountModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountModelImplCopyWith<_$AccountModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
