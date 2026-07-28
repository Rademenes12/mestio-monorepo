import React from 'react';
import { LucideIcon, CheckCircle2, Clock, AlertCircle, FileText } from 'lucide-react';

export interface ActivityEvent {
  id: string;
  title: string;
  description?: string;
  timestamp: string;
  type?: 'success' | 'warning' | 'info' | 'error';
  icon?: LucideIcon;
  userAvatar?: string;
  userName?: string;
}

export interface StratifyActivityStreamProps {
  title?: string;
  events: ActivityEvent[];
  onViewAll?: () => void;
}

export const StratifyActivityStream: React.FC<StratifyActivityStreamProps> = ({
  title = 'Ostatnia Aktywność',
  events,
  onViewAll,
}) => {
  return (
    <div className="bg-white border border-[#E9EEF5] rounded-[20px] p-5 shadow-[0_2px_14px_rgba(14,26,43,0.04)]">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-base font-bold text-[#0E1A2B]">{title}</h3>
        {onViewAll && (
          <button
            onClick={onViewAll}
            className="text-xs font-semibold text-[#3E7BD6] hover:text-[#2A5FA8] transition-colors"
          >
            Zobacz wszystkie →
          </button>
        )}
      </div>

      <div className="space-y-4">
        {events.length === 0 ? (
          <p className="text-sm text-[#7C8AA0] text-center py-4">Brak ostatnich aktywności</p>
        ) : (
          events.map((event, index) => {
            const isLast = index === events.length - 1;
            const Icon = event.icon || (
              event.type === 'success' ? CheckCircle2 :
              event.type === 'warning' ? AlertCircle :
              event.type === 'error' ? AlertCircle : Clock
            );

            return (
              <div key={event.id} className="relative flex items-start gap-3.5 group">
                {!isLast && (
                  <span
                    className="absolute left-4 top-8 -bottom-4 w-0.5 bg-[#F0F3F8]"
                    aria-hidden="true"
                  />
                )}
                <div
                  className={`w-8 h-8 rounded-full flex items-center justify-center shrink-0 z-10 ${
                    event.type === 'success'
                      ? 'bg-emerald-50 text-emerald-600 border border-emerald-200/50'
                      : event.type === 'warning'
                      ? 'bg-amber-50 text-amber-600 border border-amber-200/50'
                      : event.type === 'error'
                      ? 'bg-rose-50 text-rose-600 border border-rose-200/50'
                      : 'bg-blue-50 text-[#3E7BD6] border border-blue-200/50'
                  }`}
                >
                  <Icon className="w-4 h-4" />
                </div>

                <div className="flex-1 min-w-0">
                  <div className="flex items-center justify-between gap-2">
                    <p className="text-sm font-semibold text-[#0E1A2B] truncate">
                      {event.title}
                    </p>
                    <span className="text-xs text-[#7C8AA0] shrink-0 font-medium">
                      {event.timestamp}
                    </span>
                  </div>
                  {event.description && (
                    <p className="text-xs text-[#4A5A6E] mt-0.5 line-clamp-2">
                      {event.description}
                    </p>
                  )}
                  {event.userName && (
                    <span className="inline-block mt-1 text-[11px] font-medium text-[#7C8AA0]">
                      Przez: {event.userName}
                    </span>
                  )}
                </div>
              </div>
            );
          })
        )}
      </div>
    </div>
  );
};
