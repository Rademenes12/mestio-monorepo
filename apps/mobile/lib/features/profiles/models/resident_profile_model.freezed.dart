// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resident_profile_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResidentProfileModel {

 String get name; String get email; String get phone; String get verificationCode; String get building; String get footbridge; String get floor; String get apartment; bool get isVerified; String get role; String get companyName;// GDPR Article 7(1): persisted proof of consent, captured once in
// lock_screen.dart (the screen every new user - guest or registered -
// passes through before providing real PII).
 DateTime? get termsAcceptedAt;
/// Create a copy of ResidentProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentProfileModelCopyWith<ResidentProfileModel> get copyWith => _$ResidentProfileModelCopyWithImpl<ResidentProfileModel>(this as ResidentProfileModel, _$identity);

  /// Serializes this ResidentProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentProfileModel&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.building, building) || other.building == building)&&(identical(other.footbridge, footbridge) || other.footbridge == footbridge)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.apartment, apartment) || other.apartment == apartment)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.role, role) || other.role == role)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.termsAcceptedAt, termsAcceptedAt) || other.termsAcceptedAt == termsAcceptedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,phone,verificationCode,building,footbridge,floor,apartment,isVerified,role,companyName,termsAcceptedAt);

@override
String toString() {
  return 'ResidentProfileModel(name: $name, email: $email, phone: $phone, verificationCode: $verificationCode, building: $building, footbridge: $footbridge, floor: $floor, apartment: $apartment, isVerified: $isVerified, role: $role, companyName: $companyName, termsAcceptedAt: $termsAcceptedAt)';
}


}

/// @nodoc
abstract mixin class $ResidentProfileModelCopyWith<$Res>  {
  factory $ResidentProfileModelCopyWith(ResidentProfileModel value, $Res Function(ResidentProfileModel) _then) = _$ResidentProfileModelCopyWithImpl;
@useResult
$Res call({
 String name, String email, String phone, String verificationCode, String building, String footbridge, String floor, String apartment, bool isVerified, String role, String companyName, DateTime? termsAcceptedAt
});




}
/// @nodoc
class _$ResidentProfileModelCopyWithImpl<$Res>
    implements $ResidentProfileModelCopyWith<$Res> {
  _$ResidentProfileModelCopyWithImpl(this._self, this._then);

  final ResidentProfileModel _self;
  final $Res Function(ResidentProfileModel) _then;

/// Create a copy of ResidentProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? phone = null,Object? verificationCode = null,Object? building = null,Object? footbridge = null,Object? floor = null,Object? apartment = null,Object? isVerified = null,Object? role = null,Object? companyName = null,Object? termsAcceptedAt = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,building: null == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String,footbridge: null == footbridge ? _self.footbridge : footbridge // ignore: cast_nullable_to_non_nullable
as String,floor: null == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String,apartment: null == apartment ? _self.apartment : apartment // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,termsAcceptedAt: freezed == termsAcceptedAt ? _self.termsAcceptedAt : termsAcceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResidentProfileModel].
extension ResidentProfileModelPatterns on ResidentProfileModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResidentProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResidentProfileModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResidentProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _ResidentProfileModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResidentProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _ResidentProfileModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String email,  String phone,  String verificationCode,  String building,  String footbridge,  String floor,  String apartment,  bool isVerified,  String role,  String companyName,  DateTime? termsAcceptedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResidentProfileModel() when $default != null:
return $default(_that.name,_that.email,_that.phone,_that.verificationCode,_that.building,_that.footbridge,_that.floor,_that.apartment,_that.isVerified,_that.role,_that.companyName,_that.termsAcceptedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String email,  String phone,  String verificationCode,  String building,  String footbridge,  String floor,  String apartment,  bool isVerified,  String role,  String companyName,  DateTime? termsAcceptedAt)  $default,) {final _that = this;
switch (_that) {
case _ResidentProfileModel():
return $default(_that.name,_that.email,_that.phone,_that.verificationCode,_that.building,_that.footbridge,_that.floor,_that.apartment,_that.isVerified,_that.role,_that.companyName,_that.termsAcceptedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String email,  String phone,  String verificationCode,  String building,  String footbridge,  String floor,  String apartment,  bool isVerified,  String role,  String companyName,  DateTime? termsAcceptedAt)?  $default,) {final _that = this;
switch (_that) {
case _ResidentProfileModel() when $default != null:
return $default(_that.name,_that.email,_that.phone,_that.verificationCode,_that.building,_that.footbridge,_that.floor,_that.apartment,_that.isVerified,_that.role,_that.companyName,_that.termsAcceptedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ResidentProfileModel extends ResidentProfileModel {
  const _ResidentProfileModel({this.name = '', this.email = '', this.phone = '', this.verificationCode = '', this.building = '', this.footbridge = '', this.floor = '', this.apartment = '', this.isVerified = false, this.role = 'Mieszkaniec', this.companyName = '', this.termsAcceptedAt}): super._();
  factory _ResidentProfileModel.fromJson(Map<String, dynamic> json) => _$ResidentProfileModelFromJson(json);

@override@JsonKey() final  String name;
@override@JsonKey() final  String email;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String verificationCode;
@override@JsonKey() final  String building;
@override@JsonKey() final  String footbridge;
@override@JsonKey() final  String floor;
@override@JsonKey() final  String apartment;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  String role;
@override@JsonKey() final  String companyName;
// GDPR Article 7(1): persisted proof of consent, captured once in
// lock_screen.dart (the screen every new user - guest or registered -
// passes through before providing real PII).
@override final  DateTime? termsAcceptedAt;

/// Create a copy of ResidentProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResidentProfileModelCopyWith<_ResidentProfileModel> get copyWith => __$ResidentProfileModelCopyWithImpl<_ResidentProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResidentProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResidentProfileModel&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.verificationCode, verificationCode) || other.verificationCode == verificationCode)&&(identical(other.building, building) || other.building == building)&&(identical(other.footbridge, footbridge) || other.footbridge == footbridge)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.apartment, apartment) || other.apartment == apartment)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.role, role) || other.role == role)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.termsAcceptedAt, termsAcceptedAt) || other.termsAcceptedAt == termsAcceptedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,phone,verificationCode,building,footbridge,floor,apartment,isVerified,role,companyName,termsAcceptedAt);

@override
String toString() {
  return 'ResidentProfileModel(name: $name, email: $email, phone: $phone, verificationCode: $verificationCode, building: $building, footbridge: $footbridge, floor: $floor, apartment: $apartment, isVerified: $isVerified, role: $role, companyName: $companyName, termsAcceptedAt: $termsAcceptedAt)';
}


}

/// @nodoc
abstract mixin class _$ResidentProfileModelCopyWith<$Res> implements $ResidentProfileModelCopyWith<$Res> {
  factory _$ResidentProfileModelCopyWith(_ResidentProfileModel value, $Res Function(_ResidentProfileModel) _then) = __$ResidentProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String name, String email, String phone, String verificationCode, String building, String footbridge, String floor, String apartment, bool isVerified, String role, String companyName, DateTime? termsAcceptedAt
});




}
/// @nodoc
class __$ResidentProfileModelCopyWithImpl<$Res>
    implements _$ResidentProfileModelCopyWith<$Res> {
  __$ResidentProfileModelCopyWithImpl(this._self, this._then);

  final _ResidentProfileModel _self;
  final $Res Function(_ResidentProfileModel) _then;

/// Create a copy of ResidentProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? phone = null,Object? verificationCode = null,Object? building = null,Object? footbridge = null,Object? floor = null,Object? apartment = null,Object? isVerified = null,Object? role = null,Object? companyName = null,Object? termsAcceptedAt = freezed,}) {
  return _then(_ResidentProfileModel(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,verificationCode: null == verificationCode ? _self.verificationCode : verificationCode // ignore: cast_nullable_to_non_nullable
as String,building: null == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String,footbridge: null == footbridge ? _self.footbridge : footbridge // ignore: cast_nullable_to_non_nullable
as String,floor: null == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String,apartment: null == apartment ? _self.apartment : apartment // ignore: cast_nullable_to_non_nullable
as String,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,companyName: null == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String,termsAcceptedAt: freezed == termsAcceptedAt ? _self.termsAcceptedAt : termsAcceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
