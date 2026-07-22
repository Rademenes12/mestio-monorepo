/**
 * Supabase generated types.
 * Run `npm run gen:types` to regenerate from live schema.
 * Placeholder — will be replaced by supabase gen output.
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
    Tables: {
      profiles: {
        Row: {
          id: string;
          email: string;
          full_name: string | null;
          role: 'owner' | 'client' | 'tenant' | 'admin';
          phone: string | null;
          avatar_url: string | null;
          company_name: string | null;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database['public']['Tables']['profiles']['Row'], 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['profiles']['Insert']>;
      };
      properties: {
        Row: {
          id: string;
          name: string;
          address: string;
          city: string;
          postal_code: string;
          owner_id: string;
          created_at: string;
          updated_at: string;
        };
        Insert: Omit<Database['public']['Tables']['properties']['Row'], 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['properties']['Insert']>;
      };
      units: {
        Row: {
          id: string;
          property_id: string;
          unit_number: string;
          floor: number | null;
          area_sqm: number | null;
          tenant_id: string | null;
          status: 'occupied' | 'vacant' | 'maintenance';
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['units']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['units']['Insert']>;
      };
      tenants: {
        Row: {
          id: string;
          profile_id: string;
          unit_id: string | null;
          lease_start: string | null;
          lease_end: string | null;
          rent_amount: number | null;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['tenants']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['tenants']['Insert']>;
      };
      tickets: {
        Row: {
          id: string;
          title: string;
          description: string;
          status: 'new' | 'in_progress' | 'resolved' | 'rejected' | 'closed';
          priority: 'low' | 'medium' | 'high' | 'critical';
          category: 'plumbing' | 'electrical' | 'hvac' | 'structural' | 'other';
          reporter_id: string;
          assigned_to: string | null;
          property_id: string;
          unit_id: string | null;
          photos: string[];
          created_at: string;
          updated_at: string;
          resolved_at: string | null;
        };
        Insert: Omit<Database['public']['Tables']['tickets']['Row'], 'id' | 'created_at' | 'updated_at'>;
        Update: Partial<Database['public']['Tables']['tickets']['Insert']>;
      };
      payments: {
        Row: {
          id: string;
          tenant_id: string;
          property_id: string;
          unit_id: string | null;
          amount: number;
          currency: string;
          status: 'pending' | 'paid' | 'overdue' | 'cancelled';
          due_date: string;
          paid_at: string | null;
          stripe_payment_id: string | null;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['payments']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['payments']['Insert']>;
      };
      messages: {
        Row: {
          id: string;
          sender_id: string;
          receiver_id: string;
          ticket_id: string | null;
          content: string;
          read_at: string | null;
          created_at: string;
        };
        Insert: Omit<Database['public']['Tables']['messages']['Row'], 'id' | 'created_at'>;
        Update: Partial<Database['public']['Tables']['messages']['Insert']>;
      };
    };
    Views: Record<string, never>;
    Functions: Record<string, never>;
    Enums: Record<string, never>;
  };
}
