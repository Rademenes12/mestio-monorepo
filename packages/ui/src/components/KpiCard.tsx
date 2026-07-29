'use client';

import { TrendingUp, TrendingDown, Minus } from 'lucide-react';
import { colors } from '@mestio/design-tokens';
import type { ReactNode } from 'react';

/**
 * KpiCard — Border-only KPI tile inspired by Linear.
 * Shows metric, label, optional trend, and optional extra info.
 * No shadow, no lift on hover — just subtle border highlight via CSS.
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

  const interactive = !!(onClick || href);
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
      className={`group relative overflow-hidden rounded-[12px] border p-5 text-left transition-all duration-200 w-full ${interactive ? 'card-hover-interactive' : ''}`}
      style={{
        '--card-accent': accentColor,
        background: colors.card,
        borderColor: colors.cardBorder,
        boxShadow: '0 1px 2px rgba(14, 26, 43, 0.03)',
      } as React.CSSProperties}
    >
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
