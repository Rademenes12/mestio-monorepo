'use client';

import { useState } from 'react';
import { Eye, EyeOff } from 'lucide-react';

/**
 * PrivacyToggle — Erste "Tryb dyskretny" inspired.
 * One-tap hide/show sensitive data across the entire dashboard.
 */
export function PrivacyToggle() {
  const [hidden, setHidden] = useState(false);

  return (
    <button
      onClick={() => setHidden((v) => !v)}
      className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium transition-all duration-150"
      style={{
        background: hidden
          ? 'rgba(239, 68, 68, 0.1)'
          : 'rgba(59, 130, 246, 0.08)',
        color: hidden ? '#EF4444' : '#3B82F6',
      }}
      title={hidden ? 'Pokaż dane' : 'Ukryj dane (tryb dyskretny)'}
    >
      {hidden ? (
        <EyeOff className="w-3.5 h-3.5" />
      ) : (
        <Eye className="w-3.5 h-3.5" />
      )}
      <span>{hidden ? 'Ukryto' : 'Pokaż'}</span>
    </button>
  );
}

/**
 * usePrivacy hook — wrap sensitive values to auto-hide in privacy mode.
 */
export function usePrivacy() {
  const [hidden, setHidden] = useState(false);

  const conceal = (value: string | number): string => {
    if (!hidden) return String(value);
    const s = String(value);
    if (s.length <= 4) return '••••';
    return s.slice(0, 2) + '••••' + s.slice(-2);
  };

  return { hidden, setHidden, conceal, toggle: () => setHidden((v) => !v) };
}
