// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GolfDevice {
  String get endOfPacketHeader => throw _privateConstructorUsedError;
  String get startOfPacketHeader => throw _privateConstructorUsedError;
  String get mphPacketHeader => throw _privateConstructorUsedError;
  String get swingPointsHeader =>
      throw _privateConstructorUsedError; //@Default([]) List<double> tempSwingDataPoints,
  Map<String, List<double>> get tempSwingDataPoints =>
      throw _privateConstructorUsedError;
  int get tempSpeed => throw _privateConstructorUsedError;
  bool get collectingData => throw _privateConstructorUsedError;

  /// Create a copy of GolfDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GolfDeviceCopyWith<GolfDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GolfDeviceCopyWith<$Res> {
  factory $GolfDeviceCopyWith(
          GolfDevice value, $Res Function(GolfDevice) then) =
      _$GolfDeviceCopyWithImpl<$Res, GolfDevice>;
  @useResult
  $Res call(
      {String endOfPacketHeader,
      String startOfPacketHeader,
      String mphPacketHeader,
      String swingPointsHeader,
      Map<String, List<double>> tempSwingDataPoints,
      int tempSpeed,
      bool collectingData});
}

/// @nodoc
class _$GolfDeviceCopyWithImpl<$Res, $Val extends GolfDevice>
    implements $GolfDeviceCopyWith<$Res> {
  _$GolfDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GolfDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? endOfPacketHeader = null,
    Object? startOfPacketHeader = null,
    Object? mphPacketHeader = null,
    Object? swingPointsHeader = null,
    Object? tempSwingDataPoints = null,
    Object? tempSpeed = null,
    Object? collectingData = null,
  }) {
    return _then(_value.copyWith(
      endOfPacketHeader: null == endOfPacketHeader
          ? _value.endOfPacketHeader
          : endOfPacketHeader // ignore: cast_nullable_to_non_nullable
              as String,
      startOfPacketHeader: null == startOfPacketHeader
          ? _value.startOfPacketHeader
          : startOfPacketHeader // ignore: cast_nullable_to_non_nullable
              as String,
      mphPacketHeader: null == mphPacketHeader
          ? _value.mphPacketHeader
          : mphPacketHeader // ignore: cast_nullable_to_non_nullable
              as String,
      swingPointsHeader: null == swingPointsHeader
          ? _value.swingPointsHeader
          : swingPointsHeader // ignore: cast_nullable_to_non_nullable
              as String,
      tempSwingDataPoints: null == tempSwingDataPoints
          ? _value.tempSwingDataPoints
          : tempSwingDataPoints // ignore: cast_nullable_to_non_nullable
              as Map<String, List<double>>,
      tempSpeed: null == tempSpeed
          ? _value.tempSpeed
          : tempSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      collectingData: null == collectingData
          ? _value.collectingData
          : collectingData // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GolfDeviceImplCopyWith<$Res>
    implements $GolfDeviceCopyWith<$Res> {
  factory _$$GolfDeviceImplCopyWith(
          _$GolfDeviceImpl value, $Res Function(_$GolfDeviceImpl) then) =
      __$$GolfDeviceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String endOfPacketHeader,
      String startOfPacketHeader,
      String mphPacketHeader,
      String swingPointsHeader,
      Map<String, List<double>> tempSwingDataPoints,
      int tempSpeed,
      bool collectingData});
}

/// @nodoc
class __$$GolfDeviceImplCopyWithImpl<$Res>
    extends _$GolfDeviceCopyWithImpl<$Res, _$GolfDeviceImpl>
    implements _$$GolfDeviceImplCopyWith<$Res> {
  __$$GolfDeviceImplCopyWithImpl(
      _$GolfDeviceImpl _value, $Res Function(_$GolfDeviceImpl) _then)
      : super(_value, _then);

  /// Create a copy of GolfDevice
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? endOfPacketHeader = null,
    Object? startOfPacketHeader = null,
    Object? mphPacketHeader = null,
    Object? swingPointsHeader = null,
    Object? tempSwingDataPoints = null,
    Object? tempSpeed = null,
    Object? collectingData = null,
  }) {
    return _then(_$GolfDeviceImpl(
      endOfPacketHeader: null == endOfPacketHeader
          ? _value.endOfPacketHeader
          : endOfPacketHeader // ignore: cast_nullable_to_non_nullable
              as String,
      startOfPacketHeader: null == startOfPacketHeader
          ? _value.startOfPacketHeader
          : startOfPacketHeader // ignore: cast_nullable_to_non_nullable
              as String,
      mphPacketHeader: null == mphPacketHeader
          ? _value.mphPacketHeader
          : mphPacketHeader // ignore: cast_nullable_to_non_nullable
              as String,
      swingPointsHeader: null == swingPointsHeader
          ? _value.swingPointsHeader
          : swingPointsHeader // ignore: cast_nullable_to_non_nullable
              as String,
      tempSwingDataPoints: null == tempSwingDataPoints
          ? _value._tempSwingDataPoints
          : tempSwingDataPoints // ignore: cast_nullable_to_non_nullable
              as Map<String, List<double>>,
      tempSpeed: null == tempSpeed
          ? _value.tempSpeed
          : tempSpeed // ignore: cast_nullable_to_non_nullable
              as int,
      collectingData: null == collectingData
          ? _value.collectingData
          : collectingData // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$GolfDeviceImpl implements _GolfDevice {
  const _$GolfDeviceImpl(
      {this.endOfPacketHeader = "a545",
      this.startOfPacketHeader = "a553",
      this.mphPacketHeader = "a573",
      this.swingPointsHeader = "a572",
      final Map<String, List<double>> tempSwingDataPoints = const {
        "x": [],
        "y": [],
        "z": []
      },
      this.tempSpeed = 0,
      this.collectingData = false})
      : _tempSwingDataPoints = tempSwingDataPoints;

  @override
  @JsonKey()
  final String endOfPacketHeader;
  @override
  @JsonKey()
  final String startOfPacketHeader;
  @override
  @JsonKey()
  final String mphPacketHeader;
  @override
  @JsonKey()
  final String swingPointsHeader;
//@Default([]) List<double> tempSwingDataPoints,
  final Map<String, List<double>> _tempSwingDataPoints;
//@Default([]) List<double> tempSwingDataPoints,
  @override
  @JsonKey()
  Map<String, List<double>> get tempSwingDataPoints {
    if (_tempSwingDataPoints is EqualUnmodifiableMapView)
      return _tempSwingDataPoints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tempSwingDataPoints);
  }

  @override
  @JsonKey()
  final int tempSpeed;
  @override
  @JsonKey()
  final bool collectingData;

  @override
  String toString() {
    return 'GolfDevice(endOfPacketHeader: $endOfPacketHeader, startOfPacketHeader: $startOfPacketHeader, mphPacketHeader: $mphPacketHeader, swingPointsHeader: $swingPointsHeader, tempSwingDataPoints: $tempSwingDataPoints, tempSpeed: $tempSpeed, collectingData: $collectingData)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GolfDeviceImpl &&
            (identical(other.endOfPacketHeader, endOfPacketHeader) ||
                other.endOfPacketHeader == endOfPacketHeader) &&
            (identical(other.startOfPacketHeader, startOfPacketHeader) ||
                other.startOfPacketHeader == startOfPacketHeader) &&
            (identical(other.mphPacketHeader, mphPacketHeader) ||
                other.mphPacketHeader == mphPacketHeader) &&
            (identical(other.swingPointsHeader, swingPointsHeader) ||
                other.swingPointsHeader == swingPointsHeader) &&
            const DeepCollectionEquality()
                .equals(other._tempSwingDataPoints, _tempSwingDataPoints) &&
            (identical(other.tempSpeed, tempSpeed) ||
                other.tempSpeed == tempSpeed) &&
            (identical(other.collectingData, collectingData) ||
                other.collectingData == collectingData));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      endOfPacketHeader,
      startOfPacketHeader,
      mphPacketHeader,
      swingPointsHeader,
      const DeepCollectionEquality().hash(_tempSwingDataPoints),
      tempSpeed,
      collectingData);

  /// Create a copy of GolfDevice
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GolfDeviceImplCopyWith<_$GolfDeviceImpl> get copyWith =>
      __$$GolfDeviceImplCopyWithImpl<_$GolfDeviceImpl>(this, _$identity);
}

abstract class _GolfDevice implements GolfDevice {
  const factory _GolfDevice(
      {final String endOfPacketHeader,
      final String startOfPacketHeader,
      final String mphPacketHeader,
      final String swingPointsHeader,
      final Map<String, List<double>> tempSwingDataPoints,
      final int tempSpeed,
      final bool collectingData}) = _$GolfDeviceImpl;

  @override
  String get endOfPacketHeader;
  @override
  String get startOfPacketHeader;
  @override
  String get mphPacketHeader;
  @override
  String get swingPointsHeader; //@Default([]) List<double> tempSwingDataPoints,
  @override
  Map<String, List<double>> get tempSwingDataPoints;
  @override
  int get tempSpeed;
  @override
  bool get collectingData;

  /// Create a copy of GolfDevice
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GolfDeviceImplCopyWith<_$GolfDeviceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
