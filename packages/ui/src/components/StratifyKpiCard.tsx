import React from 'react';
import { LucideIcon, TrendingUp, TrendingDown } from 'lucide-react';

export interface StratifyKpiCardProps {
  title: string;
  value: string | number;
  change?: string;
  changeType?: 'positive' | 'negative' | 'neutral' | 'warning';
  timeframe?: string;
  icon?: LucideIcon;
  iconBgColor?: string;
  iconColor?: string;
  subtitle?: string;
  progressPercent?: number;
}

export const StratifyKpiCard: React.FC<StratifyKpiCardProps> = ({
  title,
  value,
  change,
  changeType = 'positive',
  timeframe = 'vs w poprzednim m-cu',
  icon: Icon,
  iconBgColor = 'bg-blue-500/10',
  iconColor = 'text-[#3E7BD6]',
  subtitle,
  progressPercent,
}) => {
  const isPositive = changeType === 'positive';
  const isNegative = changeType === 'negative';
  const isWarning = changeType === 'warning';

  return (
    <div className="bg-white border border-[#E9EEF5] rounded-[20px] p-5 shadow-[0_2px_14px_rgba(14,26,43,0.04)] hover:shadow-[0_6px_20px_rgba(14,26,43,0.08)] transition-all duration-200">
      <div className="flex items-center justify-between mb-3">
        <span className="text-xs font-semibold uppercase tracking-wider text-[#7C8AA0]">
          {title}
        </span>
        {Icon && (
          <div className={`p-2.5 rounded-full ${iconBgColor} ${iconColor} flex items-center justify-center`}>
            <Icon className="w-5 h-5" />
          </div>
        )}
      </div>

      <div className="flex items-baseline justify-between gap-2">
        <div className="text-2xl font-bold text-[#0E1A2B] tracking-tight">
          {value}
        </div>
        {change && (
          <div
            className={`inline-flex items-center gap-1 px-2.5 py-1 rounded-full text-xs font-semibold ${
              isPositive
                ? 'bg-emerald-50 text-emerald-700 border border-emerald-200/50'
                : isNegative
                ? 'bg-rose-50 text-rose-700 border border-rose-200/50'
                : isWarning
                ? 'bg-amber-50 text-amber-700 border border-amber-200/50'
                : 'bg-slate-100 text-slate-700 border border-slate-200/50'
            }`}
          >
            {isPositive && <TrendingUp className="w-3.5 h-3.5" />}
            {isNegative && <TrendingDown className="w-3.5 h-3.5" />}
            <span>{change}</span>
          </div>
        )}
      </div>

      {progressPercent !== undefined && (
        <div className="mt-3">
          <div className="w-full bg-[#F0F3F8] h-2 rounded-full overflow-hidden">
            <div
              className="bg-[#3E7BD6] h-full rounded-full transition-all duration-500"
              style={{ width: `${Math.min(100, Math.max(0, progressPercent))}%` }}
            />
          </div>
        </div>
      )}

      {(subtitle || timeframe) && (
        <div className="mt-2.5 text-xs text-[#7C8AA0] flex items-center justify-between">
          <span>{subtitle || timeframe}</span>
          {progressPercent !== undefined && <span>{progressPercent}%</span>}
        </div>
      )}
    </div>
  );
};
