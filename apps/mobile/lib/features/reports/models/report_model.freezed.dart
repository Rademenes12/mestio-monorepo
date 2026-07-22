// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReportModel {

 String get id;/// User-friendly display ID in format FX-####
 String? get displayId; String get title; String get description; String get category; String get reporterName; String get reporterEmail; String get reporterBuilding; String get reporterFootbridge; String get reporterFloor; String get reporterApartment;/// Legacy text status field - use [resolvedStatus] for type-safe access
 String get status;/// New enum status from database (status_enum column)
 String? get statusEnum; int get timestamp; String get estateId; String? get photoPath; double? get latitude; double? get longitude;/// Additional info for management (e.g., "police will arrive")
 String? get additionalInfo; String? get assignedTo; String? get assignedToUserId; String? get assignedToName; String? get assignedToRole; String? get boardNotes; String? get techNotes; String? get attachmentsJson; bool get revealBoardNotesToTech;/// Priority level: 'low', 'normal', 'high', 'critical'
 String? get priority;/// SLA deadline timestamp (ISO 8601)
 String? get slaDeadline;/// Customer satisfaction rating 1-5 (set by resident after closure)
 int? get csatRating;/// Audit trail JSON array of {action, user_id, timestamp, details}
@JsonKey(name: 'audit_trail') List<Map<String, dynamic>>? get auditTrail;// Client-side only flag. Excluded from JSON to avoid breaking Supabase insert
// (no `is_synced` column on fixflow_reports) and SQLite insert (no column either).
// Local cache persists it via an explicit `is_synced` INTEGER column, not via toJson.
@JsonKey(includeFromJson: false, includeToJson: false) bool get isSynced;
/// Create a copy of ReportModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReportModelCopyWith<ReportModel> get copyWith => _$ReportModelCopyWithImpl<ReportModel>(this as ReportModel, _$identity);

  /// Serializes this ReportModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.displayId, displayId) || other.displayId == displayId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.reporterName, reporterName) || other.reporterName == reporterName)&&(identical(other.reporterEmail, reporterEmail) || other.reporterEmail == reporterEmail)&&(identical(other.reporterBuilding, reporterBuilding) || other.reporterBuilding == reporterBuilding)&&(identical(other.reporterFootbridge, reporterFootbridge) || other.reporterFootbridge == reporterFootbridge)&&(identical(other.reporterFloor, reporterFloor) || other.reporterFloor == reporterFloor)&&(identical(other.reporterApartment, reporterApartment) || other.reporterApartment == reporterApartment)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusEnum, statusEnum) || other.statusEnum == statusEnum)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.additionalInfo, additionalInfo) || other.additionalInfo == additionalInfo)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.assignedToUserId, assignedToUserId) || other.assignedToUserId == assignedToUserId)&&(identical(other.assignedToName, assignedToName) || other.assignedToName == assignedToName)&&(identical(other.assignedToRole, assignedToRole) || other.assignedToRole == assignedToRole)&&(identical(other.boardNotes, boardNotes) || other.boardNotes == boardNotes)&&(identical(other.techNotes, techNotes) || other.techNotes == techNotes)&&(identical(other.attachmentsJson, attachmentsJson) || other.attachmentsJson == attachmentsJson)&&(identical(other.revealBoardNotesToTech, revealBoardNotesToTech) || other.revealBoardNotesToTech == revealBoardNotesToTech)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.slaDeadline, slaDeadline) || other.slaDeadline == slaDeadline)&&(identical(other.csatRating, csatRating) || other.csatRating == csatRating)&&const DeepCollectionEquality().equals(other.auditTrail, auditTrail)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,displayId,title,description,category,reporterName,reporterEmail,reporterBuilding,reporterFootbridge,reporterFloor,reporterApartment,status,statusEnum,timestamp,estateId,photoPath,latitude,longitude,additionalInfo,assignedTo,assignedToUserId,assignedToName,assignedToRole,boardNotes,techNotes,attachmentsJson,revealBoardNotesToTech,priority,slaDeadline,csatRating,const DeepCollectionEquality().hash(auditTrail),isSynced]);

@override
String toString() {
  return 'ReportModel(id: $id, displayId: $displayId, title: $title, description: $description, category: $category, reporterName: $reporterName, reporterEmail: $reporterEmail, reporterBuilding: $reporterBuilding, reporterFootbridge: $reporterFootbridge, reporterFloor: $reporterFloor, reporterApartment: $reporterApartment, status: $status, statusEnum: $statusEnum, timestamp: $timestamp, estateId: $estateId, photoPath: $photoPath, latitude: $latitude, longitude: $longitude, additionalInfo: $additionalInfo, assignedTo: $assignedTo, assignedToUserId: $assignedToUserId, assignedToName: $assignedToName, assignedToRole: $assignedToRole, boardNotes: $boardNotes, techNotes: $techNotes, attachmentsJson: $attachmentsJson, revealBoardNotesToTech: $revealBoardNotesToTech, priority: $priority, slaDeadline: $slaDeadline, csatRating: $csatRating, auditTrail: $auditTrail, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class $ReportModelCopyWith<$Res>  {
  factory $ReportModelCopyWith(ReportModel value, $Res Function(ReportModel) _then) = _$ReportModelCopyWithImpl;
@useResult
$Res call({
 String id, String? displayId, String title, String description, String category, String reporterName, String reporterEmail, String reporterBuilding, String reporterFootbridge, String reporterFloor, String reporterApartment, String status, String? statusEnum, int timestamp, String estateId, String? photoPath, double? latitude, double? longitude, String? additionalInfo, String? assignedTo, String? assignedToUserId, String? assignedToName, String? assignedToRole, String? boardNotes, String? techNotes, String? attachmentsJson, bool revealBoardNotesToTech, String? priority, String? slaDeadline, int? csatRating,@JsonKey(name: 'audit_trail') List<Map<String, dynamic>>? auditTrail,@JsonKey(includeFromJson: false, includeToJson: false) bool isSynced
});




}
/// @nodoc
class _$ReportModelCopyWithImpl<$Res>
    implements $ReportModelCopyWith<$Res> {
  _$ReportModelCopyWithImpl(this._self, this._then);

  final ReportModel _self;
  final $Res Function(ReportModel) _then;

/// Create a copy of ReportModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayId = freezed,Object? title = null,Object? description = null,Object? category = null,Object? reporterName = null,Object? reporterEmail = null,Object? reporterBuilding = null,Object? reporterFootbridge = null,Object? reporterFloor = null,Object? reporterApartment = null,Object? status = null,Object? statusEnum = freezed,Object? timestamp = null,Object? estateId = null,Object? photoPath = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? additionalInfo = freezed,Object? assignedTo = freezed,Object? assignedToUserId = freezed,Object? assignedToName = freezed,Object? assignedToRole = freezed,Object? boardNotes = freezed,Object? techNotes = freezed,Object? attachmentsJson = freezed,Object? revealBoardNotesToTech = null,Object? priority = freezed,Object? slaDeadline = freezed,Object? csatRating = freezed,Object? auditTrail = freezed,Object? isSynced = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayId: freezed == displayId ? _self.displayId : displayId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,reporterName: null == reporterName ? _self.reporterName : reporterName // ignore: cast_nullable_to_non_nullable
as String,reporterEmail: null == reporterEmail ? _self.reporterEmail : reporterEmail // ignore: cast_nullable_to_non_nullable
as String,reporterBuilding: null == reporterBuilding ? _self.reporterBuilding : reporterBuilding // ignore: cast_nullable_to_non_nullable
as String,reporterFootbridge: null == reporterFootbridge ? _self.reporterFootbridge : reporterFootbridge // ignore: cast_nullable_to_non_nullable
as String,reporterFloor: null == reporterFloor ? _self.reporterFloor : reporterFloor // ignore: cast_nullable_to_non_nullable
as String,reporterApartment: null == reporterApartment ? _self.reporterApartment : reporterApartment // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusEnum: freezed == statusEnum ? _self.statusEnum : statusEnum // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,estateId: null == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,additionalInfo: freezed == additionalInfo ? _self.additionalInfo : additionalInfo // ignore: cast_nullable_to_non_nullable
as String?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,assignedToUserId: freezed == assignedToUserId ? _self.assignedToUserId : assignedToUserId // ignore: cast_nullable_to_non_nullable
as String?,assignedToName: freezed == assignedToName ? _self.assignedToName : assignedToName // ignore: cast_nullable_to_non_nullable
as String?,assignedToRole: freezed == assignedToRole ? _self.assignedToRole : assignedToRole // ignore: cast_nullable_to_non_nullable
as String?,boardNotes: freezed == boardNotes ? _self.boardNotes : boardNotes // ignore: cast_nullable_to_non_nullable
as String?,techNotes: freezed == techNotes ? _self.techNotes : techNotes // ignore: cast_nullable_to_non_nullable
as String?,attachmentsJson: freezed == attachmentsJson ? _self.attachmentsJson : attachmentsJson // ignore: cast_nullable_to_non_nullable
as String?,revealBoardNotesToTech: null == revealBoardNotesToTech ? _self.revealBoardNotesToTech : revealBoardNotesToTech // ignore: cast_nullable_to_non_nullable
as bool,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,slaDeadline: freezed == slaDeadline ? _self.slaDeadline : slaDeadline // ignore: cast_nullable_to_non_nullable
as String?,csatRating: freezed == csatRating ? _self.csatRating : csatRating // ignore: cast_nullable_to_non_nullable
as int?,auditTrail: freezed == auditTrail ? _self.auditTrail : auditTrail // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ReportModel].
extension ReportModelPatterns on ReportModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReportModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReportModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReportModel value)  $default,){
final _that = this;
switch (_that) {
case _ReportModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReportModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReportModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? displayId,  String title,  String description,  String category,  String reporterName,  String reporterEmail,  String reporterBuilding,  String reporterFootbridge,  String reporterFloor,  String reporterApartment,  String status,  String? statusEnum,  int timestamp,  String estateId,  String? photoPath,  double? latitude,  double? longitude,  String? additionalInfo,  String? assignedTo,  String? assignedToUserId,  String? assignedToName,  String? assignedToRole,  String? boardNotes,  String? techNotes,  String? attachmentsJson,  bool revealBoardNotesToTech,  String? priority,  String? slaDeadline,  int? csatRating, @JsonKey(name: 'audit_trail')  List<Map<String, dynamic>>? auditTrail, @JsonKey(includeFromJson: false, includeToJson: false)  bool isSynced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReportModel() when $default != null:
return $default(_that.id,_that.displayId,_that.title,_that.description,_that.category,_that.reporterName,_that.reporterEmail,_that.reporterBuilding,_that.reporterFootbridge,_that.reporterFloor,_that.reporterApartment,_that.status,_that.statusEnum,_that.timestamp,_that.estateId,_that.photoPath,_that.latitude,_that.longitude,_that.additionalInfo,_that.assignedTo,_that.assignedToUserId,_that.assignedToName,_that.assignedToRole,_that.boardNotes,_that.techNotes,_that.attachmentsJson,_that.revealBoardNotesToTech,_that.priority,_that.slaDeadline,_that.csatRating,_that.auditTrail,_that.isSynced);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? displayId,  String title,  String description,  String category,  String reporterName,  String reporterEmail,  String reporterBuilding,  String reporterFootbridge,  String reporterFloor,  String reporterApartment,  String status,  String? statusEnum,  int timestamp,  String estateId,  String? photoPath,  double? latitude,  double? longitude,  String? additionalInfo,  String? assignedTo,  String? assignedToUserId,  String? assignedToName,  String? assignedToRole,  String? boardNotes,  String? techNotes,  String? attachmentsJson,  bool revealBoardNotesToTech,  String? priority,  String? slaDeadline,  int? csatRating, @JsonKey(name: 'audit_trail')  List<Map<String, dynamic>>? auditTrail, @JsonKey(includeFromJson: false, includeToJson: false)  bool isSynced)  $default,) {final _that = this;
switch (_that) {
case _ReportModel():
return $default(_that.id,_that.displayId,_that.title,_that.description,_that.category,_that.reporterName,_that.reporterEmail,_that.reporterBuilding,_that.reporterFootbridge,_that.reporterFloor,_that.reporterApartment,_that.status,_that.statusEnum,_that.timestamp,_that.estateId,_that.photoPath,_that.latitude,_that.longitude,_that.additionalInfo,_that.assignedTo,_that.assignedToUserId,_that.assignedToName,_that.assignedToRole,_that.boardNotes,_that.techNotes,_that.attachmentsJson,_that.revealBoardNotesToTech,_that.priority,_that.slaDeadline,_that.csatRating,_that.auditTrail,_that.isSynced);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? displayId,  String title,  String description,  String category,  String reporterName,  String reporterEmail,  String reporterBuilding,  String reporterFootbridge,  String reporterFloor,  String reporterApartment,  String status,  String? statusEnum,  int timestamp,  String estateId,  String? photoPath,  double? latitude,  double? longitude,  String? additionalInfo,  String? assignedTo,  String? assignedToUserId,  String? assignedToName,  String? assignedToRole,  String? boardNotes,  String? techNotes,  String? attachmentsJson,  bool revealBoardNotesToTech,  String? priority,  String? slaDeadline,  int? csatRating, @JsonKey(name: 'audit_trail')  List<Map<String, dynamic>>? auditTrail, @JsonKey(includeFromJson: false, includeToJson: false)  bool isSynced)?  $default,) {final _that = this;
switch (_that) {
case _ReportModel() when $default != null:
return $default(_that.id,_that.displayId,_that.title,_that.description,_that.category,_that.reporterName,_that.reporterEmail,_that.reporterBuilding,_that.reporterFootbridge,_that.reporterFloor,_that.reporterApartment,_that.status,_that.statusEnum,_that.timestamp,_that.estateId,_that.photoPath,_that.latitude,_that.longitude,_that.additionalInfo,_that.assignedTo,_that.assignedToUserId,_that.assignedToName,_that.assignedToRole,_that.boardNotes,_that.techNotes,_that.attachmentsJson,_that.revealBoardNotesToTech,_that.priority,_that.slaDeadline,_that.csatRating,_that.auditTrail,_that.isSynced);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ReportModel extends ReportModel {
  const _ReportModel({required this.id, this.displayId, required this.title, required this.description, required this.category, this.reporterName = '', this.reporterEmail = '', this.reporterBuilding = '', this.reporterFootbridge = '', this.reporterFloor = '', this.reporterApartment = '', this.status = 'Nowe', this.statusEnum, required this.timestamp, required this.estateId, this.photoPath, this.latitude, this.longitude, this.additionalInfo, this.assignedTo, this.assignedToUserId, this.assignedToName, this.assignedToRole, this.boardNotes, this.techNotes, this.attachmentsJson, this.revealBoardNotesToTech = false, this.priority = 'normal', this.slaDeadline, this.csatRating, @JsonKey(name: 'audit_trail') final  List<Map<String, dynamic>>? auditTrail, @JsonKey(includeFromJson: false, includeToJson: false) this.isSynced = false}): _auditTrail = auditTrail,super._();
  factory _ReportModel.fromJson(Map<String, dynamic> json) => _$ReportModelFromJson(json);

@override final  String id;
/// User-friendly display ID in format FX-####
@override final  String? displayId;
@override final  String title;
@override final  String description;
@override final  String category;
@override@JsonKey() final  String reporterName;
@override@JsonKey() final  String reporterEmail;
@override@JsonKey() final  String reporterBuilding;
@override@JsonKey() final  String reporterFootbridge;
@override@JsonKey() final  String reporterFloor;
@override@JsonKey() final  String reporterApartment;
/// Legacy text status field - use [resolvedStatus] for type-safe access
@override@JsonKey() final  String status;
/// New enum status from database (status_enum column)
@override final  String? statusEnum;
@override final  int timestamp;
@override final  String estateId;
@override final  String? photoPath;
@override final  double? latitude;
@override final  double? longitude;
/// Additional info for management (e.g., "police will arrive")
@override final  String? additionalInfo;
@override final  String? assignedTo;
@override final  String? assignedToUserId;
@override final  String? assignedToName;
@override final  String? assignedToRole;
@override final  String? boardNotes;
@override final  String? techNotes;
@override final  String? attachmentsJson;
@override@JsonKey() final  bool revealBoardNotesToTech;
/// Priority level: 'low', 'normal', 'high', 'critical'
@override@JsonKey() final  String? priority;
/// SLA deadline timestamp (ISO 8601)
@override final  String? slaDeadline;
/// Customer satisfaction rating 1-5 (set by resident after closure)
@override final  int? csatRating;
/// Audit trail JSON array of {action, user_id, timestamp, details}
 final  List<Map<String, dynamic>>? _auditTrail;
/// Audit trail JSON array of {action, user_id, timestamp, details}
@override@JsonKey(name: 'audit_trail') List<Map<String, dynamic>>? get auditTrail {
  final value = _auditTrail;
  if (value == null) return null;
  if (_auditTrail is EqualUnmodifiableListView) return _auditTrail;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Client-side only flag. Excluded from JSON to avoid breaking Supabase insert
// (no `is_synced` column on fixflow_reports) and SQLite insert (no column either).
// Local cache persists it via an explicit `is_synced` INTEGER column, not via toJson.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool isSynced;

/// Create a copy of ReportModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReportModelCopyWith<_ReportModel> get copyWith => __$ReportModelCopyWithImpl<_ReportModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReportModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReportModel&&(identical(other.id, id) || other.id == id)&&(identical(other.displayId, displayId) || other.displayId == displayId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.category, category) || other.category == category)&&(identical(other.reporterName, reporterName) || other.reporterName == reporterName)&&(identical(other.reporterEmail, reporterEmail) || other.reporterEmail == reporterEmail)&&(identical(other.reporterBuilding, reporterBuilding) || other.reporterBuilding == reporterBuilding)&&(identical(other.reporterFootbridge, reporterFootbridge) || other.reporterFootbridge == reporterFootbridge)&&(identical(other.reporterFloor, reporterFloor) || other.reporterFloor == reporterFloor)&&(identical(other.reporterApartment, reporterApartment) || other.reporterApartment == reporterApartment)&&(identical(other.status, status) || other.status == status)&&(identical(other.statusEnum, statusEnum) || other.statusEnum == statusEnum)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.estateId, estateId) || other.estateId == estateId)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.additionalInfo, additionalInfo) || other.additionalInfo == additionalInfo)&&(identical(other.assignedTo, assignedTo) || other.assignedTo == assignedTo)&&(identical(other.assignedToUserId, assignedToUserId) || other.assignedToUserId == assignedToUserId)&&(identical(other.assignedToName, assignedToName) || other.assignedToName == assignedToName)&&(identical(other.assignedToRole, assignedToRole) || other.assignedToRole == assignedToRole)&&(identical(other.boardNotes, boardNotes) || other.boardNotes == boardNotes)&&(identical(other.techNotes, techNotes) || other.techNotes == techNotes)&&(identical(other.attachmentsJson, attachmentsJson) || other.attachmentsJson == attachmentsJson)&&(identical(other.revealBoardNotesToTech, revealBoardNotesToTech) || other.revealBoardNotesToTech == revealBoardNotesToTech)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.slaDeadline, slaDeadline) || other.slaDeadline == slaDeadline)&&(identical(other.csatRating, csatRating) || other.csatRating == csatRating)&&const DeepCollectionEquality().equals(other._auditTrail, _auditTrail)&&(identical(other.isSynced, isSynced) || other.isSynced == isSynced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,displayId,title,description,category,reporterName,reporterEmail,reporterBuilding,reporterFootbridge,reporterFloor,reporterApartment,status,statusEnum,timestamp,estateId,photoPath,latitude,longitude,additionalInfo,assignedTo,assignedToUserId,assignedToName,assignedToRole,boardNotes,techNotes,attachmentsJson,revealBoardNotesToTech,priority,slaDeadline,csatRating,const DeepCollectionEquality().hash(_auditTrail),isSynced]);

@override
String toString() {
  return 'ReportModel(id: $id, displayId: $displayId, title: $title, description: $description, category: $category, reporterName: $reporterName, reporterEmail: $reporterEmail, reporterBuilding: $reporterBuilding, reporterFootbridge: $reporterFootbridge, reporterFloor: $reporterFloor, reporterApartment: $reporterApartment, status: $status, statusEnum: $statusEnum, timestamp: $timestamp, estateId: $estateId, photoPath: $photoPath, latitude: $latitude, longitude: $longitude, additionalInfo: $additionalInfo, assignedTo: $assignedTo, assignedToUserId: $assignedToUserId, assignedToName: $assignedToName, assignedToRole: $assignedToRole, boardNotes: $boardNotes, techNotes: $techNotes, attachmentsJson: $attachmentsJson, revealBoardNotesToTech: $revealBoardNotesToTech, priority: $priority, slaDeadline: $slaDeadline, csatRating: $csatRating, auditTrail: $auditTrail, isSynced: $isSynced)';
}


}

/// @nodoc
abstract mixin class _$ReportModelCopyWith<$Res> implements $ReportModelCopyWith<$Res> {
  factory _$ReportModelCopyWith(_ReportModel value, $Res Function(_ReportModel) _then) = __$ReportModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? displayId, String title, String description, String category, String reporterName, String reporterEmail, String reporterBuilding, String reporterFootbridge, String reporterFloor, String reporterApartment, String status, String? statusEnum, int timestamp, String estateId, String? photoPath, double? latitude, double? longitude, String? additionalInfo, String? assignedTo, String? assignedToUserId, String? assignedToName, String? assignedToRole, String? boardNotes, String? techNotes, String? attachmentsJson, bool revealBoardNotesToTech, String? priority, String? slaDeadline, int? csatRating,@JsonKey(name: 'audit_trail') List<Map<String, dynamic>>? auditTrail,@JsonKey(includeFromJson: false, includeToJson: false) bool isSynced
});




}
/// @nodoc
class __$ReportModelCopyWithImpl<$Res>
    implements _$ReportModelCopyWith<$Res> {
  __$ReportModelCopyWithImpl(this._self, this._then);

  final _ReportModel _self;
  final $Res Function(_ReportModel) _then;

/// Create a copy of ReportModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayId = freezed,Object? title = null,Object? description = null,Object? category = null,Object? reporterName = null,Object? reporterEmail = null,Object? reporterBuilding = null,Object? reporterFootbridge = null,Object? reporterFloor = null,Object? reporterApartment = null,Object? status = null,Object? statusEnum = freezed,Object? timestamp = null,Object? estateId = null,Object? photoPath = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? additionalInfo = freezed,Object? assignedTo = freezed,Object? assignedToUserId = freezed,Object? assignedToName = freezed,Object? assignedToRole = freezed,Object? boardNotes = freezed,Object? techNotes = freezed,Object? attachmentsJson = freezed,Object? revealBoardNotesToTech = null,Object? priority = freezed,Object? slaDeadline = freezed,Object? csatRating = freezed,Object? auditTrail = freezed,Object? isSynced = null,}) {
  return _then(_ReportModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayId: freezed == displayId ? _self.displayId : displayId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,reporterName: null == reporterName ? _self.reporterName : reporterName // ignore: cast_nullable_to_non_nullable
as String,reporterEmail: null == reporterEmail ? _self.reporterEmail : reporterEmail // ignore: cast_nullable_to_non_nullable
as String,reporterBuilding: null == reporterBuilding ? _self.reporterBuilding : reporterBuilding // ignore: cast_nullable_to_non_nullable
as String,reporterFootbridge: null == reporterFootbridge ? _self.reporterFootbridge : reporterFootbridge // ignore: cast_nullable_to_non_nullable
as String,reporterFloor: null == reporterFloor ? _self.reporterFloor : reporterFloor // ignore: cast_nullable_to_non_nullable
as String,reporterApartment: null == reporterApartment ? _self.reporterApartment : reporterApartment // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,statusEnum: freezed == statusEnum ? _self.statusEnum : statusEnum // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as int,estateId: null == estateId ? _self.estateId : estateId // ignore: cast_nullable_to_non_nullable
as String,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,additionalInfo: freezed == additionalInfo ? _self.additionalInfo : additionalInfo // ignore: cast_nullable_to_non_nullable
as String?,assignedTo: freezed == assignedTo ? _self.assignedTo : assignedTo // ignore: cast_nullable_to_non_nullable
as String?,assignedToUserId: freezed == assignedToUserId ? _self.assignedToUserId : assignedToUserId // ignore: cast_nullable_to_non_nullable
as String?,assignedToName: freezed == assignedToName ? _self.assignedToName : assignedToName // ignore: cast_nullable_to_non_nullable
as String?,assignedToRole: freezed == assignedToRole ? _self.assignedToRole : assignedToRole // ignore: cast_nullable_to_non_nullable
as String?,boardNotes: freezed == boardNotes ? _self.boardNotes : boardNotes // ignore: cast_nullable_to_non_nullable
as String?,techNotes: freezed == techNotes ? _self.techNotes : techNotes // ignore: cast_nullable_to_non_nullable
as String?,attachmentsJson: freezed == attachmentsJson ? _self.attachmentsJson : attachmentsJson // ignore: cast_nullable_to_non_nullable
as String?,revealBoardNotesToTech: null == revealBoardNotesToTech ? _self.revealBoardNotesToTech : revealBoardNotesToTech // ignore: cast_nullable_to_non_nullable
as bool,priority: freezed == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String?,slaDeadline: freezed == slaDeadline ? _self.slaDeadline : slaDeadline // ignore: cast_nullable_to_non_nullable
as String?,csatRating: freezed == csatRating ? _self.csatRating : csatRating // ignore: cast_nullable_to_non_nullable
as int?,auditTrail: freezed == auditTrail ? _self._auditTrail : auditTrail // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>?,isSynced: null == isSynced ? _self.isSynced : isSynced // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
