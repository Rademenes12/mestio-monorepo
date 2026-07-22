// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'building_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BuildingModel {

 String get id; String get name; String? get address; String get buildingType; int get displayOrder; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of BuildingModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BuildingModelCopyWith<BuildingModel> get copyWith => _$BuildingModelCopyWithImpl<BuildingModel>(this as BuildingModel, _$identity);

  /// Serializes this BuildingModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BuildingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.buildingType, buildingType) || other.buildingType == buildingType)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,buildingType,displayOrder,createdAt,updatedAt);

@override
String toString() {
  return 'BuildingModel(id: $id, name: $name, address: $address, buildingType: $buildingType, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $BuildingModelCopyWith<$Res>  {
  factory $BuildingModelCopyWith(BuildingModel value, $Res Function(BuildingModel) _then) = _$BuildingModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? address, String buildingType, int displayOrder, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$BuildingModelCopyWithImpl<$Res>
    implements $BuildingModelCopyWith<$Res> {
  _$BuildingModelCopyWithImpl(this._self, this._then);

  final BuildingModel _self;
  final $Res Function(BuildingModel) _then;

/// Create a copy of BuildingModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? buildingType = null,Object? displayOrder = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,buildingType: null == buildingType ? _self.buildingType : buildingType // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BuildingModel].
extension BuildingModelPatterns on BuildingModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BuildingModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BuildingModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BuildingModel value)  $default,){
final _that = this;
switch (_that) {
case _BuildingModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BuildingModel value)?  $default,){
final _that = this;
switch (_that) {
case _BuildingModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  String buildingType,  int displayOrder,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BuildingModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.buildingType,_that.displayOrder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  String buildingType,  int displayOrder,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _BuildingModel():
return $default(_that.id,_that.name,_that.address,_that.buildingType,_that.displayOrder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? address,  String buildingType,  int displayOrder,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BuildingModel() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.buildingType,_that.displayOrder,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _BuildingModel extends BuildingModel {
  const _BuildingModel({required this.id, required this.name, this.address, this.buildingType = 'residential', this.displayOrder = 0, this.createdAt, this.updatedAt}): super._();
  factory _BuildingModel.fromJson(Map<String, dynamic> json) => _$BuildingModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? address;
@override@JsonKey() final  String buildingType;
@override@JsonKey() final  int displayOrder;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of BuildingModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BuildingModelCopyWith<_BuildingModel> get copyWith => __$BuildingModelCopyWithImpl<_BuildingModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BuildingModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BuildingModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.buildingType, buildingType) || other.buildingType == buildingType)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,buildingType,displayOrder,createdAt,updatedAt);

@override
String toString() {
  return 'BuildingModel(id: $id, name: $name, address: $address, buildingType: $buildingType, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$BuildingModelCopyWith<$Res> implements $BuildingModelCopyWith<$Res> {
  factory _$BuildingModelCopyWith(_BuildingModel value, $Res Function(_BuildingModel) _then) = __$BuildingModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? address, String buildingType, int displayOrder, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$BuildingModelCopyWithImpl<$Res>
    implements _$BuildingModelCopyWith<$Res> {
  __$BuildingModelCopyWithImpl(this._self, this._then);

  final _BuildingModel _self;
  final $Res Function(_BuildingModel) _then;

/// Create a copy of BuildingModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? buildingType = null,Object? displayOrder = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_BuildingModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,buildingType: null == buildingType ? _self.buildingType : buildingType // ignore: cast_nullable_to_non_nullable
as String,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$StairwellModel {

 String get id; String get buildingId; String get name;// Inclusive floor range. Negative values represent underground garage
// floors (-6 .. -1). Replaces the old floorCount field so admins can
// configure both garage and above-ground floors.
 int get floorMin; int get floorMax;// Optional entrance label for garage floors (e.g. "A" -> "Wejście A").
// Stored per stairwell to keep the schema simple.
 String? get garageEntranceLabel; int get displayOrder; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of StairwellModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StairwellModelCopyWith<StairwellModel> get copyWith => _$StairwellModelCopyWithImpl<StairwellModel>(this as StairwellModel, _$identity);

  /// Serializes this StairwellModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StairwellModel&&(identical(other.id, id) || other.id == id)&&(identical(other.buildingId, buildingId) || other.buildingId == buildingId)&&(identical(other.name, name) || other.name == name)&&(identical(other.floorMin, floorMin) || other.floorMin == floorMin)&&(identical(other.floorMax, floorMax) || other.floorMax == floorMax)&&(identical(other.garageEntranceLabel, garageEntranceLabel) || other.garageEntranceLabel == garageEntranceLabel)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,buildingId,name,floorMin,floorMax,garageEntranceLabel,displayOrder,createdAt,updatedAt);

@override
String toString() {
  return 'StairwellModel(id: $id, buildingId: $buildingId, name: $name, floorMin: $floorMin, floorMax: $floorMax, garageEntranceLabel: $garageEntranceLabel, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StairwellModelCopyWith<$Res>  {
  factory $StairwellModelCopyWith(StairwellModel value, $Res Function(StairwellModel) _then) = _$StairwellModelCopyWithImpl;
@useResult
$Res call({
 String id, String buildingId, String name, int floorMin, int floorMax, String? garageEntranceLabel, int displayOrder, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$StairwellModelCopyWithImpl<$Res>
    implements $StairwellModelCopyWith<$Res> {
  _$StairwellModelCopyWithImpl(this._self, this._then);

  final StairwellModel _self;
  final $Res Function(StairwellModel) _then;

/// Create a copy of StairwellModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? buildingId = null,Object? name = null,Object? floorMin = null,Object? floorMax = null,Object? garageEntranceLabel = freezed,Object? displayOrder = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,buildingId: null == buildingId ? _self.buildingId : buildingId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,floorMin: null == floorMin ? _self.floorMin : floorMin // ignore: cast_nullable_to_non_nullable
as int,floorMax: null == floorMax ? _self.floorMax : floorMax // ignore: cast_nullable_to_non_nullable
as int,garageEntranceLabel: freezed == garageEntranceLabel ? _self.garageEntranceLabel : garageEntranceLabel // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [StairwellModel].
extension StairwellModelPatterns on StairwellModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StairwellModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StairwellModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StairwellModel value)  $default,){
final _that = this;
switch (_that) {
case _StairwellModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StairwellModel value)?  $default,){
final _that = this;
switch (_that) {
case _StairwellModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String buildingId,  String name,  int floorMin,  int floorMax,  String? garageEntranceLabel,  int displayOrder,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StairwellModel() when $default != null:
return $default(_that.id,_that.buildingId,_that.name,_that.floorMin,_that.floorMax,_that.garageEntranceLabel,_that.displayOrder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String buildingId,  String name,  int floorMin,  int floorMax,  String? garageEntranceLabel,  int displayOrder,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StairwellModel():
return $default(_that.id,_that.buildingId,_that.name,_that.floorMin,_that.floorMax,_that.garageEntranceLabel,_that.displayOrder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String buildingId,  String name,  int floorMin,  int floorMax,  String? garageEntranceLabel,  int displayOrder,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StairwellModel() when $default != null:
return $default(_that.id,_that.buildingId,_that.name,_that.floorMin,_that.floorMax,_that.garageEntranceLabel,_that.displayOrder,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StairwellModel extends StairwellModel {
  const _StairwellModel({required this.id, required this.buildingId, required this.name, this.floorMin = 0, this.floorMax = 4, this.garageEntranceLabel, this.displayOrder = 0, this.createdAt, this.updatedAt}): super._();
  factory _StairwellModel.fromJson(Map<String, dynamic> json) => _$StairwellModelFromJson(json);

@override final  String id;
@override final  String buildingId;
@override final  String name;
// Inclusive floor range. Negative values represent underground garage
// floors (-6 .. -1). Replaces the old floorCount field so admins can
// configure both garage and above-ground floors.
@override@JsonKey() final  int floorMin;
@override@JsonKey() final  int floorMax;
// Optional entrance label for garage floors (e.g. "A" -> "Wejście A").
// Stored per stairwell to keep the schema simple.
@override final  String? garageEntranceLabel;
@override@JsonKey() final  int displayOrder;
@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of StairwellModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StairwellModelCopyWith<_StairwellModel> get copyWith => __$StairwellModelCopyWithImpl<_StairwellModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StairwellModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StairwellModel&&(identical(other.id, id) || other.id == id)&&(identical(other.buildingId, buildingId) || other.buildingId == buildingId)&&(identical(other.name, name) || other.name == name)&&(identical(other.floorMin, floorMin) || other.floorMin == floorMin)&&(identical(other.floorMax, floorMax) || other.floorMax == floorMax)&&(identical(other.garageEntranceLabel, garageEntranceLabel) || other.garageEntranceLabel == garageEntranceLabel)&&(identical(other.displayOrder, displayOrder) || other.displayOrder == displayOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,buildingId,name,floorMin,floorMax,garageEntranceLabel,displayOrder,createdAt,updatedAt);

@override
String toString() {
  return 'StairwellModel(id: $id, buildingId: $buildingId, name: $name, floorMin: $floorMin, floorMax: $floorMax, garageEntranceLabel: $garageEntranceLabel, displayOrder: $displayOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StairwellModelCopyWith<$Res> implements $StairwellModelCopyWith<$Res> {
  factory _$StairwellModelCopyWith(_StairwellModel value, $Res Function(_StairwellModel) _then) = __$StairwellModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String buildingId, String name, int floorMin, int floorMax, String? garageEntranceLabel, int displayOrder, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$StairwellModelCopyWithImpl<$Res>
    implements _$StairwellModelCopyWith<$Res> {
  __$StairwellModelCopyWithImpl(this._self, this._then);

  final _StairwellModel _self;
  final $Res Function(_StairwellModel) _then;

/// Create a copy of StairwellModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? buildingId = null,Object? name = null,Object? floorMin = null,Object? floorMax = null,Object? garageEntranceLabel = freezed,Object? displayOrder = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_StairwellModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,buildingId: null == buildingId ? _self.buildingId : buildingId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,floorMin: null == floorMin ? _self.floorMin : floorMin // ignore: cast_nullable_to_non_nullable
as int,floorMax: null == floorMax ? _self.floorMax : floorMax // ignore: cast_nullable_to_non_nullable
as int,garageEntranceLabel: freezed == garageEntranceLabel ? _self.garageEntranceLabel : garageEntranceLabel // ignore: cast_nullable_to_non_nullable
as String?,displayOrder: null == displayOrder ? _self.displayOrder : displayOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$BuildingWithStairwells {

 BuildingModel get building; List<StairwellModel> get stairwells;
/// Create a copy of BuildingWithStairwells
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BuildingWithStairwellsCopyWith<BuildingWithStairwells> get copyWith => _$BuildingWithStairwellsCopyWithImpl<BuildingWithStairwells>(this as BuildingWithStairwells, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BuildingWithStairwells&&(identical(other.building, building) || other.building == building)&&const DeepCollectionEquality().equals(other.stairwells, stairwells));
}


@override
int get hashCode => Object.hash(runtimeType,building,const DeepCollectionEquality().hash(stairwells));

@override
String toString() {
  return 'BuildingWithStairwells(building: $building, stairwells: $stairwells)';
}


}

/// @nodoc
abstract mixin class $BuildingWithStairwellsCopyWith<$Res>  {
  factory $BuildingWithStairwellsCopyWith(BuildingWithStairwells value, $Res Function(BuildingWithStairwells) _then) = _$BuildingWithStairwellsCopyWithImpl;
@useResult
$Res call({
 BuildingModel building, List<StairwellModel> stairwells
});


$BuildingModelCopyWith<$Res> get building;

}
/// @nodoc
class _$BuildingWithStairwellsCopyWithImpl<$Res>
    implements $BuildingWithStairwellsCopyWith<$Res> {
  _$BuildingWithStairwellsCopyWithImpl(this._self, this._then);

  final BuildingWithStairwells _self;
  final $Res Function(BuildingWithStairwells) _then;

/// Create a copy of BuildingWithStairwells
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? building = null,Object? stairwells = null,}) {
  return _then(_self.copyWith(
building: null == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as BuildingModel,stairwells: null == stairwells ? _self.stairwells : stairwells // ignore: cast_nullable_to_non_nullable
as List<StairwellModel>,
  ));
}
/// Create a copy of BuildingWithStairwells
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BuildingModelCopyWith<$Res> get building {
  
  return $BuildingModelCopyWith<$Res>(_self.building, (value) {
    return _then(_self.copyWith(building: value));
  });
}
}


/// Adds pattern-matching-related methods to [BuildingWithStairwells].
extension BuildingWithStairwellsPatterns on BuildingWithStairwells {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BuildingWithStairwells value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BuildingWithStairwells() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BuildingWithStairwells value)  $default,){
final _that = this;
switch (_that) {
case _BuildingWithStairwells():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BuildingWithStairwells value)?  $default,){
final _that = this;
switch (_that) {
case _BuildingWithStairwells() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BuildingModel building,  List<StairwellModel> stairwells)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BuildingWithStairwells() when $default != null:
return $default(_that.building,_that.stairwells);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BuildingModel building,  List<StairwellModel> stairwells)  $default,) {final _that = this;
switch (_that) {
case _BuildingWithStairwells():
return $default(_that.building,_that.stairwells);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BuildingModel building,  List<StairwellModel> stairwells)?  $default,) {final _that = this;
switch (_that) {
case _BuildingWithStairwells() when $default != null:
return $default(_that.building,_that.stairwells);case _:
  return null;

}
}

}

/// @nodoc


class _BuildingWithStairwells implements BuildingWithStairwells {
  const _BuildingWithStairwells({required this.building, required final  List<StairwellModel> stairwells}): _stairwells = stairwells;
  

@override final  BuildingModel building;
 final  List<StairwellModel> _stairwells;
@override List<StairwellModel> get stairwells {
  if (_stairwells is EqualUnmodifiableListView) return _stairwells;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stairwells);
}


/// Create a copy of BuildingWithStairwells
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BuildingWithStairwellsCopyWith<_BuildingWithStairwells> get copyWith => __$BuildingWithStairwellsCopyWithImpl<_BuildingWithStairwells>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BuildingWithStairwells&&(identical(other.building, building) || other.building == building)&&const DeepCollectionEquality().equals(other._stairwells, _stairwells));
}


@override
int get hashCode => Object.hash(runtimeType,building,const DeepCollectionEquality().hash(_stairwells));

@override
String toString() {
  return 'BuildingWithStairwells(building: $building, stairwells: $stairwells)';
}


}

/// @nodoc
abstract mixin class _$BuildingWithStairwellsCopyWith<$Res> implements $BuildingWithStairwellsCopyWith<$Res> {
  factory _$BuildingWithStairwellsCopyWith(_BuildingWithStairwells value, $Res Function(_BuildingWithStairwells) _then) = __$BuildingWithStairwellsCopyWithImpl;
@override @useResult
$Res call({
 BuildingModel building, List<StairwellModel> stairwells
});


@override $BuildingModelCopyWith<$Res> get building;

}
/// @nodoc
class __$BuildingWithStairwellsCopyWithImpl<$Res>
    implements _$BuildingWithStairwellsCopyWith<$Res> {
  __$BuildingWithStairwellsCopyWithImpl(this._self, this._then);

  final _BuildingWithStairwells _self;
  final $Res Function(_BuildingWithStairwells) _then;

/// Create a copy of BuildingWithStairwells
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? building = null,Object? stairwells = null,}) {
  return _then(_BuildingWithStairwells(
building: null == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as BuildingModel,stairwells: null == stairwells ? _self._stairwells : stairwells // ignore: cast_nullable_to_non_nullable
as List<StairwellModel>,
  ));
}

/// Create a copy of BuildingWithStairwells
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BuildingModelCopyWith<$Res> get building {
  
  return $BuildingModelCopyWith<$Res>(_self.building, (value) {
    return _then(_self.copyWith(building: value));
  });
}
}

// dart format on
