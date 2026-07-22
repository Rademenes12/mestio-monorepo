// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'estate_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Estate {

 String get id; String get name; String get role;@JsonKey(name: 'company_name') String? get companyName;@JsonKey(name: 'admin_name') String? get adminName;@JsonKey(name: 'admin_email') String? get adminEmail;@JsonKey(name: 'admin_phone') String? get adminPhone;@JsonKey(name: 'hide_resident_contacts') bool get hideResidentContacts;
/// Create a copy of Estate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EstateCopyWith<Estate> get copyWith => _$EstateCopyWithImpl<Estate>(this as Estate, _$identity);

  /// Serializes this Estate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Estate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.adminName, adminName) || other.adminName == adminName)&&(identical(other.adminEmail, adminEmail) || other.adminEmail == adminEmail)&&(identical(other.adminPhone, adminPhone) || other.adminPhone == adminPhone)&&(identical(other.hideResidentContacts, hideResidentContacts) || other.hideResidentContacts == hideResidentContacts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,companyName,adminName,adminEmail,adminPhone,hideResidentContacts);

@override
String toString() {
  return 'Estate(id: $id, name: $name, role: $role, companyName: $companyName, adminName: $adminName, adminEmail: $adminEmail, adminPhone: $adminPhone, hideResidentContacts: $hideResidentContacts)';
}


}

/// @nodoc
abstract mixin class $EstateCopyWith<$Res>  {
  factory $EstateCopyWith(Estate value, $Res Function(Estate) _then) = _$EstateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String role,@JsonKey(name: 'company_name') String? companyName,@JsonKey(name: 'admin_name') String? adminName,@JsonKey(name: 'admin_email') String? adminEmail,@JsonKey(name: 'admin_phone') String? adminPhone,@JsonKey(name: 'hide_resident_contacts') bool hideResidentContacts
});




}
/// @nodoc
class _$EstateCopyWithImpl<$Res>
    implements $EstateCopyWith<$Res> {
  _$EstateCopyWithImpl(this._self, this._then);

  final Estate _self;
  final $Res Function(Estate) _then;

/// Create a copy of Estate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? role = null,Object? companyName = freezed,Object? adminName = freezed,Object? adminEmail = freezed,Object? adminPhone = freezed,Object? hideResidentContacts = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,adminName: freezed == adminName ? _self.adminName : adminName // ignore: cast_nullable_to_non_nullable
as String?,adminEmail: freezed == adminEmail ? _self.adminEmail : adminEmail // ignore: cast_nullable_to_non_nullable
as String?,adminPhone: freezed == adminPhone ? _self.adminPhone : adminPhone // ignore: cast_nullable_to_non_nullable
as String?,hideResidentContacts: null == hideResidentContacts ? _self.hideResidentContacts : hideResidentContacts // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Estate].
extension EstatePatterns on Estate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Estate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Estate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Estate value)  $default,){
final _that = this;
switch (_that) {
case _Estate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Estate value)?  $default,){
final _that = this;
switch (_that) {
case _Estate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String role, @JsonKey(name: 'company_name')  String? companyName, @JsonKey(name: 'admin_name')  String? adminName, @JsonKey(name: 'admin_email')  String? adminEmail, @JsonKey(name: 'admin_phone')  String? adminPhone, @JsonKey(name: 'hide_resident_contacts')  bool hideResidentContacts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Estate() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.companyName,_that.adminName,_that.adminEmail,_that.adminPhone,_that.hideResidentContacts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String role, @JsonKey(name: 'company_name')  String? companyName, @JsonKey(name: 'admin_name')  String? adminName, @JsonKey(name: 'admin_email')  String? adminEmail, @JsonKey(name: 'admin_phone')  String? adminPhone, @JsonKey(name: 'hide_resident_contacts')  bool hideResidentContacts)  $default,) {final _that = this;
switch (_that) {
case _Estate():
return $default(_that.id,_that.name,_that.role,_that.companyName,_that.adminName,_that.adminEmail,_that.adminPhone,_that.hideResidentContacts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String role, @JsonKey(name: 'company_name')  String? companyName, @JsonKey(name: 'admin_name')  String? adminName, @JsonKey(name: 'admin_email')  String? adminEmail, @JsonKey(name: 'admin_phone')  String? adminPhone, @JsonKey(name: 'hide_resident_contacts')  bool hideResidentContacts)?  $default,) {final _that = this;
switch (_that) {
case _Estate() when $default != null:
return $default(_that.id,_that.name,_that.role,_that.companyName,_that.adminName,_that.adminEmail,_that.adminPhone,_that.hideResidentContacts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Estate extends Estate {
  const _Estate({required this.id, required this.name, this.role = 'resident', @JsonKey(name: 'company_name') this.companyName, @JsonKey(name: 'admin_name') this.adminName, @JsonKey(name: 'admin_email') this.adminEmail, @JsonKey(name: 'admin_phone') this.adminPhone, @JsonKey(name: 'hide_resident_contacts') this.hideResidentContacts = false}): super._();
  factory _Estate.fromJson(Map<String, dynamic> json) => _$EstateFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String role;
@override@JsonKey(name: 'company_name') final  String? companyName;
@override@JsonKey(name: 'admin_name') final  String? adminName;
@override@JsonKey(name: 'admin_email') final  String? adminEmail;
@override@JsonKey(name: 'admin_phone') final  String? adminPhone;
@override@JsonKey(name: 'hide_resident_contacts') final  bool hideResidentContacts;

/// Create a copy of Estate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EstateCopyWith<_Estate> get copyWith => __$EstateCopyWithImpl<_Estate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EstateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Estate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.role, role) || other.role == role)&&(identical(other.companyName, companyName) || other.companyName == companyName)&&(identical(other.adminName, adminName) || other.adminName == adminName)&&(identical(other.adminEmail, adminEmail) || other.adminEmail == adminEmail)&&(identical(other.adminPhone, adminPhone) || other.adminPhone == adminPhone)&&(identical(other.hideResidentContacts, hideResidentContacts) || other.hideResidentContacts == hideResidentContacts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,role,companyName,adminName,adminEmail,adminPhone,hideResidentContacts);

@override
String toString() {
  return 'Estate(id: $id, name: $name, role: $role, companyName: $companyName, adminName: $adminName, adminEmail: $adminEmail, adminPhone: $adminPhone, hideResidentContacts: $hideResidentContacts)';
}


}

/// @nodoc
abstract mixin class _$EstateCopyWith<$Res> implements $EstateCopyWith<$Res> {
  factory _$EstateCopyWith(_Estate value, $Res Function(_Estate) _then) = __$EstateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String role,@JsonKey(name: 'company_name') String? companyName,@JsonKey(name: 'admin_name') String? adminName,@JsonKey(name: 'admin_email') String? adminEmail,@JsonKey(name: 'admin_phone') String? adminPhone,@JsonKey(name: 'hide_resident_contacts') bool hideResidentContacts
});




}
/// @nodoc
class __$EstateCopyWithImpl<$Res>
    implements _$EstateCopyWith<$Res> {
  __$EstateCopyWithImpl(this._self, this._then);

  final _Estate _self;
  final $Res Function(_Estate) _then;

/// Create a copy of Estate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? role = null,Object? companyName = freezed,Object? adminName = freezed,Object? adminEmail = freezed,Object? adminPhone = freezed,Object? hideResidentContacts = null,}) {
  return _then(_Estate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,companyName: freezed == companyName ? _self.companyName : companyName // ignore: cast_nullable_to_non_nullable
as String?,adminName: freezed == adminName ? _self.adminName : adminName // ignore: cast_nullable_to_non_nullable
as String?,adminEmail: freezed == adminEmail ? _self.adminEmail : adminEmail // ignore: cast_nullable_to_non_nullable
as String?,adminPhone: freezed == adminPhone ? _self.adminPhone : adminPhone // ignore: cast_nullable_to_non_nullable
as String?,hideResidentContacts: null == hideResidentContacts ? _self.hideResidentContacts : hideResidentContacts // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
