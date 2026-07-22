// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resident_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResidentModel {

 String get id; String get userId; String? get buildingId; String? get stairwellId; String? get apartmentNumber; String get firstName; String get lastName; String? get phone; String get email; DateTime? get registeredAt; String? get invitationCodeUsed; bool get isActive;// Location labels coming from `fixflow_resident_profiles` (e.g.
// "Budynek 1", "Klatka A", "Piętro 3"). Optional so existing fixtures
// and the legacy `fixflow_residents` source stay compatible.
 String? get building; String? get footbridge; String? get floor;
/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResidentModelCopyWith<ResidentModel> get copyWith => _$ResidentModelCopyWithImpl<ResidentModel>(this as ResidentModel, _$identity);

  /// Serializes this ResidentModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResidentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.buildingId, buildingId) || other.buildingId == buildingId)&&(identical(other.stairwellId, stairwellId) || other.stairwellId == stairwellId)&&(identical(other.apartmentNumber, apartmentNumber) || other.apartmentNumber == apartmentNumber)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.registeredAt, registeredAt) || other.registeredAt == registeredAt)&&(identical(other.invitationCodeUsed, invitationCodeUsed) || other.invitationCodeUsed == invitationCodeUsed)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.building, building) || other.building == building)&&(identical(other.footbridge, footbridge) || other.footbridge == footbridge)&&(identical(other.floor, floor) || other.floor == floor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,buildingId,stairwellId,apartmentNumber,firstName,lastName,phone,email,registeredAt,invitationCodeUsed,isActive,building,footbridge,floor);

@override
String toString() {
  return 'ResidentModel(id: $id, userId: $userId, buildingId: $buildingId, stairwellId: $stairwellId, apartmentNumber: $apartmentNumber, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, registeredAt: $registeredAt, invitationCodeUsed: $invitationCodeUsed, isActive: $isActive, building: $building, footbridge: $footbridge, floor: $floor)';
}


}

/// @nodoc
abstract mixin class $ResidentModelCopyWith<$Res>  {
  factory $ResidentModelCopyWith(ResidentModel value, $Res Function(ResidentModel) _then) = _$ResidentModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? buildingId, String? stairwellId, String? apartmentNumber, String firstName, String lastName, String? phone, String email, DateTime? registeredAt, String? invitationCodeUsed, bool isActive, String? building, String? footbridge, String? floor
});




}
/// @nodoc
class _$ResidentModelCopyWithImpl<$Res>
    implements $ResidentModelCopyWith<$Res> {
  _$ResidentModelCopyWithImpl(this._self, this._then);

  final ResidentModel _self;
  final $Res Function(ResidentModel) _then;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? buildingId = freezed,Object? stairwellId = freezed,Object? apartmentNumber = freezed,Object? firstName = null,Object? lastName = null,Object? phone = freezed,Object? email = null,Object? registeredAt = freezed,Object? invitationCodeUsed = freezed,Object? isActive = null,Object? building = freezed,Object? footbridge = freezed,Object? floor = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,buildingId: freezed == buildingId ? _self.buildingId : buildingId // ignore: cast_nullable_to_non_nullable
as String?,stairwellId: freezed == stairwellId ? _self.stairwellId : stairwellId // ignore: cast_nullable_to_non_nullable
as String?,apartmentNumber: freezed == apartmentNumber ? _self.apartmentNumber : apartmentNumber // ignore: cast_nullable_to_non_nullable
as String?,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,registeredAt: freezed == registeredAt ? _self.registeredAt : registeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,invitationCodeUsed: freezed == invitationCodeUsed ? _self.invitationCodeUsed : invitationCodeUsed // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,footbridge: freezed == footbridge ? _self.footbridge : footbridge // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ResidentModel].
extension ResidentModelPatterns on ResidentModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResidentModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResidentModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResidentModel value)  $default,){
final _that = this;
switch (_that) {
case _ResidentModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResidentModel value)?  $default,){
final _that = this;
switch (_that) {
case _ResidentModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? buildingId,  String? stairwellId,  String? apartmentNumber,  String firstName,  String lastName,  String? phone,  String email,  DateTime? registeredAt,  String? invitationCodeUsed,  bool isActive,  String? building,  String? footbridge,  String? floor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResidentModel() when $default != null:
return $default(_that.id,_that.userId,_that.buildingId,_that.stairwellId,_that.apartmentNumber,_that.firstName,_that.lastName,_that.phone,_that.email,_that.registeredAt,_that.invitationCodeUsed,_that.isActive,_that.building,_that.footbridge,_that.floor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? buildingId,  String? stairwellId,  String? apartmentNumber,  String firstName,  String lastName,  String? phone,  String email,  DateTime? registeredAt,  String? invitationCodeUsed,  bool isActive,  String? building,  String? footbridge,  String? floor)  $default,) {final _that = this;
switch (_that) {
case _ResidentModel():
return $default(_that.id,_that.userId,_that.buildingId,_that.stairwellId,_that.apartmentNumber,_that.firstName,_that.lastName,_that.phone,_that.email,_that.registeredAt,_that.invitationCodeUsed,_that.isActive,_that.building,_that.footbridge,_that.floor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? buildingId,  String? stairwellId,  String? apartmentNumber,  String firstName,  String lastName,  String? phone,  String email,  DateTime? registeredAt,  String? invitationCodeUsed,  bool isActive,  String? building,  String? footbridge,  String? floor)?  $default,) {final _that = this;
switch (_that) {
case _ResidentModel() when $default != null:
return $default(_that.id,_that.userId,_that.buildingId,_that.stairwellId,_that.apartmentNumber,_that.firstName,_that.lastName,_that.phone,_that.email,_that.registeredAt,_that.invitationCodeUsed,_that.isActive,_that.building,_that.footbridge,_that.floor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResidentModel implements ResidentModel {
  const _ResidentModel({required this.id, required this.userId, this.buildingId, this.stairwellId, this.apartmentNumber, required this.firstName, required this.lastName, this.phone, required this.email, this.registeredAt, this.invitationCodeUsed, this.isActive = true, this.building, this.footbridge, this.floor});
  factory _ResidentModel.fromJson(Map<String, dynamic> json) => _$ResidentModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? buildingId;
@override final  String? stairwellId;
@override final  String? apartmentNumber;
@override final  String firstName;
@override final  String lastName;
@override final  String? phone;
@override final  String email;
@override final  DateTime? registeredAt;
@override final  String? invitationCodeUsed;
@override@JsonKey() final  bool isActive;
// Location labels coming from `fixflow_resident_profiles` (e.g.
// "Budynek 1", "Klatka A", "Piętro 3"). Optional so existing fixtures
// and the legacy `fixflow_residents` source stay compatible.
@override final  String? building;
@override final  String? footbridge;
@override final  String? floor;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResidentModelCopyWith<_ResidentModel> get copyWith => __$ResidentModelCopyWithImpl<_ResidentModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResidentModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResidentModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.buildingId, buildingId) || other.buildingId == buildingId)&&(identical(other.stairwellId, stairwellId) || other.stairwellId == stairwellId)&&(identical(other.apartmentNumber, apartmentNumber) || other.apartmentNumber == apartmentNumber)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.registeredAt, registeredAt) || other.registeredAt == registeredAt)&&(identical(other.invitationCodeUsed, invitationCodeUsed) || other.invitationCodeUsed == invitationCodeUsed)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.building, building) || other.building == building)&&(identical(other.footbridge, footbridge) || other.footbridge == footbridge)&&(identical(other.floor, floor) || other.floor == floor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,buildingId,stairwellId,apartmentNumber,firstName,lastName,phone,email,registeredAt,invitationCodeUsed,isActive,building,footbridge,floor);

@override
String toString() {
  return 'ResidentModel(id: $id, userId: $userId, buildingId: $buildingId, stairwellId: $stairwellId, apartmentNumber: $apartmentNumber, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, registeredAt: $registeredAt, invitationCodeUsed: $invitationCodeUsed, isActive: $isActive, building: $building, footbridge: $footbridge, floor: $floor)';
}


}

/// @nodoc
abstract mixin class _$ResidentModelCopyWith<$Res> implements $ResidentModelCopyWith<$Res> {
  factory _$ResidentModelCopyWith(_ResidentModel value, $Res Function(_ResidentModel) _then) = __$ResidentModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? buildingId, String? stairwellId, String? apartmentNumber, String firstName, String lastName, String? phone, String email, DateTime? registeredAt, String? invitationCodeUsed, bool isActive, String? building, String? footbridge, String? floor
});




}
/// @nodoc
class __$ResidentModelCopyWithImpl<$Res>
    implements _$ResidentModelCopyWith<$Res> {
  __$ResidentModelCopyWithImpl(this._self, this._then);

  final _ResidentModel _self;
  final $Res Function(_ResidentModel) _then;

/// Create a copy of ResidentModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? buildingId = freezed,Object? stairwellId = freezed,Object? apartmentNumber = freezed,Object? firstName = null,Object? lastName = null,Object? phone = freezed,Object? email = null,Object? registeredAt = freezed,Object? invitationCodeUsed = freezed,Object? isActive = null,Object? building = freezed,Object? footbridge = freezed,Object? floor = freezed,}) {
  return _then(_ResidentModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,buildingId: freezed == buildingId ? _self.buildingId : buildingId // ignore: cast_nullable_to_non_nullable
as String?,stairwellId: freezed == stairwellId ? _self.stairwellId : stairwellId // ignore: cast_nullable_to_non_nullable
as String?,apartmentNumber: freezed == apartmentNumber ? _self.apartmentNumber : apartmentNumber // ignore: cast_nullable_to_non_nullable
as String?,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,registeredAt: freezed == registeredAt ? _self.registeredAt : registeredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,invitationCodeUsed: freezed == invitationCodeUsed ? _self.invitationCodeUsed : invitationCodeUsed // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,footbridge: freezed == footbridge ? _self.footbridge : footbridge // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
