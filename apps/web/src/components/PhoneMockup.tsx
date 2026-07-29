"use client";

import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "framer-motion";
import { Camera, Send, Bell, Check, MapPin, Wrench, CircleCheck as CheckCircle2 } from "lucide-react";

type Phase = "camera" | "sending" | "push" | "status_new" | "status_progress" | "status_done";

const PHASES: { key: Phase; duration: number }[] = [
  { key: "camera", duration: 2400 },
  { key: "sending", duration: 1200 },
  { key: "push", duration: 2200 },
  { key: "status_new", duration: 1800 },
  { key: "status_progress", duration: 2200 },
  { key: "status_done", duration: 2600 },
];

const STATUS_INFO: Record<Phase, { label: string; color: string; bg: string }> = {
  camera: { label: "Robisz zdjęcie", color: "#FFF", bg: "rgba(255,255,255,0.08)" },
  sending: { label: "Wysyłanie...", color: "#3E7BD6", bg: "rgba(62,123,214,0.15)" },
  push: { label: "Powiadomienie push", color: "#F2A900", bg: "rgba(242,169,0,0.15)" },
  status_new: { label: "Nowe", color: "#3E7BD6", bg: "rgba(62,123,214,0.15)" },
  status_progress: { label: "W realizacji", color: "#F2A900", bg: "rgba(242,169,0,0.15)" },
  status_done: { label: "Zamknięte", color: "#22C55E", bg: "rgba(34,197,94,0.15)" },
};

export default function PhoneMockup() {
  const [phaseIdx, setPhaseIdx] = useState(0);
  const phase = PHASES[phaseIdx].key;

  useEffect(() => {
    const timer = setTimeout(() => {
      setPhaseIdx((prev) => (prev + 1) % PHASES.length);
    }, PHASES[phaseIdx].duration);
    return () => clearTimeout(timer);
  }, [phaseIdx]);

  const status = STATUS_INFO[phase];
  const progress = Math.round(((phaseIdx + 1) / PHASES.length) * 100);

  return (
    <div className="relative mx-auto" style={{ width: 300, height: 620 }}>
      {/* Phone frame */}
      <div
        className="absolute inset-0 rounded-[44px] overflow-hidden"
        style={{
          background: "linear-gradient(145deg, #1a2a42, #0d1626)",
          border: "1px solid rgba(255,255,255,0.1)",
          boxShadow: "0 40px 80px rgba(0,0,0,0.5), 0 0 0 2px rgba(255,255,255,0.04), inset 0 0 0 1px rgba(255,255,255,0.06)",
        }}
      >
        {/* Notch */}
        <div
          className="absolute top-0 left-1/2 -translate-x-1/2 z-30"
          style={{
            width: 110,
            height: 28,
            background: "#0d1626",
            borderBottomLeftRadius: 16,
            borderBottomRightRadius: 16,
          }}
        />

        {/* Screen */}
        <div className="absolute inset-0 top-[28px] bottom-0 overflow-hidden rounded-b-[40px]">
          <AnimatePresence mode="wait">
            {/* ── CAMERA PHASE ── */}
            {phase === "camera" && (
              <motion.div
                key="camera"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.3 }}
                className="absolute inset-0 flex flex-col"
                style={{ background: "linear-gradient(180deg, #0a1524 0%, #0d1a2e 100%)" }}
              >
                {/* Camera viewfinder */}
                <div className="flex-1 flex items-center justify-center relative p-5">
                  <div
                    className="w-full aspect-square rounded-2xl flex items-center justify-center relative overflow-hidden"
                    style={{
                      background: "radial-gradient(circle at 40% 40%, rgba(62,123,214,0.15), rgba(10,21,36,0.8))",
                      border: "2px solid rgba(255,255,255,0.12)",
                    }}
                  >
                    {/* Focus corners */}
                    {[
                      "top-2 left-2 border-t-2 border-l-2 rounded-tl-lg",
                      "top-2 right-2 border-t-2 border-r-2 rounded-tr-lg",
                      "bottom-2 left-2 border-b-2 border-l-2 rounded-bl-lg",
                      "bottom-2 right-2 border-b-2 border-r-2 rounded-br-lg",
                    ].map((pos) => (
                      <div key={pos} className={`absolute w-5 h-5 ${pos}`} style={{ borderColor: "#3E7BD6" }} />
                    ))}

                    {/* "Photo" of pipe */}
                    <motion.div
                      initial={{ scale: 0.9, opacity: 0 }}
                      animate={{ scale: 1, opacity: 1 }}
                      transition={{ delay: 0.2 }}
                      className="text-center"
                    >
                      <div className="text-4xl mb-1">🔧</div>
                      <div className="font-mono text-[9px]" style={{ color: "rgba(255,255,255,0.4)" }}>
                        Wykryto usterkę
                      </div>
                    </motion.div>

                    {/* Shutter flash */}
                    <motion.div
                      className="absolute inset-0 bg-white"
                      initial={{ opacity: 0 }}
                      animate={{ opacity: [0, 0, 0.6, 0] }}
                      transition={{ duration: 0.4, times: [0, 0.6, 0.7, 1], delay: 1.6 }}
                    />
                  </div>
                </div>

                {/* Form fields */}
                <div className="px-5 pb-4 space-y-3">
                  <div>
                    <div className="font-mono text-[8px] uppercase tracking-wider mb-1" style={{ color: "rgba(255,255,255,0.3)" }}>
                      Kategoria
                    </div>
                    <div
                      className="rounded-lg px-3 py-2 text-[11px] font-medium"
                      style={{ background: "rgba(62,123,214,0.12)", color: "#3E7BD6", border: "1px solid rgba(62,123,214,0.2)" }}
                    >
                      Hydraulika
                    </div>
                  </div>
                  <div>
                    <div className="font-mono text-[8px] uppercase tracking-wider mb-1" style={{ color: "rgba(255,255,255,0.3)" }}>
                      Opis
                    </div>
                    <div className="text-[11px]" style={{ color: "rgba(255,255,255,0.7)" }}>
                      Cieknący kran w łazience
                    </div>
                  </div>
                  <div className="flex items-center gap-1 text-[10px]" style={{ color: "rgba(255,255,255,0.4)" }}>
                    <MapPin className="w-3 h-3" />
                    Budynek A · m. 14
                  </div>
                </div>

                {/* Shutter button */}
                <div className="flex items-center justify-center pb-6">
                  <motion.div
                    className="w-14 h-14 rounded-full flex items-center justify-center"
                    style={{
                      background: "linear-gradient(135deg, #3E7BD6, #2A5FA8)",
                      boxShadow: "0 0 24px rgba(62,123,214,0.4)",
                      border: "3px solid rgba(255,255,255,0.15)",
                    }}
                    animate={{ scale: [1, 1.05, 1] }}
                    transition={{ duration: 1.5, repeat: Infinity }}
                  >
                    <Camera className="w-5 h-5 text-white" />
                  </motion.div>
                </div>
              </motion.div>
            )}

            {/* ── SENDING PHASE ── */}
            {phase === "sending" && (
              <motion.div
                key="sending"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.3 }}
                className="absolute inset-0 flex flex-col items-center justify-center gap-4"
                style={{ background: "linear-gradient(180deg, #0a1524 0%, #0d1a2e 100%)" }}
              >
                <motion.div
                  className="w-16 h-16 rounded-2xl flex items-center justify-center"
                  style={{ background: "rgba(62,123,214,0.15)", border: "1px solid rgba(62,123,214,0.25)" }}
                  animate={{ y: [0, -8, 0] }}
                  transition={{ duration: 1, repeat: Infinity }}
                >
                  <Send className="w-7 h-7" style={{ color: "#3E7BD6" }} />
                </motion.div>
                <div className="text-center">
                  <div className="text-sm font-semibold text-white">Wysyłanie zgłoszenia</div>
                  <div className="font-mono text-[10px] mt-1" style={{ color: "rgba(255,255,255,0.35)" }}>
                    MS-2041
                  </div>
                </div>
                {/* Progress bar */}
                <div className="w-32 h-1 rounded-full overflow-hidden" style={{ background: "rgba(255,255,255,0.08)" }}>
                  <motion.div
                    className="h-full rounded-full"
                    style={{ background: "linear-gradient(90deg, #3E7BD6, #6DB3F2)" }}
                    initial={{ width: "0%" }}
                    animate={{ width: "100%" }}
                    transition={{ duration: 1, ease: "easeOut" }}
                  />
                </div>
              </motion.div>
            )}

            {/* ── PUSH NOTIFICATION ── */}
            {phase === "push" && (
              <motion.div
                key="push"
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.3 }}
                className="absolute inset-0"
                style={{ background: "linear-gradient(180deg, #0a1524 0%, #0d1a2e 100%)" }}
              >
                {/* Dimmed background app */}
                <div className="absolute inset-0 opacity-30 p-5 pt-12">
                  <div className="font-mono text-[8px] uppercase tracking-wider mb-2" style={{ color: "rgba(255,255,255,0.3)" }}>
                    Zgłoszenia
                  </div>
                  <div className="space-y-2">
                    {[1, 2, 3].map((i) => (
                      <div key={i} className="rounded-lg p-3" style={{ background: "rgba(255,255,255,0.03)" }}>
                        <div className="h-2 rounded mb-1.5" style={{ background: "rgba(255,255,255,0.08)", width: `${60 + i * 10}%` }} />
                        <div className="h-1.5 rounded" style={{ background: "rgba(255,255,255,0.05)", width: "40%" }} />
                      </div>
                    ))}
                  </div>
                </div>

                {/* Notification card */}
                <motion.div
                  className="absolute top-12 left-3 right-3 rounded-2xl p-4 z-10"
                  style={{
                    background: "rgba(20,30,48,0.95)",
                    border: "1px solid rgba(255,255,255,0.1)",
                    backdropFilter: "blur(20px)",
                    boxShadow: "0 20px 40px rgba(0,0,0,0.4)",
                  }}
                  initial={{ y: -80, opacity: 0 }}
                  animate={{ y: 0, opacity: 1 }}
                  transition={{ type: "spring", stiffness: 300, damping: 25 }}
                >
                  <div className="flex items-start gap-3">
                    <div
                      className="w-9 h-9 rounded-xl flex items-center justify-center shrink-0"
                      style={{ background: "rgba(242,169,0,0.15)" }}
                    >
                      <Bell className="w-4 h-4" style={{ color: "#F2A900" }} />
                    </div>
                    <div className="flex-1 min-w-0">
                      <div className="flex items-center gap-1.5 mb-0.5">
                        <span className="text-[11px] font-bold text-white">Mestio</span>
                        <span className="font-mono text-[8px]" style={{ color: "rgba(255,255,255,0.3)" }}>teraz</span>
                      </div>
                      <div className="text-[11px] font-medium text-white leading-snug">
                        Twoje zgłoszenie zostało przyjęte
                      </div>
                      <div className="text-[10px] mt-0.5" style={{ color: "rgba(255,255,255,0.5)" }}>
                        Cieknący kran · MS-2041
                      </div>
                    </div>
                  </div>
                </motion.div>
              </motion.div>
            )}

            {/* ── STATUS PHASES ── */}
            {(phase === "status_new" || phase === "status_progress" || phase === "status_done") && (
              <motion.div
                key={`status-${phase}`}
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                transition={{ duration: 0.3 }}
                className="absolute inset-0 flex flex-col p-5 pt-10"
                style={{ background: "linear-gradient(180deg, #0a1524 0%, #0d1a2e 100%)" }}
              >
                {/* Header */}
                <div className="flex items-center justify-between mb-4">
                  <span className="font-mono text-[8px] uppercase tracking-wider" style={{ color: "rgba(255,255,255,0.3)" }}>
                    Zgłoszenie
                  </span>
                  <span className="font-mono text-[9px] font-semibold" style={{ color: "rgba(255,255,255,0.4)" }}>
                    MS-2041
                  </span>
                </div>

                {/* Status badge */}
                <motion.div
                  className="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-[11px] font-semibold self-start mb-4"
                  style={{ background: status.bg, color: status.color, border: `1px solid ${status.color}30` }}
                  initial={{ scale: 0.9 }}
                  animate={{ scale: 1 }}
                  transition={{ type: "spring", stiffness: 300, damping: 20 }}
                >
                  {phase === "status_done" ? (
                    <CheckCircle2 className="w-3 h-3" />
                  ) : (
                    <span className="w-1.5 h-1.5 rounded-full bg-current inline-block animate-pulse" />
                  )}
                  {status.label}
                </motion.div>

                {/* Title */}
                <div className="text-sm font-semibold text-white mb-1">Cieknący kran w łazience</div>
                <div className="font-mono text-[10px] mb-4" style={{ color: "rgba(255,255,255,0.35)" }}>
                  Hydraulika · Budynek A · m. 14
                </div>

                {/* Status timeline */}
                <div className="space-y-3 mb-4">
                  {[
                    { label: "Nowe", color: "#3E7BD6", active: ["status_new", "status_progress", "status_done"].includes(phase) },
                    { label: "W realizacji", color: "#F2A900", active: ["status_progress", "status_done"].includes(phase) },
                    { label: "Zamknięte", color: "#22C55E", active: phase === "status_done" },
                  ].map((s, i) => (
                    <div key={s.label} className="flex items-center gap-2.5">
                      <div className="flex flex-col items-center">
                        <motion.div
                          className="w-5 h-5 rounded-full flex items-center justify-center"
                          style={{
                            background: s.active ? s.color : "transparent",
                            border: s.active ? "none" : "1.5px solid rgba(255,255,255,0.1)",
                          }}
                          initial={{ scale: 0.8 }}
                          animate={{ scale: 1 }}
                          transition={{ delay: i * 0.15 }}
                        >
                          {s.active && <Check className="w-2.5 h-2.5 text-white" strokeWidth={3} />}
                        </motion.div>
                        {i < 2 && (
                          <div
                            className="w-0.5 h-4 mt-0.5 rounded"
                            style={{ background: s.active ? `${s.color}40` : "rgba(255,255,255,0.06)" }}
                          />
                        )}
                      </div>
                      <span
                        className="text-[11px] font-medium"
                        style={{ color: s.active ? "#FFF" : "rgba(255,255,255,0.25)" }}
                      >
                        {s.label}
                      </span>
                    </div>
                  ))}
                </div>

                {/* Activity (only in progress/done) */}
                {(phase === "status_progress" || phase === "status_done") && (
                  <motion.div
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 0.3 }}
                    className="mt-auto rounded-xl p-3"
                    style={{ background: "rgba(255,255,255,0.03)", border: "1px solid rgba(255,255,255,0.06)" }}
                  >
                    <div className="flex items-center gap-2">
                      <div
                        className="w-7 h-7 rounded-full flex items-center justify-center text-[9px] font-semibold shrink-0"
                        style={{ background: "rgba(242,169,0,0.15)", color: "#F2A900" }}
                      >
                        MW
                      </div>
                      <div className="flex-1 min-w-0">
                        <div className="text-[11px] font-medium text-white">Marek Wójcik · Serwis</div>
                        <div className="text-[9px] mt-0.5" style={{ color: "rgba(255,255,255,0.4)" }}>
                          {phase === "status_done" ? "Wymieniono zawór, wszystko OK" : "Wymiana zaworu, ETA 14:00"}
                        </div>
                      </div>
                      {phase === "status_done" && <Wrench className="w-3.5 h-3.5" style={{ color: "#22C55E" }} />}
                    </div>
                  </motion.div>
                )}
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </div>

      {/* Phase progress indicator (outside phone) */}
      <div className="absolute -bottom-8 left-1/2 -translate-x-1/2 flex gap-1.5">
        {PHASES.map((p, i) => (
          <div
            key={p.key}
            className="h-1 rounded-full transition-all duration-300"
            style={{
              width: i === phaseIdx ? 20 : 6,
              background: i === phaseIdx ? "#3E7BD6" : "rgba(255,255,255,0.15)",
            }}
          />
        ))}
      </div>
    </div>
  );
}
