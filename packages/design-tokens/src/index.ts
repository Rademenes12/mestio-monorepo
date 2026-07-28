/**
 * Design tokens for Mestio ecosystem.
 * Light theme — #F6F8FB bg, #3E7BD6 blue accent, #0E1A2B dark sections.
 * Shared across all Next.js apps and exported for Flutter.
 */

export const colors = {
  // Blue primary
  primary: '#3E7BD6',
  primaryHover: '#2A5FA8',
  primaryMuted: 'rgba(62, 123, 214, 0.10)',
  primaryLight: '#EAF0F7',

  // Dark blue gradient
  darkBlue: '#173A6A',
  darkBlueMuted: 'rgba(23, 58, 106, 0.06)',
  darkBlueShadow: 'rgba(23, 58, 106, 0.25)',
  darkBlueGlow: 'rgba(23, 58, 106, 0.28)',

  // Background
  bg: '#F6F8FB',
  bgSecondary: '#F0F3F8',
  bgTertiary: '#EAF0F7',

  // Cards & Surfaces
  card: '#FFFFFF',
  cardHover: '#F8F9FB',
  cardBorder: '#E9EEF5',
  surface: '#F8F9FB',

  // Accent
  accent: '#3E7BD6',
  accentHover: '#2A5FA8',
  accentMuted: 'rgba(62, 123, 214, 0.08)',

  // Text
  text: '#0E1A2B',
  textSecondary: '#4A5A6E',
  textMuted: '#7C8AA0',
  textLight: '#9AA7B8',

  // Status
  success: '#2E9E6B',
  successMuted: 'rgba(46, 158, 107, 0.12)',
  warning: '#F2A900',
  warningMuted: 'rgba(242, 169, 0, 0.13)',
  error: '#EF4444',
  info: '#3E7BD6',

  // Dark section
  darkBg: '#0E1A2B',
  darkText: '#D5DEEC',
  darkTextMuted: '#9FB2CC',
  darkTextDim: '#8FA6C4',
  darkBorder: 'rgba(255, 255, 255, 0.12)',
  darkRadial: 'rgba(62, 123, 214, 0.25)',

  // Glassmorphism
  glassBg: 'rgba(246, 248, 251, 0.85)',
  glassBorder: '#E2E9F2',
  glassBlur: '10px',

  // Stratify Light Premium tokens
  purple: '#8864F0',
  purpleHover: '#734CD9',
  purpleMuted: 'rgba(136, 100, 240, 0.10)',
  stratifyCardShadow: '0 2px 14px rgba(14, 26, 43, 0.05)',

  // Legacy aliases
  navy: '#173A6A',
  navyLight: '#3E7BD6',
  navyIce: '#EAF0F7',
  ink: '#0E1A2B',
  blueprint: '#3E7BD6',
  azure: '#3E7BD6',
  amber: '#F2A900',
  paper: '#FFFFFF',
} as const;

export const spacing = {
  xs: '4px',
  sm: '8px',
  md: '16px',
  lg: '24px',
  xl: '32px',
  '2xl': '48px',
  '3xl': '64px',
} as const;

export const radius = {
  sm: '4px',
  md: '8px',
  lg: '12px',
  xl: '12px',
  full: '9999px',
} as const;

export const shadows = {
  elevated: '0 30px 60px rgba(14, 26, 43, 0.12)',
  modal: '0 20px 60px rgba(14, 26, 43, 0.15)',
  tooltip: '0 4px 12px rgba(14, 26, 43, 0.10)',
  darkGlow: '0 24px 50px rgba(23, 58, 106, 0.28)',
} as const;

export const transitions = {
  fast: '150ms ease',
  normal: '250ms ease',
  slow: '400ms ease',
} as const;
