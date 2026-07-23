'use client';

import { useRouter } from 'next/navigation';
import { colors } from '@mestio/design-tokens';
import type { LucideIcon } from 'lucide-react';

/**
 * SkrotyBar — Erste "Twoje skróty" inspired.
 * Configurable quick-action shortcuts bar.
 */
export interface Shortcut {
  label: string;
  icon: LucideIcon;
  href: string;
  accentColor?: string;
  shortcut?: string; // keyboard shortcut hint
}

interface SkrotyBarProps {
  shortcuts: Shortcut[];
  title?: string;
}

export function SkrotyBar({ shortcuts, title = 'Twoje skróty' }: SkrotyBarProps) {
  const router = useRouter();

  return (
    <div className="space-y-3">
      <div className="flex items-center justify-between">
        <h3
          className="text-sm font-semibold"
          style={{ color: colors.textSecondary }}
        >
          {title}
        </h3>
      </div>
      <div className="flex flex-wrap gap-2">
        {shortcuts.map((action) => {
          const Icon = action.icon;
          const accent = action.accentColor ?? colors.accent;

          return (
            <button
              key={action.label}
              onClick={() => router.push(action.href)}
              className="group flex items-center gap-2 px-3.5 py-2.5 rounded-xl text-sm font-medium transition-all duration-150 active:scale-[0.97]"
              style={{
                background: `${accent}10`,
                color: colors.text,
                border: `1px solid ${accent}20`,
              }}
              onMouseEnter={(e) => {
                e.currentTarget.style.background = `${accent}18`;
                e.currentTarget.style.borderColor = `${accent}40`;
              }}
              onMouseLeave={(e) => {
                e.currentTarget.style.background = `${accent}10`;
                e.currentTarget.style.borderColor = `${accent}20`;
              }}
              title={action.shortcut ? `${action.label} (${action.shortcut})` : action.label}
            >
              <Icon className="w-4 h-4 shrink-0" style={{ color: accent }} />
              <span>{action.label}</span>
              {action.shortcut && (
                <kbd
                  className="hidden group-hover:inline-flex ml-1.5 text-[10px] px-1.5 py-0.5 rounded font-mono"
                  style={{
                    background: `${accent}15`,
                    color: colors.textMuted,
                  }}
                >
                  {action.shortcut}
                </kbd>
              )}
            </button>
          );
        })}
      </div>
    </div>
  );
}
