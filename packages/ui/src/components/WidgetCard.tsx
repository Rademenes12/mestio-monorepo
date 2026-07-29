'use client';

import { colors } from '@mestio/design-tokens';
import type { ReactNode } from 'react';

/**
 * WidgetCard — Border-only widget container.
 * Clean card with optional header and accent color.
 */
interface WidgetCardProps {
  title?: string;
  subtitle?: string;
  action?: ReactNode;
  accentColor?: string;
  children: ReactNode;
  className?: string;
  padding?: boolean;
}

export function WidgetCard({
  title,
  subtitle,
  action,
  accentColor,
  children,
  className = '',
  padding = true,
}: WidgetCardProps) {
  return (
    <div
      className={`relative overflow-hidden rounded-[12px] border ${className}`}
      style={{
        background: colors.card,
        borderColor: colors.cardBorder,
        boxShadow: '0 1px 2px rgba(14, 26, 43, 0.03)',
      }}
    >
      {/* Accent line */}
      {accentColor && (
        <div
          className="absolute top-0 left-0 right-0 h-0.5"
          style={{ background: accentColor }}
        />
      )}

      {/* Header */}
      {(title || action) && (
        <div className="flex items-center justify-between px-5 pt-4 pb-2">
          <div>
            {title && (
              <h3
                className="text-base font-semibold"
                style={{ color: colors.text }}
              >
                {title}
              </h3>
            )}
            {subtitle && (
              <p
                className="text-xs mt-0.5"
                style={{ color: colors.textMuted }}
              >
                {subtitle}
              </p>
            )}
          </div>
          {action && <div className="shrink-0">{action}</div>}
        </div>
      )}

      {/* Body */}
      <div className={padding ? 'px-5 pb-5' : ''}>
        {title && !padding && <div className="px-5">{/* header already handled */}</div>}
        {children}
      </div>
    </div>
  );
}
