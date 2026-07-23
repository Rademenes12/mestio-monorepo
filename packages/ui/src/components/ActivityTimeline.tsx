'use client';

import { colors } from '@mestio/design-tokens';
import { Clock } from 'lucide-react';

/**
 * ActivityTimeline — Erste "Ostatnia aktywność" inspired.
 * Clean chronological feed with icon per event type.
 */
export interface TimelineEvent {
  id: string;
  time: string; // ISO date
  user: string;
  action: string;
  description: string;
  type?: 'created' | 'updated' | 'resolved' | 'reopened' | 'commented' | 'system';
  href?: string;
}

const EVENT_STYLES: Record<string, { dotColor: string; bgGlow: string }> = {
  created: { dotColor: colors.info, bgGlow: `${colors.info}15` },
  updated: { dotColor: colors.warning, bgGlow: `${colors.warning}15` },
  resolved: { dotColor: colors.success, bgGlow: `${colors.success}15` },
  reopened: { dotColor: colors.error, bgGlow: `${colors.error}15` },
  commented: { dotColor: colors.accent, bgGlow: `${colors.accent}15` },
  system: { dotColor: colors.textMuted, bgGlow: `${colors.textMuted}10` },
};

interface ActivityTimelineProps {
  events: TimelineEvent[];
  maxVisible?: number;
}

export function ActivityTimeline({ events, maxVisible = 6 }: ActivityTimelineProps) {
  const visible = events.slice(0, maxVisible);

  if (visible.length === 0) {
    return (
      <div
        className="flex flex-col items-center justify-center py-8 text-sm"
        style={{ color: colors.textMuted }}
      >
        <Clock className="w-8 h-8 mb-2 opacity-40" />
        <p>Brak aktywności</p>
      </div>
    );
  }

  return (
    <div className="relative">
      {/* Vertical line */}
      <div
        className="absolute left-[13px] top-2 bottom-2 w-px"
        style={{ background: colors.cardBorder }}
      />

      <div className="space-y-0">
        {visible.map((event) => {
          const style = EVENT_STYLES[event.type ?? 'system'] ?? EVENT_STYLES.system;
          const Wrapper = event.href ? 'a' : 'div';

          return (
            <Wrapper
              key={event.id}
              {...(event.href ? { href: event.href } : {})}
              className="relative flex items-start gap-4 py-3 pl-0 group"
              style={{ borderBottom: `1px solid ${colors.cardBorder}` }}
            >
              {/* Dot */}
              <div className="relative z-10 shrink-0 mt-0.5">
                <div
                  className="w-[26px] h-[26px] rounded-full flex items-center justify-center"
                  style={{ background: style.bgGlow }}
                >
                  <div
                    className="w-2 h-2 rounded-full"
                    style={{ background: style.dotColor }}
                  />
                </div>
              </div>

              {/* Content */}
              <div className="flex-1 min-w-0">
                <div className="flex items-center gap-2 flex-wrap">
                  <span
                    className="text-sm font-medium"
                    style={{ color: colors.text }}
                  >
                    {event.user}
                  </span>
                  <span
                    className="text-xs"
                    style={{ color: colors.textMuted }}
                  >
                    {event.action}
                  </span>
                </div>
                <p
                  className="text-sm mt-0.5 line-clamp-2"
                  style={{ color: colors.textSecondary }}
                >
                  {event.description}
                </p>
                <span
                  className="text-[11px] mt-1 block"
                  style={{ color: colors.textMuted }}
                >
                  {formatTimeAgo(event.time)}
                </span>
              </div>
            </Wrapper>
          );
        })}

        {events.length > maxVisible && (
          <button
            className="w-full text-center py-3 text-sm font-medium transition-colors rounded-lg"
            style={{ color: colors.accent }}
            onMouseEnter={(e) => (e.currentTarget.style.background = `${colors.accent}08`)}
            onMouseLeave={(e) => (e.currentTarget.style.background = 'transparent')}
          >
            Zobacz wszystkie ({events.length})
          </button>
        )}
      </div>
    </div>
  );
}

function formatTimeAgo(iso: string): string {
  const diff = Date.now() - new Date(iso).getTime();
  const mins = Math.floor(diff / 60000);
  if (mins < 1) return 'przed chwilą';
  if (mins < 60) return `${mins} min temu`;
  const hours = Math.floor(mins / 60);
  if (hours < 24) return `${hours} h temu`;
  const days = Math.floor(hours / 24);
  if (days < 7) return `${days} dni temu`;
  return new Date(iso).toLocaleDateString('pl-PL', { day: 'numeric', month: 'short' });
}
