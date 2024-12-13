// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bluetooth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Bluetooth {
  String get customServiceUUID => throw _privateConstructorUsedError;
  String get customCharacteristicUUID => throw _privateConstructorUsedError;
  String get writeCharacteristicUUID => throw _privateConstructorUsedError;
  BluetoothDevice? get connectedDevice => throw _privateConstructorUsedError;
  List<BluetoothService> get services => throw _privateConstructorUsedError;
  BluetoothService? get customService => throw _privateConstructorUsedError;
  BluetoothCharacteristic? get customCharacteristic =>
      throw _privateConstructorUsedError;
  BluetoothCharacteristic? get writeCustomCharacteristic =>
      throw _privateConstructorUsedError;
  StreamSubscription<List<int>>? get customCharacteristicSubscription =>
      throw _privateConstructorUsedError;

  /// Create a copy of Bluetooth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BluetoothCopyWith<Bluetooth> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BluetoothCopyWith<$Res> {
  factory $BluetoothCopyWith(Bluetooth value, $Res Function(Bluetooth) then) =
      _$BluetoothCopyWithImpl<$Res, Bluetooth>;
  @useResult
  $Res call(
      {String customServiceUUID,
      String customCharacteristicUUID,
      String writeCharacteristicUUID,
      BluetoothDevice? connectedDevice,
      List<BluetoothService> services,
      BluetoothService? customService,
      BluetoothCharacteristic? customCharacteristic,
      BluetoothCharacteristic? writeCustomCharacteristic,
      StreamSubscription<List<int>>? customCharacteristicSubscription});
}

/// @nodoc
class _$BluetoothCopyWithImpl<$Res, $Val extends Bluetooth>
    implements $BluetoothCopyWith<$Res> {
  _$BluetoothCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Bluetooth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customServiceUUID = null,
    Object? customCharacteristicUUID = null,
    Object? writeCharacteristicUUID = null,
    Object? connectedDevice = freezed,
    Object? services = null,
    Object? customService = freezed,
    Object? customCharacteristic = freezed,
    Object? writeCustomCharacteristic = freezed,
    Object? customCharacteristicSubscription = freezed,
  }) {
    return _then(_value.copyWith(
      customServiceUUID: null == customServiceUUID
          ? _value.customServiceUUID
          : customServiceUUID // ignore: cast_nullable_to_non_nullable
              as String,
      customCharacteristicUUID: null == customCharacteristicUUID
          ? _value.customCharacteristicUUID
          : customCharacteristicUUID // ignore: cast_nullable_to_non_nullable
              as String,
      writeCharacteristicUUID: null == writeCharacteristicUUID
          ? _value.writeCharacteristicUUID
          : writeCharacteristicUUID // ignore: cast_nullable_to_non_nullable
              as String,
      connectedDevice: freezed == connectedDevice
          ? _value.connectedDevice
          : connectedDevice // ignore: cast_nullable_to_non_nullable
              as BluetoothDevice?,
      services: null == services
          ? _value.services
          : services // ignore: cast_nullable_to_non_nullable
              as List<BluetoothService>,
      customService: freezed == customService
          ? _value.customService
          : customService // ignore: cast_nullable_to_non_nullable
              as BluetoothService?,
      customCharacteristic: freezed == customCharacteristic
          ? _value.customCharacteristic
          : customCharacteristic // ignore: cast_nullable_to_non_nullable
              as BluetoothCharacteristic?,
      writeCustomCharacteristic: freezed == writeCustomCharacteristic
          ? _value.writeCustomCharacteristic
          : writeCustomCharacteristic // ignore: cast_nullable_to_non_nullable
              as BluetoothCharacteristic?,
      customCharacteristicSubscription: freezed ==
              customCharacteristicSubscription
          ? _value.customCharacteristicSubscription
          : customCharacteristicSubscription // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<List<int>>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BluetoothImplCopyWith<$Res>
    implements $BluetoothCopyWith<$Res> {
  factory _$$BluetoothImplCopyWith(
          _$BluetoothImpl value, $Res Function(_$BluetoothImpl) then) =
      __$$BluetoothImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String customServiceUUID,
      String customCharacteristicUUID,
      String writeCharacteristicUUID,
      BluetoothDevice? connectedDevice,
      List<BluetoothService> services,
      BluetoothService? customService,
      BluetoothCharacteristic? customCharacteristic,
      BluetoothCharacteristic? writeCustomCharacteristic,
      StreamSubscription<List<int>>? customCharacteristicSubscription});
}

/// @nodoc
class __$$BluetoothImplCopyWithImpl<$Res>
    extends _$BluetoothCopyWithImpl<$Res, _$BluetoothImpl>
    implements _$$BluetoothImplCopyWith<$Res> {
  __$$BluetoothImplCopyWithImpl(
      _$BluetoothImpl _value, $Res Function(_$BluetoothImpl) _then)
      : super(_value, _then);

  /// Create a copy of Bluetooth
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? customServiceUUID = null,
    Object? customCharacteristicUUID = null,
    Object? writeCharacteristicUUID = null,
    Object? connectedDevice = freezed,
    Object? services = null,
    Object? customService = freezed,
    Object? customCharacteristic = freezed,
    Object? writeCustomCharacteristic = freezed,
    Object? customCharacteristicSubscription = freezed,
  }) {
    return _then(_$BluetoothImpl(
      customServiceUUID: null == customServiceUUID
          ? _value.customServiceUUID
          : customServiceUUID // ignore: cast_nullable_to_non_nullable
              as String,
      customCharacteristicUUID: null == customCharacteristicUUID
          ? _value.customCharacteristicUUID
          : customCharacteristicUUID // ignore: cast_nullable_to_non_nullable
              as String,
      writeCharacteristicUUID: null == writeCharacteristicUUID
          ? _value.writeCharacteristicUUID
          : writeCharacteristicUUID // ignore: cast_nullable_to_non_nullable
              as String,
      connectedDevice: freezed == connectedDevice
          ? _value.connectedDevice
          : connectedDevice // ignore: cast_nullable_to_non_nullable
              as BluetoothDevice?,
      services: null == services
          ? _value._services
          : services // ignore: cast_nullable_to_non_nullable
              as List<BluetoothService>,
      customService: freezed == customService
          ? _value.customService
          : customService // ignore: cast_nullable_to_non_nullable
              as BluetoothService?,
      customCharacteristic: freezed == customCharacteristic
          ? _value.customCharacteristic
          : customCharacteristic // ignore: cast_nullable_to_non_nullable
              as BluetoothCharacteristic?,
      writeCustomCharacteristic: freezed == writeCustomCharacteristic
          ? _value.writeCustomCharacteristic
          : writeCustomCharacteristic // ignore: cast_nullable_to_non_nullable
              as BluetoothCharacteristic?,
      customCharacteristicSubscription: freezed ==
              customCharacteristicSubscription
          ? _value.customCharacteristicSubscription
          : customCharacteristicSubscription // ignore: cast_nullable_to_non_nullable
              as StreamSubscription<List<int>>?,
    ));
  }
}

/// @nodoc

class _$BluetoothImpl implements _Bluetooth {
  const _$BluetoothImpl(
      {this.customServiceUUID = "6e400001-b5a3-f393-e0a9-e50e24dcca9e",
      this.customCharacteristicUUID = "6e400003-b5a3-f393-e0a9-e50e24dcca9e",
      this.writeCharacteristicUUID = "6e400002-b5a3-f393-e0a9-e50e24dcca9e",
      this.connectedDevice,
      final List<BluetoothService> services = const [],
      this.customService,
      this.customCharacteristic,
      this.writeCustomCharacteristic,
      this.customCharacteristicSubscription})
      : _services = services;

  @override
  @JsonKey()
  final String customServiceUUID;
  @override
  @JsonKey()
  final String customCharacteristicUUID;
  @override
  @JsonKey()
  final String writeCharacteristicUUID;
  @override
  final BluetoothDevice? connectedDevice;
  final List<BluetoothService> _services;
  @override
  @JsonKey()
  List<BluetoothService> get services {
    if (_services is EqualUnmodifiableListView) return _services;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_services);
  }

  @override
  final BluetoothService? customService;
  @override
  final BluetoothCharacteristic? customCharacteristic;
  @override
  final BluetoothCharacteristic? writeCustomCharacteristic;
  @override
  final StreamSubscription<List<int>>? customCharacteristicSubscription;

  @override
  String toString() {
    return 'Bluetooth(customServiceUUID: $customServiceUUID, customCharacteristicUUID: $customCharacteristicUUID, writeCharacteristicUUID: $writeCharacteristicUUID, connectedDevice: $connectedDevice, services: $services, customService: $customService, customCharacteristic: $customCharacteristic, writeCustomCharacteristic: $writeCustomCharacteristic, customCharacteristicSubscription: $customCharacteristicSubscription)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BluetoothImpl &&
            (identical(other.customServiceUUID, customServiceUUID) ||
                other.customServiceUUID == customServiceUUID) &&
            (identical(
                    other.customCharacteristicUUID, customCharacteristicUUID) ||
                other.customCharacteristicUUID == customCharacteristicUUID) &&
            (identical(
                    other.writeCharacteristicUUID, writeCharacteristicUUID) ||
                other.writeCharacteristicUUID == writeCharacteristicUUID) &&
            (identical(other.connectedDevice, connectedDevice) ||
                other.connectedDevice == connectedDevice) &&
            const DeepCollectionEquality().equals(other._services, _services) &&
            (identical(other.customService, customService) ||
                other.customService == customService) &&
            (identical(other.customCharacteristic, customCharacteristic) ||
                other.customCharacteristic == customCharacteristic) &&
            (identical(other.writeCustomCharacteristic,
                    writeCustomCharacteristic) ||
                other.writeCustomCharacteristic == writeCustomCharacteristic) &&
            (identical(other.customCharacteristicSubscription,
                    customCharacteristicSubscription) ||
                other.customCharacteristicSubscription ==
                    customCharacteristicSubscription));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      customServiceUUID,
      customCharacteristicUUID,
      writeCharacteristicUUID,
      connectedDevice,
      const DeepCollectionEquality().hash(_services),
      customService,
      customCharacteristic,
      writeCustomCharacteristic,
      customCharacteristicSubscription);

  /// Create a copy of Bluetooth
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BluetoothImplCopyWith<_$BluetoothImpl> get copyWith =>
      __$$BluetoothImplCopyWithImpl<_$BluetoothImpl>(this, _$identity);
}

abstract class _Bluetooth implements Bluetooth {
  const factory _Bluetooth(
      {final String customServiceUUID,
      final String customCharacteristicUUID,
      final String writeCharacteristicUUID,
      final BluetoothDevice? connectedDevice,
      final List<BluetoothService> services,
      final BluetoothService? customService,
      final BluetoothCharacteristic? customCharacteristic,
      final BluetoothCharacteristic? writeCustomCharacteristic,
      final StreamSubscription<List<int>>?
          customCharacteristicSubscription}) = _$BluetoothImpl;

  @override
  String get customServiceUUID;
  @override
  String get customCharacteristicUUID;
  @override
  String get writeCharacteristicUUID;
  @override
  BluetoothDevice? get connectedDevice;
  @override
  List<BluetoothService> get services;
  @override
  BluetoothService? get customService;
  @override
  BluetoothCharacteristic? get customCharacteristic;
  @override
  BluetoothCharacteristic? get writeCustomCharacteristic;
  @override
  StreamSubscription<List<int>>? get customCharacteristicSubscription;

  /// Create a copy of Bluetooth
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BluetoothImplCopyWith<_$BluetoothImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
