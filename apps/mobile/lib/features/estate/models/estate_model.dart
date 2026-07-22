import 'package:freezed_annotation/freezed_annotation.dart';

part 'estate_model.freezed.dart';
part 'estate_model.g.dart';

/// An estate (apartment community) the user belongs to.
@freezed
abstract class Estate with _$Estate {
  const Estate._();

  const factory Estate({
    required String id,
    required String name,
    @Default('resident') String role,
    @JsonKey(name: 'company_name') String? companyName,
    @JsonKey(name: 'admin_name') String? adminName,
    @JsonKey(name: 'admin_email') String? adminEmail,
    @JsonKey(name: 'admin_phone') String? adminPhone,
    @JsonKey(name: 'hide_resident_contacts') @Default(false) bool hideResidentContacts,
  }) = _Estate;

  factory Estate.fromJson(Map<String, dynamic> json) => _$EstateFromJson(json);

  /// Whether this membership can manage the estate (invitation codes, join
  /// requests, structure). Only admin/board are office; technician/security
  /// are staff but not management.
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isOffice => role == 'admin' || role == 'board';

  /// First 4 uppercase characters of the estate name, used as a compact
  /// identifier in the multi-estate switcher.
  String get shortCode {
    final trimmed = name.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    return trimmed.length >= 4 ? trimmed.substring(0, 4) : trimmed;
  }

  /// Derived accent color for visual differentiation. Uses a stable hash
  /// of the estate id to pick from a curated palette.
  @JsonKey(includeFromJson: false, includeToJson: false)
  int get accentColorValue {
    const palette = <int>[
      0xFF6366F1, // indigo
      0xFF8B5CF6, // violet
      0xFFEC4899, // pink
      0xFFF43F5E, // rose
      0xFFF97316, // orange
      0xFFEAB308, // yellow
      0xFF22C55E, // green
      0xFF14B8A6, // teal
      0xFF0EA5E9, // sky
      0xFF3B82F6, // blue
    ];
    final hash = id.hashCode.abs();
    return palette[hash % palette.length];
  }
}
