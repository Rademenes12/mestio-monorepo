/**
 * Shared TypeScript types for Mestio ecosystem.
 *
 * HISTORY: This package was cleaned to remove dead/misleading types.
 * Each app owns its own role system:
 *   - crm-client + mobile: resident | admin | board | technician | security
 *   - crm-owner: internal pipeline (lead → active → churned)
 *
 * Add types here only when they are genuinely shared between ≥2 apps.
 */

export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[];

export interface Database {
  public: {
    Tables: Record<string, never>;
    Views: Record<string, never>;
    Functions: Record<string, never>;
    Enums: Record<string, never>;
  };
}
