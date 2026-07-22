/// Maps the technical role key persisted in the database to the user-facing
/// label. S7.8 decision: keep DB key `Serwisant` (covers cleaning crews,
/// maintenance, security, technicians) but show the shorter, more universal
/// label `Serwis` everywhere in the UI.
///
/// Only [DashboardScreen], dropdowns and similar display widgets should use
/// this helper. Business logic comparisons stay on the technical key.
String roleDisplayLabel(String roleKey) {
  switch (roleKey) {
    case 'Serwisant':
      return 'Serwis';
    case 'Ochrona':
      return 'Ochrona';
    default:
      return roleKey;
  }
}

/// Maps the DB role stored on invitation codes / join_requests / user_estates
/// (resident/technician/security/admin/board) to the Polish display label
/// used throughout the app's business logic and UI (ResidentProfileModel.role,
/// dashboard role checks like `role == 'Zarząd'`).
String dbRoleToLabel(String dbRole) => switch (dbRole) {
      'technician' => 'Serwisant',
      'security' => 'Ochrona',
      'admin' => 'Administrator',
      'board' => 'Zarząd',
      _ => 'Mieszkaniec',
    };
