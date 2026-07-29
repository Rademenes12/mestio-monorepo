"use client";

import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Activity, Clock, Building2, Bell } from "lucide-react";

const BUILDINGS = [
  { id: "A", status: "ok", label: "OK" },
  { id: "B", status: "ok", label: "OK" },
  { id: "C", status: "alert", label: "2 zgłoszenia" },
  { id: "D", status: "ok", label: "OK" },
  { id: "E", status: "warning", label: "1 zgłoszenie" },
  { id: "F", status: "ok", label: "OK" },
  { id: "G", status: "ok", label: "OK" },
  { id: "H", status: "ok", label: "OK" },
];

const STATUS_STYLES = {
  ok: { color: "#22C55E", bg: "rgba(34,197,94,0.12)", border: "rgba(34,197,94,0.2)" },
  warning: { color: "#F2A900", bg: "rgba(242,169,0,0.12)", border: "rgba(242,169,0,0.2)" },
  alert: { color: "#EF4444", bg: "rgba(239,68,68,0.12)", border: "rgba(239,68,68,0.2)" },
};

const PUSH_MESSAGES = [
  { text: "Nowe zgłoszenie: Hydraulika · Budynek C", time: "przed chwilą" },
  { text: "Zgłoszenie MS-2041 zmieniono na 'W realizacji'", time: "2 min temu" },
  { text: "Serwis przejął zadanie: Budynek E · Elektryka", time: "5 min temu" },
  { text: "Zgłoszenie MS-2039 zamknięte", time: "12 min temu" },
];

function useAnimatedCounter(target: number, duration: number = 1500, start: boolean = true) {
  const [value, setValue] = useState(0);

  useEffect(() => {
    if (!start) return;
    let startTime: number | null = null;
    let frame: number;

    const animate = (timestamp: number) => {
      if (startTime === null) startTime = timestamp;
      const elapsed = timestamp - startTime;
      const progress = Math.min(elapsed / duration, 1);
      const eased = 1 - Math.pow(1 - progress, 3);
      setValue(Math.round(eased * target));
      if (progress < 1) {
        frame = requestAnimationFrame(animate);
      }
    };

    frame = requestAnimationFrame(animate);
    return () => cancelAnimationFrame(frame);
  }, [target, duration, start]);

  return value;
}

export default function LiveStatsWidget() {
  const [pushIdx, setPushIdx] = useState(0);
  const [visible, setVisible] = useState(false);

  const activeReports = useAnimatedCounter(12, 1800, visible);
  const avgResponse = useAnimatedCounter(47, 2000, visible);

  useEffect(() => {
    const timer = setTimeout(() => setVisible(true), 300);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    const interval = setInterval(() => {
      setPushIdx((prev) => (prev + 1) % PUSH_MESSAGES.length);
    }, 3500);
    return () => clearInterval(interval);
  }, []);

  return (
    <div className="space-y-4">
      {/* ── Live counters row ── */}
      <div className="grid grid-cols-2 gap-4">
        {/* Active reports */}
        <div
          className="rounded-2xl p-5"
          style={{
            background: "rgba(255,255,255,0.04)",
            border: "1px solid rgba(255,255,255,0.1)",
            backdropFilter: "blur(16px)",
          }}
        >
          <div className="flex items-center gap-2 mb-3">
            <Activity className="w-3.5 h-3.5" style={{ color: "#3E7BD6" }} />
            <span className="font-mono text-[10px] uppercase tracking-wider" style={{ color: "rgba(255,255,255,0.4)" }}>
              Aktywne zgłoszenia
            </span>
          </div>
          <div className="flex items-baseline gap-2">
            <motion.span
              className="font-heading font-bold text-[36px] leading-none tracking-[-1px]"
              style={{ color: "#FFF" }}
            >
              {activeReports}
            </motion.span>
            <span className="text-[11px]" style={{ color: "rgba(255,255,255,0.35)" }}>
              dzisiaj
            </span>
          </div>
          {/* Mini sparkline */}
          <div className="flex items-end gap-1 mt-3 h-6">
            {[8, 12, 9, 15, 11, 14, 10, 13, 12].map((h, i) => (
              <motion.div
                key={i}
                className="flex-1 rounded-sm"
                style={{ background: i === 7 ? "#3E7BD6" : "rgba(62,123,214,0.2)" }}
                initial={{ height: 0 }}
                animate={{ height: `${(h / 15) * 100}%` }}
                transition={{ delay: 0.5 + i * 0.05, duration: 0.4 }}
              />
            ))}
          </div>
        </div>

        {/* Avg response time */}
        <div
          className="rounded-2xl p-5"
          style={{
            background: "rgba(255,255,255,0.04)",
            border: "1px solid rgba(255,255,255,0.1)",
            backdropFilter: "blur(16px)",
          }}
        >
          <div className="flex items-center gap-2 mb-3">
            <Clock className="w-3.5 h-3.5" style={{ color: "#F2A900" }} />
            <span className="font-mono text-[10px] uppercase tracking-wider" style={{ color: "rgba(255,255,255,0.4)" }}>
              Średni czas reakcji
            </span>
          </div>
          <div className="flex items-baseline gap-2">
            <motion.span
              className="font-heading font-bold text-[36px] leading-none tracking-[-1px]"
              style={{ color: "#FFF" }}
            >
              {avgResponse}
            </motion.span>
            <span className="text-[11px]" style={{ color: "rgba(255,255,255,0.35)" }}>
              min
            </span>
          </div>
          {/* Trend indicator */}
          <div className="flex items-center gap-1.5 mt-3">
            <div className="flex items-center gap-1 px-2 py-0.5 rounded-md" style={{ background: "rgba(34,197,94,0.12)" }}>
              <svg width="8" height="8" viewBox="0 0 24 24" fill="none" stroke="#22C55E" strokeWidth="3" strokeLinecap="round" strokeLinejoin="round">
                <path d="M7 17L17 7M17 7H9M17 7v8" />
              </svg>
              <span className="text-[10px] font-semibold" style={{ color: "#22C55E" }}>23%</span>
            </div>
            <span className="text-[10px]" style={{ color: "rgba(255,255,255,0.3)" }}>vs zeszły tydzień</span>
          </div>
        </div>
      </div>

      {/* ── Building status grid ── */}
      <div
        className="rounded-2xl p-5"
        style={{
          background: "rgba(255,255,255,0.04)",
          border: "1px solid rgba(255,255,255,0.1)",
          backdropFilter: "blur(16px)",
        }}
      >
        <div className="flex items-center gap-2 mb-3">
          <Building2 className="w-3.5 h-3.5" style={{ color: "rgba(255,255,255,0.4)" }} />
          <span className="font-mono text-[10px] uppercase tracking-wider" style={{ color: "rgba(255,255,255,0.4)" }}>
            Status budynków
          </span>
        </div>
        <div className="grid grid-cols-4 gap-2">
          {BUILDINGS.map((b, i) => {
            const s = STATUS_STYLES[b.status as keyof typeof STATUS_STYLES];
            return (
              <motion.div
                key={b.id}
                className="rounded-lg p-2 text-center"
                style={{ background: s.bg, border: `1px solid ${s.border}` }}
                initial={{ opacity: 0, scale: 0.9 }}
                animate={{ opacity: 1, scale: 1 }}
                transition={{ delay: 0.3 + i * 0.06 }}
              >
                <div className="font-heading font-bold text-[13px]" style={{ color: s.color }}>
                  {b.id}
                </div>
                <div className="text-[8px] mt-0.5" style={{ color: s.color, opacity: 0.7 }}>
                  {b.label}
                </div>
                {b.status !== "ok" && (
                  <motion.div
                    className="w-1.5 h-1.5 rounded-full mx-auto mt-1"
                    style={{ background: s.color }}
                    animate={{ opacity: [1, 0.3, 1] }}
                    transition={{ duration: 1.5, repeat: Infinity }}
                  />
                )}
              </motion.div>
            );
          })}
        </div>
      </div>

      {/* ── Live push feed ── */}
      <div
        className="rounded-2xl p-4 overflow-hidden"
        style={{
          background: "rgba(255,255,255,0.04)",
          border: "1px solid rgba(255,255,255,0.1)",
          backdropFilter: "blur(16px)",
        }}
      >
        <div className="flex items-center gap-2 mb-3">
          <Bell className="w-3.5 h-3.5" style={{ color: "#3E7BD6" }} />
          <span className="font-mono text-[10px] uppercase tracking-wider" style={{ color: "rgba(255,255,255,0.4)" }}>
            Powiadomienia na żywo
          </span>
          <span className="ml-auto flex items-center gap-1">
            <motion.span
              className="w-1.5 h-1.5 rounded-full"
              style={{ background: "#22C55E" }}
              animate={{ opacity: [1, 0.3, 1] }}
              transition={{ duration: 1.5, repeat: Infinity }}
            />
            <span className="text-[9px] font-mono" style={{ color: "#22C55E" }}>LIVE</span>
          </span>
        </div>
        <div className="h-14 relative">
          <AnimatePresence mode="wait">
            <motion.div
              key={pushIdx}
              initial={{ opacity: 0, y: 15 }}
              animate={{ opacity: 1, y: 0 }}
              exit={{ opacity: 0, y: -15 }}
              transition={{ duration: 0.3 }}
              className="absolute inset-0"
            >
              <div className="text-[12px] font-medium" style={{ color: "rgba(255,255,255,0.9)" }}>
                {PUSH_MESSAGES[pushIdx].text}
              </div>
              <div className="font-mono text-[10px] mt-1" style={{ color: "rgba(255,255,255,0.3)" }}>
                {PUSH_MESSAGES[pushIdx].time}
              </div>
            </motion.div>
          </AnimatePresence>
        </div>
      </div>
    </div>
  );
}
