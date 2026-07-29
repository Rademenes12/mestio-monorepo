/**
 * Design tokens for Mestio ecosystem.
 * Daylight-inspired — bright, clean, blue accent. 
 * Shared across all Next.js apps and exported for Flutter.
 */

export const colors = {
  // Blue primary
  primary: '#3E7BD6',
  primaryHover: '#2A5FA8',
  primaryMuted: 'rgba(62, 123, 214, 0.08)',
  primaryLight: '#EBF2FA',

  // Dark blue gradient
  darkBlue: '#173A6A',
  darkBlueMuted: 'rgba(23, 58, 106, 0.05)',
  darkBlueShadow: 'rgba(23, 58, 106, 0.18)',
  darkBlueGlow: 'rgba(23, 58, 106, 0.20)',

  // Background
  bg: '#F9FAFB',
  bgSecondary: '#F1F4F8',
  bgTertiary: '#EBF2FA',

  // Cards & Surfaces
  card: '#FFFFFF',
  cardHover: '#FAFBFC',
  cardBorder: '#EBEFF4',
  surface: '#FAFBFC',

  // Accent
  accent: '#3E7BD6',
  accentHover: '#2A5FA8',
  accentMuted: 'rgba(62, 123, 214, 0.07)',

  // Text
  text: '#0E1A2B',
  textSecondary: '#4A5A6E',
  textMuted: '#7C8AA0',
  textLight: '#9AA7B8',

  // Status
  success: '#22C55E',
  successMuted: 'rgba(34, 197, 94, 0.10)',
  warning: '#F2A900',
  warningMuted: 'rgba(242, 169, 0, 0.11)',
  error: '#EF4444',
  info: '#3E7BD6',

  // Dark section
  darkBg: '#0E1A2B',
  darkText: '#D5DEEC',
  darkTextMuted: '#9FB2CC',
  darkTextDim: '#8FA6C4',
  darkBorder: 'rgba(255, 255, 255, 0.10)',
  darkRadial: 'rgba(62, 123, 214, 0.20)',

  // Glassmorphism
  glassBg: 'rgba(249, 250, 251, 0.85)',
  glassBorder: '#E2E9F2',
  glassBlur: '12px',

  // Stratify Light Premium tokens
  purple: '#8864F0',
  purpleHover: '#734CD9',
  purpleMuted: 'rgba(136, 100, 240, 0.10)',
  stratifyCardShadow: '0 2px 14px rgba(14, 26, 43, 0.05)',

  // Legacy aliases
  navy: '#173A6A',
  navyLight: '#3E7BD6',
  navyIce: '#EBF2FA',
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
