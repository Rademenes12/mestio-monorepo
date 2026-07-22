/**
 * Shared TypeScript types for Mestio ecosystem.
 * Mirrors Supabase schema — regenerate when schema changes.
 */

// ── User roles ──────────────────────────────────────────────

export type UserRole = 'owner' | 'client' | 'tenant' | 'admin';

export interface Profile {
  id: string;
  email: string;
  full_name: string | null;
  role: UserRole;
  phone: string | null;
  avatar_url: string | null;
  company_name: string | null;
  created_at: string;
  updated_at: string;
}

// ── Properties & Units ──────────────────────────────────────

export interface Property {
  id: string;
  name: string;
  address: string;
  city: string;
  postal_code: string;
  owner_id: string;
  created_at: string;
  updated_at: string;
}

export interface Unit {
  id: string;
  property_id: string;
  unit_number: string;
  floor: number | null;
  area_sqm: number | null;
  tenant_id: string | null;
  status: 'occupied' | 'vacant' | 'maintenance';
  created_at: string;
}

// ── Tenants ─────────────────────────────────────────────────

export interface Tenant {
  id: string;
  profile_id: string;
  unit_id: string | null;
  lease_start: string | null;
  lease_end: string | null;
  rent_amount: number | null;
  created_at: string;
}

// ── Tickets (Zgłoszenia) ───────────────────────────────────

export type TicketStatus = 'new' | 'in_progress' | 'resolved' | 'rejected' | 'closed';
export type TicketPriority = 'low' | 'medium' | 'high' | 'critical';
export type TicketCategory = 'plumbing' | 'electrical' | 'hvac' | 'structural' | 'other';

export interface Ticket {
  id: string;
  title: string;
  description: string;
  status: TicketStatus;
  priority: TicketPriority;
  category: TicketCategory;
  reporter_id: string;
  assigned_to: string | null;
  property_id: string;
  unit_id: string | null;
  photos: string[];
  created_at: string;
  updated_at: string;
  resolved_at: string | null;
}

// ── Payments ────────────────────────────────────────────────

export type PaymentStatus = 'pending' | 'paid' | 'overdue' | 'cancelled';

export interface Payment {
  id: string;
  tenant_id: string;
  property_id: string;
  unit_id: string | null;
  amount: number;
  currency: string;
  status: PaymentStatus;
  due_date: string;
  paid_at: string | null;
  stripe_payment_id: string | null;
  created_at: string;
}

// ── Messages ────────────────────────────────────────────────

export interface Message {
  id: string;
  sender_id: string;
  receiver_id: string;
  ticket_id: string | null;
  content: string;
  read_at: string | null;
  created_at: string;
}

// ── CRM (Owner dashboard) ──────────────────────────────────

export type LeadStatus = 'new' | 'contacted' | 'qualified' | 'proposal' | 'won' | 'lost';

export interface CrmLead {
  id: string;
  company_name: string;
  contact_person: string;
  email: string;
  phone: string | null;
  status: LeadStatus;
  value: number | null;
  notes: string | null;
  assigned_to: string | null;
  created_at: string;
  updated_at: string;
}

export interface CrmTask {
  id: string;
  title: string;
  description: string | null;
  assignee_id: string | null;
  due_date: string | null;
  completed: boolean;
  created_at: string;
}

// ── Automations ─────────────────────────────────────────────

export interface Automation {
  id: string;
  name: string;
  trigger: string;
  actions: string[];
  active: boolean;
  created_at: string;
}

export interface AutomationRun {
  id: string;
  automation_id: string;
  run_key: string;
  status: 'success' | 'failed';
  created_at: string;
}
