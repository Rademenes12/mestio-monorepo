'use client';

import { colors } from '@mestio/design-tokens';
import type { TicketStatus, TicketPriority, PaymentStatus, LeadStatus } from '@mestio/types';
import { CheckCircle, Clock, XCircle, AlertCircle, AlertTriangle } from 'lucide-react';

const statusConfig: Record<string, { color: string; icon: React.ElementType; label: string }> = {
  // Ticket statuses
  new: { color: colors.info, icon: AlertCircle, label: 'Nowe' },
  in_progress: { color: colors.warning, icon: Clock, label: 'W toku' },
  resolved: { color: colors.success, icon: CheckCircle, label: 'Rozwiązane' },
  rejected: { color: colors.error, icon: XCircle, label: 'Odrzucone' },
  closed: { color: colors.textMuted, icon: CheckCircle, label: 'Zamknięte' },

  // Payment statuses
  pending: { color: colors.warning, icon: Clock, label: 'Oczekuje' },
  paid: { color: colors.success, icon: CheckCircle, label: 'Opłacone' },
  overdue: { color: colors.error, icon: AlertTriangle, label: 'Zaległe' },
  cancelled: { color: colors.textMuted, icon: XCircle, label: 'Anulowane' },

  // Lead statuses
  contacted: { color: colors.info, icon: Clock, label: 'Kontakt' },
  qualified: { color: colors.primary, icon: AlertCircle, label: 'Kwalifikacja' },
  proposal: { color: colors.warning, icon: Clock, label: 'Oferta' },
  won: { color: colors.success, icon: CheckCircle, label: 'Wygrane' },
  lost: { color: colors.error, icon: XCircle, label: 'Przegrane' },
};

const priorityConfig: Record<TicketPriority, { color: string; label: string }> = {
  low: { color: colors.textMuted, label: 'Niski' },
  medium: { color: colors.info, label: 'Średni' },
  high: { color: colors.warning, label: 'Wysoki' },
  critical: { color: colors.error, label: 'Krytyczny' },
};

interface StatusBadgeProps {
  status: TicketStatus | PaymentStatus | LeadStatus;
  priority?: TicketPriority;
  size?: 'sm' | 'md';
}

export function StatusBadge({ status, priority, size = 'sm' }: StatusBadgeProps) {
  const config = statusConfig[status];
  if (!config) return null;

  const Icon = config.icon;
  const padding = size === 'sm' ? '4px 10px' : '6px 14px';
  const fontSize = size === 'sm' ? '12px' : '14px';

  return (
    <span
      style={{
        display: 'inline-flex',
        alignItems: 'center',
        gap: '6px',
        padding,
        borderRadius: '9999px',
        fontSize,
        fontWeight: 500,
        color: config.color,
        background: `${config.color}15`,
        border: `1px solid ${config.color}30`,
      }}
    >
      <Icon size={size === 'sm' ? 12 : 14} />
      {config.label}
      {priority && (
        <>
          <span style={{ opacity: 0.4, margin: '0 2px' }}>·</span>
          <span style={{ color: priorityConfig[priority]?.color }}>
            {priorityConfig[priority]?.label}
          </span>
        </>
      )}
    </span>
  );
}
