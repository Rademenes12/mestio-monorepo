'use client';

import { colors, radius } from '@mestio/design-tokens';

interface CardProps {
  children: React.ReactNode;
  hover?: boolean;
  className?: string;
}

export function Card({ children, hover = false, className = '' }: CardProps) {
  return (
    <div
      className={`${className} ${hover ? 'card-hover-interactive' : ''}`}
      style={{
        background: colors.card,
        borderRadius: radius.md,
        border: `1px solid ${colors.cardBorder}`,
        padding: '20px',
      }}
    >
      {children}
    </div>
  );
}
