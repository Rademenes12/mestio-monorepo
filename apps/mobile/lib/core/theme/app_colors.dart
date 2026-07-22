import 'package:flutter/material.dart';

/// FixFlow Design System color tokens.
///
/// New palette (Phase 1 redesign):
/// ink, blueprint, azure, amber, mint, muted, paper, mist.
///
/// Legacy aliases (electricIndigo → azure, etc.) are kept for backward
/// compatibility so the existing UI picks up the new values automatically.
class AppColors {
  AppColors._();

  // ───── New Design System Tokens ─────

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

  /// Card border (#EAF0F7)
  static const Color cardBorder = Color(0xFFEAF0F7);

  /// Danger / destructive actions (kept for errors)
  static const Color danger = Color(0xFFD64545);

  // ───── Legacy Aliases → New Tokens ─────
  // Existing code references these names; they now resolve to the new palette.

  /// electricIndigo → azure (primary accent)
  static const Color electricIndigo = azure;

  /// cyanGlow — kept unchanged for dark mode accents
  static const Color cyanGlow = Color(0xFF0A84FF);

  /// amberAlert → amber
  static const Color amberAlert = amber;

  /// neonMint → mint
  static const Color neonMint = mint;

  /// crimsonCoral → danger (error/destructive)
  static const Color crimsonCoral = danger;

  // ───── Dark Mode ─────

  static const Color darkCanvas = Color(0xFF0F0F1A);
  static const Color darkCard = Color(0xFF1C1C2E);
  static const Color darkBorder = Color(0x1FFFFFFF);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFF8E8E9F);

  // ───── Light Mode ─────

  /// lightCanvas → paper
  static const Color lightCanvas = paper;

  static const Color lightCard = Color(0xFFFFFFFF);

  /// lightBorder → cardBorder
  static const Color lightBorder = cardBorder;

  /// lightTextPrimary → ink
  static const Color lightTextPrimary = ink;

  static const Color lightTextSecondary = Color(0xFF636375);

  // ───── Spacing ─────

  static const double spacingXs = 8.0;
  static const double spacingSm = 16.0;
  static const double spacingMd = 24.0;
  static const double spacingLg = 32.0;
  static const double spacingXl = 48.0;

  // ───── Border Radius ─────

  static const double radiusCard = 16.0;
  static const double radiusButton = 12.0;

  // ───── Touch Targets ─────

  static const double minTouchHeight = 48.0;
}
