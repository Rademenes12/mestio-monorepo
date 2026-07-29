"use client";

import { createClient } from "@/lib/supabase/client";
import { LogOut } from "lucide-react";

export function LogoutButton({ className = "" }: { className?: string }) {
  const handleLogout = async () => {
    document.cookie = "mestio_demo_role=; path=/; max-age=0;";
    document.cookie = "active_estate_id=; path=/; max-age=0;";
    try {
      const supabase = createClient();
      await supabase.auth.signOut();
    } catch {
      // Ignore errors in demo mode
    }
    window.location.href = "/login";
  };

  return (
    <button
      type="button"
      onClick={handleLogout}
      className={`sidebar-link-muted w-full flex items-center gap-2.5 px-3 py-2 rounded-lg text-sm transition-colors text-red-400 hover:text-red-300 hover:bg-red-500/10 ${className}`}
    >
      <LogOut className="w-4 h-4 shrink-0" />
      <span>Wyloguj się</span>
    </button>
  );
}
