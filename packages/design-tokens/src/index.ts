/**
 * Design tokens for Mestio ecosystem.
 * Erste Bank-inspired professional palette.
 * Shared across all Next.js apps and exported for Flutter.
 */

export const colors = {
  // Navy — primary brand color
  navy: '#1E3A5F',
  navyLight: '#2B6CB0',
  navyIce: '#E8F0FE',

  // Background
  bg: '#0A1628',
  bgSecondary: '#0F1E36',
  bgTertiary: '#132238',

  // Cards & Surfaces
  card: '#132238',
  cardHover: '#1A2D47',
  cardBorder: 'rgba(59, 130, 246, 0.12)',
  surface: '#1A2D47',

  // Primary
  primary: '#1E3A5F',
  primaryHover: '#2B6CB0',
  primaryMuted: 'rgba(30, 58, 95, 0.15)',

  // Accent
  accent: '#3B82F6',
  accentHover: '#60A5FA',
  accentMuted: 'rgba(59, 130, 246, 0.1)',

  // Text
  text: '#F8FAFC',
  textSecondary: '#94A3B8',
  textMuted: '#64748B',

  // Status
  success: '#10B981',
  warning: '#F59E0B',
  error: '#EF4444',
  info: '#3B82F6',

  // Glassmorphism
  glassBg: 'rgba(19, 34, 56, 0.8)',
  glassBorder: 'rgba(59, 130, 246, 0.15)',
  glassBlur: '16px',
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
  sm: '8px',
  md: '12px',
  lg: '16px',
  xl: '24px',
  full: '9999px',
} as const;

export const shadows = {
  card: '0 2px 8px rgba(0, 0, 0, 0.4)',
  elevated: '0 8px 32px rgba(0, 0, 0, 0.5)',
  glow: '0 0 24px rgba(59, 130, 246, 0.25)',
  cardHover: '0 4px 16px rgba(0, 0, 0, 0.5)',
} as const;

export const transitions = {
  fast: '150ms ease',
  normal: '250ms ease',
  slow: '400ms ease',
} as const;
