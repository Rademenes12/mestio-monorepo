'use client';

import { TrendingUp, TrendingDown, Minus } from 'lucide-react';
import { colors } from '@mestio/design-tokens';
import type { ReactNode } from 'react';

/**
 * KpiCard — Erste "Szybki podgląd" inspired KPI tile.
 * Shows metric, label, optional trend, and optional extra info.
 */
export interface KpiCardProps {
  label: string;
  value: string | number;
  trend?: 'up' | 'down' | 'flat';
  trendLabel?: string;
  icon?: ReactNode;
  accentColor?: string;
  onClick?: () => void;
  href?: string;
  children?: ReactNode;
}

export function KpiCard({
  label,
  value,
  trend,
  trendLabel,
  icon,
  accentColor = colors.accent,
  onClick,
  href,
  children,
}: KpiCardProps) {
  const TrendIcon =
    trend === 'up'
      ? TrendingUp
      : trend === 'down'
        ? TrendingDown
        : trend === 'flat'
          ? Minus
          : null;

  const trendColor =
    trend === 'up'
      ? colors.success
      : trend === 'down'
        ? colors.error
        : trend === 'flat'
          ? colors.textMuted
          : undefined;

  const Component = href ? 'a' : onClick ? 'button' : 'div';
  const extraProps =
    href
      ? { href }
      : onClick
        ? { onClick, type: 'button' as const }
        : {};

  return (
    <Component
      {...extraProps}
      className="group relative overflow-hidden rounded-2xl border p-5 text-left transition-all duration-200 w-full"
      style={{
        background: colors.card,
        borderColor: colors.cardBorder,
      }}
      onMouseEnter={(e) => {
        e.currentTarget.style.borderColor = `${accentColor}40`;
        e.currentTarget.style.transform = 'translateY(-1px)';
        e.currentTarget.style.boxShadow = `0 4px 20px rgba(0,0,0,0.3)`;
      }}
      onMouseLeave={(e) => {
        e.currentTarget.style.borderColor = colors.cardBorder;
        e.currentTarget.style.transform = '';
        e.currentTarget.style.boxShadow = '';
      }}
    >
      {/* Accent line at top */}
      <div
        className="absolute top-0 left-4 right-4 h-0.5 rounded-full opacity-60"
        style={{ background: accentColor }}
      />

      {/* Header row */}
      <div className="flex items-center justify-between mb-3">
        <span
          className="text-xs font-medium uppercase tracking-wider"
          style={{ color: colors.textSecondary }}
        >
          {label}
        </span>
        {icon && (
          <span className="shrink-0" style={{ color: accentColor }}>
            {icon}
          </span>
        )}
      </div>

      {/* Value */}
      <div className="flex items-baseline gap-2">
        <span
          className="text-2xl font-bold tracking-tight"
          style={{ color: colors.text }}
        >
          {value}
        </span>
        {TrendIcon && trendLabel && (
          <span
            className="flex items-center gap-1 text-xs font-medium"
            style={{ color: trendColor }}
          >
            <TrendIcon className="w-3 h-3" />
            {trendLabel}
          </span>
        )}
      </div>

      {/* Extra content */}
      {children && (
        <div className="mt-3 pt-3" style={{ borderTop: `1px solid ${colors.cardBorder}` }}>
          {children}
        </div>
      )}
    </Component>
  );
}
