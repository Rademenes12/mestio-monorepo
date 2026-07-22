export type ReportStatus = "Nowe" | "W realizacji" | "Zamkniete" | "Odrzucone";
export type ReportStatusEnum = "new" | "in_progress" | "closed" | "rejected";
export type ReportPriority = "low" | "normal" | "high" | "critical";
export type UserRole = "resident" | "admin" | "board" | "technician" | "security";

export interface Estate {
  id: string;
  name: string;
  address: string | null;
  company_name: string | null;
  hide_resident_contacts: boolean;
  status: string;
  created_at: string;
}

export interface UserEstate {
  user_id: string;
  estate_id: string;
  role: UserRole;
}

export interface Report {
  id: string;
  display_id: string | null;
  title: string;
  description: string | null;
  category: string | null;
  reporter_name: string | null;
  reporter_building: string | null;
  reporter_footbridge: string | null;
  reporter_floor: string | null;
  reporter_apartment: string | null;
  reporter_user_id: string | null;
  status: ReportStatus;
  status_enum: ReportStatusEnum | null;
  priority: ReportPriority;
  sla_deadline: string | null;
  estate_id: string;
  assigned_to_user_id: string | null;
  assigned_to_name: string | null;
  assigned_to_role: string | null;
  photo_path: string | null;
  created_at: string;
  updated_at: string;
}

export interface ReportInternalNote {
  report_id: string;
  board_notes: string | null;
  internal_tech_notes: string | null;
  created_at: string;
  updated_at: string;
}

export interface ReportComment {
  id: string;
  report_id: string;
  author_id: string;
  content: string;
  is_internal: boolean;
  created_at: string;
}

export interface ReportEvent {
  id: string;
  report_id: string;
  event_type: string;
  description: string | null;
  user_name: string | null;
  user_role: string | null;
  old_value: string | null;
  new_value: string | null;
  created_at: string;
}

export interface Building {
  id: string;
  estate_id: string;
  name: string;
  building_type: "residential" | "garage";
  display_order: number;
}

export interface Stairwell {
  id: string;
  building_id: string;
  name: string;
  floor_min: number;
  floor_max: number;
  display_order: number;
}

export interface ResidentProfile {
  id: string;
  name: string | null;
  email: string | null;
  phone: string | null;
  building: string | null;
  footbridge: string | null;
  floor: string | null;
  apartment: string | null;
  role: string;
  is_verified: boolean;
}

export const STATUS_CONFIG: Record<
  ReportStatus,
  { color: string; enum: ReportStatusEnum }
> = {
  Nowe: { color: "var(--color-status-new)", enum: "new" },
  "W realizacji": { color: "var(--color-status-progress)", enum: "in_progress" },
  Zamkniete: { color: "var(--color-status-closed)", enum: "closed" },
  Odrzucone: { color: "var(--color-status-rejected)", enum: "rejected" },
};

export interface DbTask {
  id: string;
  estate_id: string;
  title: string;
  description: string | null;
  status: string;
  priority: string;
  deadline: string | null;
  assigned_to: string | null;
  related_resident_id: string | null;
  created_by: string | null;
  created_at: string;
  updated_at: string;
}

export interface DbAnnouncement {
  id: string;
  title: string;
  content: string;
  author_name: string | null;
  author_role: string | null;
  scope_type: string;
  scope_building_id: string | null;
  scope_stairwell_id: string | null;
  estate_id: string | null;
  is_active: boolean;
  created_at: string;
}

export interface DbInviteCode {
  id: string;
  estate_id: string;
  code: string;
  role: string;
  auto_join: boolean;
  is_active: boolean;
  max_uses: number | null;
  current_uses: number;
  created_at: string;
}

export interface DbJoinRequest {
  id: string;
  estate_id: string;
  user_id: string;
  role: string;
  status: string;
  info: string | null;
  created_at: string;
  decided_at: string | null;
}

export interface Invoice {
  id: string;
  user_id: string;
  invoice_number: string;
  plan_name: string | null;
  amount_net: number | null;
  amount_vat: number | null;
  amount_gross: number | null;
  status: "issued" | "paid" | "cancelled";
  html_content: string | null;
  created_at: string;
}

export const PRIORITY_CONFIG: Record<
  ReportPriority,
  { label: string; color: string }
> = {
  low: { label: "Niski", color: "#6B7A90" },
  normal: { label: "Normalny", color: "#3E7BD6" },
  high: { label: "Wysoki", color: "#F2A900" },
  critical: { label: "Krytyczny", color: "#DC2626" },
};
