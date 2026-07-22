'use client';

import { colors, radius, shadows } from '@mestio/design-tokens';

interface CardProps {
  children: React.ReactNode;
  hover?: boolean;
  className?: string;
}

export function Card({ children, hover = false, className = '' }: CardProps) {
  return (
    <div
      className={className}
      style={{
        background: colors.card,
        borderRadius: radius.lg,
        border: `1px solid ${colors.cardBorder}`,
        boxShadow: shadows.card,
        padding: '20px',
        transition: hover
          ? 'transform 250ms ease, box-shadow 250ms ease, border-color 250ms ease'
          : undefined,
        ...(hover
          ? {
              cursor: 'pointer',
            }
          : {}),
      }}
      onMouseEnter={(e) => {
        if (hover) {
          (e.currentTarget as HTMLDivElement).style.transform = 'translateY(-2px)';
          (e.currentTarget as HTMLDivElement).style.boxShadow = shadows.elevated;
          (e.currentTarget as HTMLDivElement).style.borderColor = `${colors.primary}40`;
        }
      }}
      onMouseLeave={(e) => {
        if (hover) {
          (e.currentTarget as HTMLDivElement).style.transform = '';
          (e.currentTarget as HTMLDivElement).style.boxShadow = shadows.card;
          (e.currentTarget as HTMLDivElement).style.borderColor = colors.cardBorder;
        }
      }}
    >
      {children}
    </div>
  );
}
