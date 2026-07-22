/// User role enum matching database values in fixflow_user_estates.role
enum UserRole {
  /// Mieszkaniec - resident who reports issues
  resident('resident'),

  /// Zarząd/Administrator - management with full operational permissions
  admin('admin'),

  /// Serwisant - technician who performs repairs
  technician('technician'),

  /// Ochrona - security guard who can report and set priority
  security('security');

  const UserRole(this.dbValue);

  /// Database value (English, snake_case)
  final String dbValue;

  /// Parse from database value or Polish display name
  static UserRole fromString(String value) {
    final lower = value.toLowerCase();

    // Match by db value
    for (final role in UserRole.values) {
      if (role.dbValue == lower) return role;
    }

    // Legacy Polish values support
    if (lower == 'mieszkaniec') return UserRole.resident;
    if (lower == 'zarząd' || lower == 'administrator') return UserRole.admin;
    if (lower == 'serwisant') return UserRole.technician;
    if (lower == 'ochrona') return UserRole.security;

    // Default to resident
    return UserRole.resident;
  }

  /// Check if role is management (Zarząd/Administrator)
  bool get isManagement => this == UserRole.admin;

  /// Check if role can assign reports
  bool get canAssignReports => this == UserRole.admin;

  /// Check if role can set priority
  bool get canSetPriority => this == UserRole.admin || this == UserRole.security;

  /// Check if role can change status
  bool get canChangeStatus => this == UserRole.admin || this == UserRole.technician;

  /// Check if role can set "rejected" status
  bool get canReject => this == UserRole.admin;

  /// Check if role can create reports
  bool get canCreateReports => this == UserRole.resident || this == UserRole.admin || this == UserRole.security;

  /// Check if role can view internal notes
  bool get canViewInternalNotes => this == UserRole.admin || this == UserRole.technician;

  /// Check if role can manage estate structure
  bool get canManageEstate => this == UserRole.admin;

  /// Check if role can manage residents
  bool get canManageResidents => this == UserRole.admin;

  /// Check if role can manage announcements
  bool get canManageAnnouncements => this == UserRole.admin;

  /// Check if role can manage contacts
  bool get canManageContacts => this == UserRole.admin;
}
