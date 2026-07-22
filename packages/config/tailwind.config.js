/** @type {import('tailwindcss').Config} */
module.exports = {
  theme: {
    extend: {
      colors: {
        // Erste Bank-inspired professional palette
        navy: {
          DEFAULT: '#1E3A5F',
          light: '#2B6CB0',
          ice: '#E8F0FE',
        },
        bg: '#0A1628',
        'bg-secondary': '#0F1E36',
        'bg-tertiary': '#132238',
        card: '#132238',
        'card-hover': '#1A2D47',
        surface: '#1A2D47',
        primary: {
          DEFAULT: '#1E3A5F',
          hover: '#2B6CB0',
          muted: 'rgba(30, 58, 95, 0.15)',
        },
        'primary-light': '#3B82F6',
        accent: {
          DEFAULT: '#3B82F6',
          hover: '#60A5FA',
          muted: 'rgba(59, 130, 246, 0.1)',
        },
        text: {
          DEFAULT: '#F8FAFC',
          secondary: '#94A3B8',
          muted: '#64748B',
        },
        status: {
          success: '#10B981',
          warning: '#F59E0B',
          error: '#EF4444',
          info: '#3B82F6',
        },
        success: '#10B981',
        warning: '#F59E0B',
        error: '#EF4444',
        glass: {
          bg: 'rgba(19, 34, 56, 0.8)',
          border: 'rgba(59, 130, 246, 0.15)',
          blur: '16px',
        },
        mestio: {
          bg: '#0A1628',
          card: '#132238',
          'card-light': '#1A2D47',
          primary: '#1E3A5F',
          'primary-light': '#3B82F6',
          'primary-dark': '#2B6CB0',
          muted: 'rgba(248, 250, 252, 0.3)',
          subtle: 'rgba(248, 250, 252, 0.08)',
          medium: 'rgba(248, 250, 252, 0.15)',
        },
      },
      spacing: {
        xs: '4px',
        sm: '8px',
        md: '16px',
        lg: '24px',
        xl: '32px',
        '2xl': '48px',
        '3xl': '64px',
      },
      borderRadius: {
        sm: '8px',
        md: '12px',
        lg: '16px',
        xl: '24px',
        card: '12px',
        'card-sm': '8px',
        'card-lg': '16px',
      },
      boxShadow: {
        card: '0 2px 8px rgba(0, 0, 0, 0.4)',
        elevated: '0 8px 32px rgba(0, 0, 0, 0.5)',
        glow: '0 0 24px rgba(59, 130, 246, 0.25)',
        'card-hover': '0 4px 16px rgba(0, 0, 0, 0.5)',
      },
      animation: {
        'fade-in': 'fadeIn 0.4s ease-out',
        'slide-up': 'slideUp 0.35s ease-out',
        'pulse-slow': 'pulse 4s cubic-bezier(0.4, 0, 0.6, 1) infinite',
        'twinkle': 'twinkle 3s ease-in-out infinite',
        'slide-down': 'slideDown 0.25s ease-out',
        'scale-in': 'scaleIn 0.3s ease-out',
        'shimmer': 'shimmer 2s ease-in-out infinite',
      },
      keyframes: {
        fadeIn: {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        slideUp: {
          '0%': { transform: 'translateY(16px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        twinkle: {
          '0%, 100%': { opacity: '0.3' },
          '50%': { opacity: '0.9' },
        },
        slideDown: {
          '0%': { transform: 'translateY(-8px)', opacity: '0' },
          '100%': { transform: 'translateY(0)', opacity: '1' },
        },
        scaleIn: {
          '0%': { transform: 'scale(0.95)', opacity: '0' },
          '100%': { transform: 'scale(1)', opacity: '1' },
        },
        shimmer: {
          '0%': { backgroundPosition: '-200% 0' },
          '100%': { backgroundPosition: '200% 0' },
        },
      },
    },
  },
};
