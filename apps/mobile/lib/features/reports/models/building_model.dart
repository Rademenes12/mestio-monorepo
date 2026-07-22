import 'package:freezed_annotation/freezed_annotation.dart';

part 'building_model.freezed.dart';
part 'building_model.g.dart';

@freezed
abstract class BuildingModel with _$BuildingModel {
  const BuildingModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory BuildingModel({
    required String id,
    required String name,
    String? address,
    @Default('residential') String buildingType,
    @Default(0) int displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BuildingModel;

  bool get isGarage => buildingType == 'garage';

  factory BuildingModel.fromJson(Map<String, dynamic> json) =>
      _$BuildingModelFromJson(json);
}

@freezed
abstract class StairwellModel with _$StairwellModel {
  const StairwellModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory StairwellModel({
    required String id,
    required String buildingId,
    required String name,
    // Inclusive floor range. Negative values represent underground garage
    // floors (-6 .. -1). Replaces the old floorCount field so admins can
    // configure both garage and above-ground floors.
    @Default(0) int floorMin,
    @Default(4) int floorMax,
    // Optional entrance label for garage floors (e.g. "A" -> "Wejście A").
    // Stored per stairwell to keep the schema simple.
    String? garageEntranceLabel,
    @Default(0) int displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _StairwellModel;

  factory StairwellModel.fromJson(Map<String, dynamic> json) =>
      _$StairwellModelFromJson(json);

  /// True when this stairwell has at least one garage floor.
  bool get hasGarageFloors => floorMin < 0;
}

/// Combined model for UI display - building with its stairwells
@freezed
abstract class BuildingWithStairwells with _$BuildingWithStairwells {
  const factory BuildingWithStairwells({
    required BuildingModel building,
    required List<StairwellModel> stairwells,
  }) = _BuildingWithStairwells;
}
