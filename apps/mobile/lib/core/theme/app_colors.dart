import 'package:flutter/material.dart';

/// Mestio Design System color tokens — Erste Bank-inspired palette.
/// Synchronized with packages/design-tokens/src/index.ts (web).
class AppColors {
  AppColors._();

  // ═══════════════ Dark Theme (Erste-inspired) ═══════════════

  /// Deep navy background #0A1628
  static const Color bg = Color(0xFF0A1628);
  static const Color bgSecondary = Color(0xFF0F1E36);
  static const Color bgTertiary = Color(0xFF132238);

  /// Card surfaces
  static const Color card = Color(0xFF132238);
  static const Color cardHover = Color(0xFF1A2D47);
  static const Color surface = Color(0xFF1A2D47);

  /// Card borders (rgba(59, 130, 246, 0.12))
  static const Color cardBorder = Color(0x1F3B82F6);

  // ═══════════════ Light Theme (original) ═══════════════

  /// Deep navy, base text color (#0E1A2B)
  static const Color ink = Color(0xFF0E1A2B);

  /// Manager / administration accent (#173A6A)
  static const Color blueprint = Color(0xFF173A6A);

  /// Primary accent, "New" status (#3E7BD6)
  static const Color azure = Color(0xFF3E7BD6);

  /// "In Progress" status (#F2A900)
  static const Color amber = Color(0xFFF2A900);

  /// "Closed / Success" status (#2E9E6B)
  static const Color mint = Color(0xFF2E9E6B);

  /// "Rejected / Muted" status, security accent (#6B7A90)
  static const Color muted = Color(0xFF6B7A90);

  /// Light background / canvas (#F6F8FB)
  static const Color paper = Color(0xFFF6F8FB);

  /// Borders & separators (#E2E9F2)
  static const Color mist = Color(0xFFE2E9F2);

  /// Card border (light) (#EAF0F7)
  static const Color lightCardBorder = Color(0xFFEAF0F7);

  /// Danger / destructive (#D64545)
  static const Color danger = Color(0xFFD64545);

  // ───── Status colors (shared across themes) ─────

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color accent = Color(0xFF3B82F6);
  static const Color purple = Color(0xFF8864F0);

  // ───── Dark mode text ─────

  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // ───── Light mode text ─────

  static const Color lightTextSecondary = Color(0xFF636375);

  // ───── Spacing ─────

  static const double spacingXs = 8.0;
  static const double spacingSm = 16.0;
  static const double spacingMd = 24.0;
  static const double spacingLg = 32.0;
  static const double spacingXl = 48.0;

  // ───── Border Radius ─────

  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusCard = 16.0;
  static const double radiusButton = 12.0;
  static const double radiusXl = 24.0;

  // ───── Touch Targets ─────

  static const double minTouchHeight = 48.0;

  // ───── Legacy Aliases (backward compat) ─────

  static const Color electricIndigo = azure;
  static const Color cyanGlow = info;
  static const Color amberAlert = amber;
  static const Color neonMint = mint;
  static const Color crimsonCoral = danger;
  static const Color darkCanvas = bg;
  static const Color darkCard = card;
  static const Color darkBorder = Color(0x1FFFFFFF); // rgba(255,255,255,0.12)
  static const Color darkTextPrimary = textPrimary;
  static const Color darkTextSecondary = textSecondary;
  static const Color lightCanvas = paper;
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = lightCardBorder;
  static const Color lightTextPrimary = ink;
}
