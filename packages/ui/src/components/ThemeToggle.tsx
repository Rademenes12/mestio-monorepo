'use client';

import { useEffect, useState } from 'react';
import { Sun, Moon } from 'lucide-react';

type Theme = 'light' | 'dark';

function getSystemTheme(): Theme {
  if (typeof window === 'undefined') return 'light';
  return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
}

export function ThemeToggle() {
  const [theme, setTheme] = useState<Theme>('light');
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
    const stored = localStorage.getItem('mestio-theme') as Theme | null;
    const effective = stored || getSystemTheme();
    setTheme(effective);
    document.documentElement.classList.add(effective);
  }, []);

  const toggle = () => {
    const next = theme === 'dark' ? 'light' : 'dark';
    setTheme(next);
    document.documentElement.classList.remove('light', 'dark');
    document.documentElement.classList.add(next);
    localStorage.setItem('mestio-theme', next);
  };

  if (!mounted) {
    return <div className="w-8 h-8" />;
  }

  return (
    <button
      onClick={toggle}
      className="sidebar-link-muted w-full"
      aria-label={theme === 'dark' ? 'Włącz jasny motyw' : 'Włącz ciemny motyw'}
    >
      {theme === 'dark' ? (
        <>
          <Sun className="w-[18px] h-[18px] shrink-0" />
          <span>Jasny motyw</span>
        </>
      ) : (
        <>
          <Moon className="w-[18px] h-[18px] shrink-0" />
          <span>Ciemny motyw</span>
        </>
      )}
    </button>
  );
}
