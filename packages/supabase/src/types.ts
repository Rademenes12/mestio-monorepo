export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export type Database = {
  // Allows to automatically instantiate createClient with right options
  // instead of createClient<Database, { PostgrestVersion: 'XX' }>(URL, KEY)
  __InternalSupabase: {
    PostgrestVersion: "14.5"
  }
  public: {
    Tables: {
      approval_logs: {
        Row: {
          action: string
          ai_content_checked: boolean | null
          ai_probability: number | null
          approval_required_by: string | null
          created_at: string | null
          created_by: string | null
          draft_id: string
          id: string
          phishing_checked: boolean | null
          phishing_risk_level: string | null
          plagiarism_checked: boolean | null
          plagiarism_score: number | null
          review_notes: string | null
          user_id: string
        }
        Insert: {
          action: string
          ai_content_checked?: boolean | null
          ai_probability?: number | null
          approval_required_by?: string | null
          created_at?: string | null
          created_by?: string | null
          draft_id: string
          id?: string
          phishing_checked?: boolean | null
          phishing_risk_level?: string | null
          plagiarism_checked?: boolean | null
          plagiarism_score?: number | null
          review_notes?: string | null
          user_id: string
        }
        Update: {
          action?: string
          ai_content_checked?: boolean | null
          ai_probability?: number | null
          approval_required_by?: string | null
          created_at?: string | null
          created_by?: string | null
          draft_id?: string
          id?: string
          phishing_checked?: boolean | null
          phishing_risk_level?: string | null
          plagiarism_checked?: boolean | null
          plagiarism_score?: number | null
          review_notes?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "approval_logs_draft_id_fkey"
            columns: ["draft_id"]
            isOneToOne: false
            referencedRelation: "newsletter_drafts"
            referencedColumns: ["id"]
          },
        ]
      }
      blog_posts: {
        Row: {
          author_name: string | null
          body: string
          category: string | null
          content: string | null
          cover_image: string | null
          cover_url: string | null
          created_at: string | null
          excerpt: string | null
          id: string
          meta_description: string | null
          publish_at: string | null
          published_at: string | null
          slug: string
          status: string | null
          tags: string[] | null
          title: string
          updated_at: string | null
          www_slug: string | null
        }
        Insert: {
          author_name?: string | null
          body: string
          category?: string | null
          content?: string | null
          cover_image?: string | null
          cover_url?: string | null
          created_at?: string | null
          excerpt?: string | null
          id?: string
          meta_description?: string | null
          publish_at?: string | null
          published_at?: string | null
          slug: string
          status?: string | null
          tags?: string[] | null
          title: string
          updated_at?: string | null
          www_slug?: string | null
        }
        Update: {
          author_name?: string | null
          body?: string
          category?: string | null
          content?: string | null
          cover_image?: string | null
          cover_url?: string | null
          created_at?: string | null
          excerpt?: string | null
          id?: string
          meta_description?: string | null
          publish_at?: string | null
          published_at?: string | null
          slug?: string
          status?: string | null
          tags?: string[] | null
          title?: string
          updated_at?: string | null
          www_slug?: string | null
        }
        Relationships: []
      }
      client_documents: {
        Row: {
          body: string
          created_at: string | null
          id: string
          lead_id: string | null
          signed_at: string | null
          status: string | null
          title: string
          type: string
        }
        Insert: {
          body: string
          created_at?: string | null
          id?: string
          lead_id?: string | null
          signed_at?: string | null
          status?: string | null
          title: string
          type: string
        }
        Update: {
          body?: string
          created_at?: string | null
          id?: string
          lead_id?: string | null
          signed_at?: string | null
          status?: string | null
          title?: string
          type?: string
        }
        Relationships: [
          {
            foreignKeyName: "client_documents_lead_id_fkey"
            columns: ["lead_id"]
            isOneToOne: false
            referencedRelation: "crm_leads"
            referencedColumns: ["id"]
          },
        ]
      }
      content_extraction_cache: {
        Row: {
          content_hash: string | null
          created_at: string | null
          expires_at: string | null
          extracted_content: string | null
          extracted_html: string | null
          extracted_title: string | null
          id: string
          source_type: string | null
          source_url: string
          user_id: string
        }
        Insert: {
          content_hash?: string | null
          created_at?: string | null
          expires_at?: string | null
          extracted_content?: string | null
          extracted_html?: string | null
          extracted_title?: string | null
          id?: string
          source_type?: string | null
          source_url: string
          user_id: string
        }
        Update: {
          content_hash?: string | null
          created_at?: string | null
          expires_at?: string | null
          extracted_content?: string | null
          extracted_html?: string | null
          extracted_title?: string | null
          id?: string
          source_type?: string | null
          source_url?: string
          user_id?: string
        }
        Relationships: []
      }
      crm_automation_runs: {
        Row: {
          automation_id: string
          created_at: string | null
          id: string
          run_key: string
        }
        Insert: {
          automation_id: string
          created_at?: string | null
          id?: string
          run_key: string
        }
        Update: {
          automation_id?: string
          created_at?: string | null
          id?: string
          run_key?: string
        }
        Relationships: [
          {
            foreignKeyName: "crm_automation_runs_automation_id_fkey"
            columns: ["automation_id"]
            isOneToOne: false
            referencedRelation: "crm_automations"
            referencedColumns: ["id"]
          },
        ]
      }
      crm_automations: {
        Row: {
          action_config: Json
          action_type: string
          created_at: string | null
          enabled: boolean
          id: string
          name: string
          segment: Json
          trigger_days: number
          trigger_type: string
        }
        Insert: {
          action_config?: Json
          action_type: string
          created_at?: string | null
          enabled?: boolean
          id?: string
          name: string
          segment?: Json
          trigger_days?: number
          trigger_type: string
        }
        Update: {
          action_config?: Json
          action_type?: string
          created_at?: string | null
          enabled?: boolean
          id?: string
          name?: string
          segment?: Json
          trigger_days?: number
          trigger_type?: string
        }
        Relationships: []
      }
      crm_email_queue: {
        Row: {
          attempts: number
          created_at: string | null
          error: string | null
          id: string
          lead_id: string
          scheduled_at: string
          sent_at: string | null
          status: string
          template_key: string
        }
        Insert: {
          attempts?: number
          created_at?: string | null
          error?: string | null
          id?: string
          lead_id: string
          scheduled_at: string
          sent_at?: string | null
          status?: string
          template_key: string
        }
        Update: {
          attempts?: number
          created_at?: string | null
          error?: string | null
          id?: string
          lead_id?: string
          scheduled_at?: string
          sent_at?: string | null
          status?: string
          template_key?: string
        }
        Relationships: [
          {
            foreignKeyName: "crm_email_queue_lead_id_fkey"
            columns: ["lead_id"]
            isOneToOne: false
            referencedRelation: "crm_leads"
            referencedColumns: ["id"]
          },
        ]
      }
      crm_emails: {
        Row: {
          body: string
          created_at: string | null
          id: string
          lead_id: string | null
          sent_at: string | null
          sent_by: string | null
          status: string | null
          subject: string
          to_email: string
        }
        Insert: {
          body: string
          created_at?: string | null
          id?: string
          lead_id?: string | null
          sent_at?: string | null
          sent_by?: string | null
          status?: string | null
          subject: string
          to_email: string
        }
        Update: {
          body?: string
          created_at?: string | null
          id?: string
          lead_id?: string | null
          sent_at?: string | null
          sent_by?: string | null
          status?: string | null
          subject?: string
          to_email?: string
        }
        Relationships: [
          {
            foreignKeyName: "crm_emails_lead_id_fkey"
            columns: ["lead_id"]
            isOneToOne: false
            referencedRelation: "crm_leads"
            referencedColumns: ["id"]
          },
        ]
      }
      crm_interactions: {
        Row: {
          created_at: string | null
          id: string
          lead_id: string
          summary: string
          type: string
        }
        Insert: {
          created_at?: string | null
          id?: string
          lead_id: string
          summary: string
          type: string
        }
        Update: {
          created_at?: string | null
          id?: string
          lead_id?: string
          summary?: string
          type?: string
        }
        Relationships: [
          {
            foreignKeyName: "crm_interactions_lead_id_fkey"
            columns: ["lead_id"]
            isOneToOne: false
            referencedRelation: "crm_leads"
            referencedColumns: ["id"]
          },
        ]
      }
      crm_invoice_counters: {
        Row: {
          last_number: number
          year: number
        }
        Insert: {
          last_number?: number
          year: number
        }
        Update: {
          last_number?: number
          year?: number
        }
        Relationships: []
      }
      crm_invoices: {
        Row: {
          amount: number
          created_at: string | null
          currency: string | null
          due_date: string | null
          id: string
          issued_at: string
          ksef_reference: string | null
          ksef_status: string | null
          lead_id: string
          line_items: Json | null
          number: string
          paid_at: string | null
          status: string | null
          stripe_invoice_id: string | null
        }
        Insert: {
          amount: number
          created_at?: string | null
          currency?: string | null
          due_date?: string | null
          id?: string
          issued_at: string
          ksef_reference?: string | null
          ksef_status?: string | null
          lead_id: string
          line_items?: Json | null
          number: string
          paid_at?: string | null
          status?: string | null
          stripe_invoice_id?: string | null
        }
        Update: {
          amount?: number
          created_at?: string | null
          currency?: string | null
          due_date?: string | null
          id?: string
          issued_at?: string
          ksef_reference?: string | null
          ksef_status?: string | null
          lead_id?: string
          line_items?: Json | null
          number?: string
          paid_at?: string | null
          status?: string | null
          stripe_invoice_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "crm_invoices_lead_id_fkey"
            columns: ["lead_id"]
            isOneToOne: false
            referencedRelation: "crm_leads"
            referencedColumns: ["id"]
          },
        ]
      }
      crm_leads: {
        Row: {
          company_name: string
          contact_email: string | null
          contact_name: string | null
          contact_phone: string | null
          contract_end: string | null
          created_at: string | null
          estate_id: string | null
          id: string
          mrr: number | null
          nip: string | null
          notes: string | null
          plan: string | null
          source: string | null
          stage: string
          updated_at: string | null
        }
        Insert: {
          company_name: string
          contact_email?: string | null
          contact_name?: string | null
          contact_phone?: string | null
          contract_end?: string | null
          created_at?: string | null
          estate_id?: string | null
          id?: string
          mrr?: number | null
          nip?: string | null
          notes?: string | null
          plan?: string | null
          source?: string | null
          stage?: string
          updated_at?: string | null
        }
        Update: {
          company_name?: string
          contact_email?: string | null
          contact_name?: string | null
          contact_phone?: string | null
          contract_end?: string | null
          created_at?: string | null
          estate_id?: string | null
          id?: string
          mrr?: number | null
          nip?: string | null
          notes?: string | null
          plan?: string | null
          source?: string | null
          stage?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "crm_leads_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "estates"
            referencedColumns: ["id"]
          },
        ]
      }
      crm_settings: {
        Row: {
          key: string
          value: Json
        }
        Insert: {
          key: string
          value: Json
        }
        Update: {
          key?: string
          value?: Json
        }
        Relationships: []
      }
      crm_tasks: {
        Row: {
          assigned_to: string | null
          completed_at: string | null
          created_at: string | null
          description: string | null
          due_date: string | null
          id: string
          priority: string
          progress: number | null
          status: string
          title: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          assigned_to?: string | null
          completed_at?: string | null
          created_at?: string | null
          description?: string | null
          due_date?: string | null
          id?: string
          priority?: string
          progress?: number | null
          status?: string
          title: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          assigned_to?: string | null
          completed_at?: string | null
          created_at?: string | null
          description?: string | null
          due_date?: string | null
          id?: string
          priority?: string
          progress?: number | null
          status?: string
          title?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: []
      }
      estate_buildings: {
        Row: {
          address: string | null
          created_at: string | null
          estate_id: string
          id: string
          name: string
          updated_at: string | null
        }
        Insert: {
          address?: string | null
          created_at?: string | null
          estate_id: string
          id?: string
          name: string
          updated_at?: string | null
        }
        Update: {
          address?: string | null
          created_at?: string | null
          estate_id?: string
          id?: string
          name?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "estate_buildings_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "estates"
            referencedColumns: ["id"]
          },
        ]
      }
      estate_tenants: {
        Row: {
          created_at: string | null
          email: string | null
          full_name: string
          id: string
          is_owner: boolean | null
          is_primary: boolean | null
          move_in_date: string | null
          move_out_date: string | null
          notes: string | null
          phone: string | null
          unit_id: string
          updated_at: string | null
          user_id: string | null
        }
        Insert: {
          created_at?: string | null
          email?: string | null
          full_name: string
          id?: string
          is_owner?: boolean | null
          is_primary?: boolean | null
          move_in_date?: string | null
          move_out_date?: string | null
          notes?: string | null
          phone?: string | null
          unit_id: string
          updated_at?: string | null
          user_id?: string | null
        }
        Update: {
          created_at?: string | null
          email?: string | null
          full_name?: string
          id?: string
          is_owner?: boolean | null
          is_primary?: boolean | null
          move_in_date?: string | null
          move_out_date?: string | null
          notes?: string | null
          phone?: string | null
          unit_id?: string
          updated_at?: string | null
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "estate_tenants_unit_id_fkey"
            columns: ["unit_id"]
            isOneToOne: false
            referencedRelation: "estate_units"
            referencedColumns: ["id"]
          },
        ]
      }
      estate_units: {
        Row: {
          area_sqm: number | null
          building_id: string
          created_at: string | null
          estate_id: string
          floor: number | null
          id: string
          rooms: number | null
          status: string
          unit_number: string
          updated_at: string | null
        }
        Insert: {
          area_sqm?: number | null
          building_id: string
          created_at?: string | null
          estate_id: string
          floor?: number | null
          id?: string
          rooms?: number | null
          status?: string
          unit_number: string
          updated_at?: string | null
        }
        Update: {
          area_sqm?: number | null
          building_id?: string
          created_at?: string | null
          estate_id?: string
          floor?: number | null
          id?: string
          rooms?: number | null
          status?: string
          unit_number?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "estate_units_building_id_fkey"
            columns: ["building_id"]
            isOneToOne: false
            referencedRelation: "estate_buildings"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "estate_units_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "estates"
            referencedColumns: ["id"]
          },
        ]
      }
      estates: {
        Row: {
          address: string | null
          city: string | null
          created_at: string | null
          id: string
          name: string
          postal_code: string | null
          updated_at: string | null
        }
        Insert: {
          address?: string | null
          city?: string | null
          created_at?: string | null
          id?: string
          name: string
          postal_code?: string | null
          updated_at?: string | null
        }
        Update: {
          address?: string | null
          city?: string | null
          created_at?: string | null
          id?: string
          name?: string
          postal_code?: string | null
          updated_at?: string | null
        }
        Relationships: []
      }
      expenses: {
        Row: {
          amount: number
          category: string
          created_at: string | null
          description: string | null
          id: string
          incurred_at: string | null
        }
        Insert: {
          amount: number
          category?: string
          created_at?: string | null
          description?: string | null
          id?: string
          incurred_at?: string | null
        }
        Update: {
          amount?: number
          category?: string
          created_at?: string | null
          description?: string | null
          id?: string
          incurred_at?: string | null
        }
        Relationships: []
      }
      feedback: {
        Row: {
          author_email: string | null
          category: string | null
          created_at: string | null
          description: string | null
          id: string
          source: string | null
          status: string | null
          title: string
        }
        Insert: {
          author_email?: string | null
          category?: string | null
          created_at?: string | null
          description?: string | null
          id?: string
          source?: string | null
          status?: string | null
          title: string
        }
        Update: {
          author_email?: string | null
          category?: string | null
          created_at?: string | null
          description?: string | null
          id?: string
          source?: string | null
          status?: string | null
          title?: string
        }
        Relationships: []
      }
      fixflow_announcements: {
        Row: {
          author_id: string | null
          author_name: string | null
          author_role: string | null
          content: string
          created_at: string
          estate_id: string | null
          expires_at: string | null
          id: string
          is_active: boolean
          scope_building_id: string | null
          scope_stairwell_id: string | null
          scope_type: string
          target_label: string | null
          title: string
          updated_at: string
        }
        Insert: {
          author_id?: string | null
          author_name?: string | null
          author_role?: string | null
          content: string
          created_at?: string
          estate_id?: string | null
          expires_at?: string | null
          id?: string
          is_active?: boolean
          scope_building_id?: string | null
          scope_stairwell_id?: string | null
          scope_type?: string
          target_label?: string | null
          title: string
          updated_at?: string
        }
        Update: {
          author_id?: string | null
          author_name?: string | null
          author_role?: string | null
          content?: string
          created_at?: string
          estate_id?: string | null
          expires_at?: string | null
          id?: string
          is_active?: boolean
          scope_building_id?: string | null
          scope_stairwell_id?: string | null
          scope_type?: string
          target_label?: string | null
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_announcements_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_announcements_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
          {
            foreignKeyName: "fixflow_announcements_scope_building_id_fkey"
            columns: ["scope_building_id"]
            isOneToOne: false
            referencedRelation: "fixflow_buildings"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_announcements_scope_stairwell_id_fkey"
            columns: ["scope_stairwell_id"]
            isOneToOne: false
            referencedRelation: "fixflow_stairwells"
            referencedColumns: ["id"]
          },
        ]
      }
      fixflow_blocked_users: {
        Row: {
          blocked_id: string
          blocker_id: string
          created_at: string
          id: string
          reason: string | null
        }
        Insert: {
          blocked_id: string
          blocker_id: string
          created_at?: string
          id?: string
          reason?: string | null
        }
        Update: {
          blocked_id?: string
          blocker_id?: string
          created_at?: string
          id?: string
          reason?: string | null
        }
        Relationships: []
      }
      fixflow_buildings: {
        Row: {
          address: string | null
          building_type:
            | Database["public"]["Enums"]["fixflow_building_type"]
            | null
          created_at: string
          display_order: number
          estate_id: string
          id: string
          name: string
          updated_at: string
        }
        Insert: {
          address?: string | null
          building_type?:
            | Database["public"]["Enums"]["fixflow_building_type"]
            | null
          created_at?: string
          display_order?: number
          estate_id: string
          id?: string
          name: string
          updated_at?: string
        }
        Update: {
          address?: string | null
          building_type?:
            | Database["public"]["Enums"]["fixflow_building_type"]
            | null
          created_at?: string
          display_order?: number
          estate_id?: string
          id?: string
          name?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_buildings_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_buildings_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_client_documents: {
        Row: {
          created_at: string
          estate_id: string
          file_url: string | null
          id: string
          meta: string | null
          name: string
          status: string
        }
        Insert: {
          created_at?: string
          estate_id: string
          file_url?: string | null
          id?: string
          meta?: string | null
          name: string
          status?: string
        }
        Update: {
          created_at?: string
          estate_id?: string
          file_url?: string | null
          id?: string
          meta?: string | null
          name?: string
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_client_documents_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_client_documents_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_client_invoices: {
        Row: {
          amount: string | null
          created_at: string
          estate_id: string
          file_url: string | null
          id: string
          invoice_number: string
          period: string | null
          status: string
        }
        Insert: {
          amount?: string | null
          created_at?: string
          estate_id: string
          file_url?: string | null
          id?: string
          invoice_number: string
          period?: string | null
          status?: string
        }
        Update: {
          amount?: string | null
          created_at?: string
          estate_id?: string
          file_url?: string | null
          id?: string
          invoice_number?: string
          period?: string | null
          status?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_client_invoices_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_client_invoices_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_code_redemption_attempts: {
        Row: {
          attempted_at: string
          id: string
          success: boolean
          user_id: string
        }
        Insert: {
          attempted_at?: string
          id?: string
          success?: boolean
          user_id: string
        }
        Update: {
          attempted_at?: string
          id?: string
          success?: boolean
          user_id?: string
        }
        Relationships: []
      }
      fixflow_contact_notes: {
        Row: {
          body: string
          created_at: string
          created_by: string | null
          estate_id: string
          id: string
          resident_id: string
        }
        Insert: {
          body: string
          created_at?: string
          created_by?: string | null
          estate_id: string
          id?: string
          resident_id: string
        }
        Update: {
          body?: string
          created_at?: string
          created_by?: string | null
          estate_id?: string
          id?: string
          resident_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_contact_notes_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_contact_notes_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
          {
            foreignKeyName: "fixflow_contact_notes_resident_id_fkey"
            columns: ["resident_id"]
            isOneToOne: false
            referencedRelation: "fixflow_resident_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_contact_notes_resident_id_fkey"
            columns: ["resident_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_residents_by_estate"
            referencedColumns: ["id"]
          },
        ]
      }
      fixflow_content_reports: {
        Row: {
          content_id: string
          content_type: Database["public"]["Enums"]["fixflow_content_report_type"]
          created_at: string
          description: string | null
          id: string
          moderator_notes: string | null
          reason: Database["public"]["Enums"]["fixflow_content_report_reason"]
          reporter_id: string
          reviewed_at: string | null
          reviewed_by: string | null
          status: Database["public"]["Enums"]["fixflow_content_report_status"]
          updated_at: string
        }
        Insert: {
          content_id: string
          content_type: Database["public"]["Enums"]["fixflow_content_report_type"]
          created_at?: string
          description?: string | null
          id?: string
          moderator_notes?: string | null
          reason: Database["public"]["Enums"]["fixflow_content_report_reason"]
          reporter_id: string
          reviewed_at?: string | null
          reviewed_by?: string | null
          status?: Database["public"]["Enums"]["fixflow_content_report_status"]
          updated_at?: string
        }
        Update: {
          content_id?: string
          content_type?: Database["public"]["Enums"]["fixflow_content_report_type"]
          created_at?: string
          description?: string | null
          id?: string
          moderator_notes?: string | null
          reason?: Database["public"]["Enums"]["fixflow_content_report_reason"]
          reporter_id?: string
          reviewed_at?: string | null
          reviewed_by?: string | null
          status?: Database["public"]["Enums"]["fixflow_content_report_status"]
          updated_at?: string
        }
        Relationships: []
      }
      fixflow_emergency_contacts: {
        Row: {
          category: string
          created_at: string
          display_order: number
          email: string | null
          estate_id: string | null
          id: string
          is_active: boolean
          name: string
          phone: string
          role: string
          updated_at: string
        }
        Insert: {
          category: string
          created_at?: string
          display_order?: number
          email?: string | null
          estate_id?: string | null
          id?: string
          is_active?: boolean
          name: string
          phone: string
          role: string
          updated_at?: string
        }
        Update: {
          category?: string
          created_at?: string
          display_order?: number
          email?: string | null
          estate_id?: string | null
          id?: string
          is_active?: boolean
          name?: string
          phone?: string
          role?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_emergency_contacts_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_emergency_contacts_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_estates: {
        Row: {
          address: string | null
          admin_email: string | null
          admin_name: string | null
          admin_phone: string | null
          archived_at: string | null
          company_name: string | null
          contract_until: string | null
          created_at: string
          hide_resident_contacts: boolean
          id: string
          name: string
          owner_company_id: string | null
          status: string
          total_shares: number
          updated_at: string
        }
        Insert: {
          address?: string | null
          admin_email?: string | null
          admin_name?: string | null
          admin_phone?: string | null
          archived_at?: string | null
          company_name?: string | null
          contract_until?: string | null
          created_at?: string
          hide_resident_contacts?: boolean
          id?: string
          name: string
          owner_company_id?: string | null
          status?: string
          total_shares?: number
          updated_at?: string
        }
        Update: {
          address?: string | null
          admin_email?: string | null
          admin_name?: string | null
          admin_phone?: string | null
          archived_at?: string | null
          company_name?: string | null
          contract_until?: string | null
          created_at?: string
          hide_resident_contacts?: boolean
          id?: string
          name?: string
          owner_company_id?: string | null
          status?: string
          total_shares?: number
          updated_at?: string
        }
        Relationships: []
      }
      fixflow_feedback: {
        Row: {
          created_at: string
          id: string
          message: string
          type: string
          user_email: string | null
          user_id: string
          user_role: string | null
        }
        Insert: {
          created_at?: string
          id?: string
          message: string
          type: string
          user_email?: string | null
          user_id: string
          user_role?: string | null
        }
        Update: {
          created_at?: string
          id?: string
          message?: string
          type?: string
          user_email?: string | null
          user_id?: string
          user_role?: string | null
        }
        Relationships: []
      }
      fixflow_invitation_codes: {
        Row: {
          auto_join: boolean
          code: string
          created_at: string
          estate_id: string
          expires_at: string | null
          id: string
          is_active: boolean
          max_uses: number | null
          role: string
          updated_at: string
          use_count: number | null
          valid_from: string | null
        }
        Insert: {
          auto_join?: boolean
          code: string
          created_at?: string
          estate_id: string
          expires_at?: string | null
          id?: string
          is_active?: boolean
          max_uses?: number | null
          role?: string
          updated_at?: string
          use_count?: number | null
          valid_from?: string | null
        }
        Update: {
          auto_join?: boolean
          code?: string
          created_at?: string
          estate_id?: string
          expires_at?: string | null
          id?: string
          is_active?: boolean
          max_uses?: number | null
          role?: string
          updated_at?: string
          use_count?: number | null
          valid_from?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_invitation_codes_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_invitation_codes_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_invoices: {
        Row: {
          amount_gross: number
          amount_net: number
          amount_vat: number
          buyer_company: string
          buyer_nip: string
          created_at: string
          currency: string
          estate_id: string
          html_content: string
          id: string
          invoice_number: string
          period_end: string
          period_start: string
          plan_name: string
          status: string
          stripe_payment_intent_id: string | null
          subscription_id: string
          user_id: string
          vat_rate: number
        }
        Insert: {
          amount_gross: number
          amount_net: number
          amount_vat: number
          buyer_company: string
          buyer_nip: string
          created_at?: string
          currency?: string
          estate_id: string
          html_content: string
          id?: string
          invoice_number: string
          period_end: string
          period_start: string
          plan_name: string
          status?: string
          stripe_payment_intent_id?: string | null
          subscription_id: string
          user_id: string
          vat_rate?: number
        }
        Update: {
          amount_gross?: number
          amount_net?: number
          amount_vat?: number
          buyer_company?: string
          buyer_nip?: string
          created_at?: string
          currency?: string
          estate_id?: string
          html_content?: string
          id?: string
          invoice_number?: string
          period_end?: string
          period_start?: string
          plan_name?: string
          status?: string
          stripe_payment_intent_id?: string | null
          subscription_id?: string
          user_id?: string
          vat_rate?: number
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_invoices_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_invoices_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_join_requests: {
        Row: {
          created_at: string | null
          decided_at: string | null
          decided_by: string | null
          estate_id: string
          id: string
          info: string | null
          role: string
          status: string
          user_id: string
        }
        Insert: {
          created_at?: string | null
          decided_at?: string | null
          decided_by?: string | null
          estate_id: string
          id?: string
          info?: string | null
          role: string
          status?: string
          user_id: string
        }
        Update: {
          created_at?: string | null
          decided_at?: string | null
          decided_by?: string | null
          estate_id?: string
          id?: string
          info?: string | null
          role?: string
          status?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_join_requests_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_join_requests_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_maintenance_schedules: {
        Row: {
          building_id: string | null
          created_at: string | null
          description: string | null
          estate_id: string
          frequency_days: number
          id: string
          last_performed: string | null
          name: string
          next_due_date: string
          updated_at: string | null
        }
        Insert: {
          building_id?: string | null
          created_at?: string | null
          description?: string | null
          estate_id: string
          frequency_days?: number
          id?: string
          last_performed?: string | null
          name: string
          next_due_date: string
          updated_at?: string | null
        }
        Update: {
          building_id?: string | null
          created_at?: string | null
          description?: string | null
          estate_id?: string
          frequency_days?: number
          id?: string
          last_performed?: string | null
          name?: string
          next_due_date?: string
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_maintenance_schedules_building_id_fkey"
            columns: ["building_id"]
            isOneToOne: false
            referencedRelation: "fixflow_buildings"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_maintenance_schedules_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_maintenance_schedules_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_permissions: {
        Row: {
          created_at: string
          estate_id: string
          id: string
          role: string
          user_id: string
        }
        Insert: {
          created_at?: string
          estate_id: string
          id?: string
          role: string
          user_id: string
        }
        Update: {
          created_at?: string
          estate_id?: string
          id?: string
          role?: string
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_permissions_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_permissions_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_report_comments: {
        Row: {
          author_id: string
          content: string
          created_at: string
          id: string
          is_internal: boolean
          is_visible_to_residents: boolean | null
          report_id: string
        }
        Insert: {
          author_id: string
          content: string
          created_at?: string
          id?: string
          is_internal?: boolean
          is_visible_to_residents?: boolean | null
          report_id: string
        }
        Update: {
          author_id?: string
          content?: string
          created_at?: string
          id?: string
          is_internal?: boolean
          is_visible_to_residents?: boolean | null
          report_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_report_comments_report_id_fkey"
            columns: ["report_id"]
            isOneToOne: false
            referencedRelation: "fixflow_reports"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_report_comments_report"
            columns: ["report_id"]
            isOneToOne: false
            referencedRelation: "fixflow_reports"
            referencedColumns: ["id"]
          },
        ]
      }
      fixflow_report_counters: {
        Row: {
          estate_id: string
          last_number: number
          updated_at: string | null
        }
        Insert: {
          estate_id: string
          last_number?: number
          updated_at?: string | null
        }
        Update: {
          estate_id?: string
          last_number?: number
          updated_at?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_report_counters_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: true
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_report_counters_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: true
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_report_events: {
        Row: {
          created_at: string
          description: string | null
          event_type: string
          id: string
          metadata_json: Json | null
          new_value: string | null
          old_value: string | null
          report_id: string
          user_id: string | null
          user_name: string | null
          user_role: string | null
        }
        Insert: {
          created_at?: string
          description?: string | null
          event_type: string
          id?: string
          metadata_json?: Json | null
          new_value?: string | null
          old_value?: string | null
          report_id: string
          user_id?: string | null
          user_name?: string | null
          user_role?: string | null
        }
        Update: {
          created_at?: string
          description?: string | null
          event_type?: string
          id?: string
          metadata_json?: Json | null
          new_value?: string | null
          old_value?: string | null
          report_id?: string
          user_id?: string | null
          user_name?: string | null
          user_role?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_report_events_report_id_fkey"
            columns: ["report_id"]
            isOneToOne: false
            referencedRelation: "fixflow_reports"
            referencedColumns: ["id"]
          },
        ]
      }
      fixflow_report_images: {
        Row: {
          created_at: string
          id: string
          image_path: string
          report_id: string
        }
        Insert: {
          created_at?: string
          id?: string
          image_path: string
          report_id: string
        }
        Update: {
          created_at?: string
          id?: string
          image_path?: string
          report_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_report_images_report_id_fkey"
            columns: ["report_id"]
            isOneToOne: false
            referencedRelation: "fixflow_reports"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fk_report_images_report"
            columns: ["report_id"]
            isOneToOne: false
            referencedRelation: "fixflow_reports"
            referencedColumns: ["id"]
          },
        ]
      }
      fixflow_report_internal_notes: {
        Row: {
          board_notes: string | null
          created_at: string
          internal_tech_notes: string | null
          report_id: string
          updated_at: string
        }
        Insert: {
          board_notes?: string | null
          created_at?: string
          internal_tech_notes?: string | null
          report_id: string
          updated_at?: string
        }
        Update: {
          board_notes?: string | null
          created_at?: string
          internal_tech_notes?: string | null
          report_id?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_report_internal_notes_report_id_fkey"
            columns: ["report_id"]
            isOneToOne: true
            referencedRelation: "fixflow_reports"
            referencedColumns: ["id"]
          },
        ]
      }
      fixflow_reports: {
        Row: {
          additional_info: string | null
          assigned_to: string | null
          assigned_to_name: string | null
          assigned_to_role: string | null
          assigned_to_user_id: string | null
          attachments_json: string | null
          audit_trail: Json | null
          board_notes: string | null
          category: string | null
          client_notes: string | null
          created_at: string
          csat_rating: number | null
          description: string | null
          display_id: string | null
          estate_id: string
          id: string
          latitude: number | null
          longitude: number | null
          photo_path: string | null
          priority:
            | Database["public"]["Enums"]["fixflow_report_priority"]
            | null
          reporter_apartment: string | null
          reporter_building: string | null
          reporter_email: string | null
          reporter_floor: string | null
          reporter_footbridge: string | null
          reporter_name: string | null
          reporter_user_id: string | null
          reveal_board_notes_to_tech: boolean
          sla_deadline: string | null
          status: string
          status_enum:
            | Database["public"]["Enums"]["fixflow_report_status"]
            | null
          tech_notes: string | null
          timestamp: number
          title: string
          updated_at: string
        }
        Insert: {
          additional_info?: string | null
          assigned_to?: string | null
          assigned_to_name?: string | null
          assigned_to_role?: string | null
          assigned_to_user_id?: string | null
          attachments_json?: string | null
          audit_trail?: Json | null
          board_notes?: string | null
          category?: string | null
          client_notes?: string | null
          created_at?: string
          csat_rating?: number | null
          description?: string | null
          display_id?: string | null
          estate_id: string
          id?: string
          latitude?: number | null
          longitude?: number | null
          photo_path?: string | null
          priority?:
            | Database["public"]["Enums"]["fixflow_report_priority"]
            | null
          reporter_apartment?: string | null
          reporter_building?: string | null
          reporter_email?: string | null
          reporter_floor?: string | null
          reporter_footbridge?: string | null
          reporter_name?: string | null
          reporter_user_id?: string | null
          reveal_board_notes_to_tech?: boolean
          sla_deadline?: string | null
          status?: string
          status_enum?:
            | Database["public"]["Enums"]["fixflow_report_status"]
            | null
          tech_notes?: string | null
          timestamp?: number
          title: string
          updated_at?: string
        }
        Update: {
          additional_info?: string | null
          assigned_to?: string | null
          assigned_to_name?: string | null
          assigned_to_role?: string | null
          assigned_to_user_id?: string | null
          attachments_json?: string | null
          audit_trail?: Json | null
          board_notes?: string | null
          category?: string | null
          client_notes?: string | null
          created_at?: string
          csat_rating?: number | null
          description?: string | null
          display_id?: string | null
          estate_id?: string
          id?: string
          latitude?: number | null
          longitude?: number | null
          photo_path?: string | null
          priority?:
            | Database["public"]["Enums"]["fixflow_report_priority"]
            | null
          reporter_apartment?: string | null
          reporter_building?: string | null
          reporter_email?: string | null
          reporter_floor?: string | null
          reporter_footbridge?: string | null
          reporter_name?: string | null
          reporter_user_id?: string | null
          reveal_board_notes_to_tech?: boolean
          sla_deadline?: string | null
          status?: string
          status_enum?:
            | Database["public"]["Enums"]["fixflow_report_status"]
            | null
          tech_notes?: string | null
          timestamp?: number
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_reports_assigned_to_user_id_fkey"
            columns: ["assigned_to_user_id"]
            isOneToOne: false
            referencedRelation: "fixflow_resident_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_reports_assigned_to_user_id_fkey"
            columns: ["assigned_to_user_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_residents_by_estate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_reports_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_reports_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_resident_profiles: {
        Row: {
          apartment: string | null
          apartment_area: number | null
          building: string | null
          company_name: string | null
          created_at: string
          email: string | null
          estate_id: string | null
          fcm_token: string | null
          floor: string | null
          footbridge: string | null
          id: string
          is_verified: boolean
          name: string | null
          phone: string | null
          role: string
          share_units: number | null
          terms_accepted_at: string | null
          updated_at: string
          user_id: string | null
          verification_code: string | null
        }
        Insert: {
          apartment?: string | null
          apartment_area?: number | null
          building?: string | null
          company_name?: string | null
          created_at?: string
          email?: string | null
          estate_id?: string | null
          fcm_token?: string | null
          floor?: string | null
          footbridge?: string | null
          id: string
          is_verified?: boolean
          name?: string | null
          phone?: string | null
          role?: string
          share_units?: number | null
          terms_accepted_at?: string | null
          updated_at?: string
          user_id?: string | null
          verification_code?: string | null
        }
        Update: {
          apartment?: string | null
          apartment_area?: number | null
          building?: string | null
          company_name?: string | null
          created_at?: string
          email?: string | null
          estate_id?: string | null
          fcm_token?: string | null
          floor?: string | null
          footbridge?: string | null
          id?: string
          is_verified?: boolean
          name?: string | null
          phone?: string | null
          role?: string
          share_units?: number | null
          terms_accepted_at?: string | null
          updated_at?: string
          user_id?: string | null
          verification_code?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_resident_profiles_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_resident_profiles_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_resident_spaces: {
        Row: {
          created_at: string
          created_by: string
          estate_id: string
          id: string
          label: string
          resident_id: string
          type: string
        }
        Insert: {
          created_at?: string
          created_by?: string
          estate_id: string
          id?: string
          label: string
          resident_id: string
          type: string
        }
        Update: {
          created_at?: string
          created_by?: string
          estate_id?: string
          id?: string
          label?: string
          resident_id?: string
          type?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_resident_spaces_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_resident_spaces_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_resolution_votes: {
        Row: {
          choice: string
          created_at: string
          estate_id: string | null
          id: string
          resolution_id: string
          share_units: number
          user_id: string
        }
        Insert: {
          choice: string
          created_at?: string
          estate_id?: string | null
          id?: string
          resolution_id: string
          share_units?: number
          user_id?: string
        }
        Update: {
          choice?: string
          created_at?: string
          estate_id?: string | null
          id?: string
          resolution_id?: string
          share_units?: number
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_resolution_votes_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_resolution_votes_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
          {
            foreignKeyName: "fixflow_resolution_votes_resolution_id_fkey"
            columns: ["resolution_id"]
            isOneToOne: false
            referencedRelation: "fixflow_resolutions"
            referencedColumns: ["id"]
          },
        ]
      }
      fixflow_resolutions: {
        Row: {
          closed_at: string | null
          created_at: string
          created_by: string | null
          deadline: string | null
          description: string | null
          estate_id: string
          id: string
          number: string | null
          status: string
          title: string
        }
        Insert: {
          closed_at?: string | null
          created_at?: string
          created_by?: string | null
          deadline?: string | null
          description?: string | null
          estate_id: string
          id?: string
          number?: string | null
          status?: string
          title: string
        }
        Update: {
          closed_at?: string | null
          created_at?: string
          created_by?: string | null
          deadline?: string | null
          description?: string | null
          estate_id?: string
          id?: string
          number?: string | null
          status?: string
          title?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_resolutions_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_resolutions_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_stairwells: {
        Row: {
          building_id: string
          created_at: string
          display_order: number
          floor_max: number
          floor_min: number
          garage_entrance_label: string | null
          id: string
          name: string
          updated_at: string
        }
        Insert: {
          building_id: string
          created_at?: string
          display_order?: number
          floor_max?: number
          floor_min?: number
          garage_entrance_label?: string | null
          id?: string
          name: string
          updated_at?: string
        }
        Update: {
          building_id?: string
          created_at?: string
          display_order?: number
          floor_max?: number
          floor_min?: number
          garage_entrance_label?: string | null
          id?: string
          name?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_stairwells_building_id_fkey"
            columns: ["building_id"]
            isOneToOne: false
            referencedRelation: "fixflow_buildings"
            referencedColumns: ["id"]
          },
        ]
      }
      fixflow_subscriptions: {
        Row: {
          cancel_at_period_end: boolean | null
          created_at: string
          current_period_end: string | null
          current_period_start: string | null
          estate_id: string | null
          id: string
          metadata_json: Json | null
          status: string
          stripe_customer_id: string
          stripe_price_id: string | null
          stripe_subscription_id: string
          updated_at: string
          user_id: string | null
        }
        Insert: {
          cancel_at_period_end?: boolean | null
          created_at?: string
          current_period_end?: string | null
          current_period_start?: string | null
          estate_id?: string | null
          id?: string
          metadata_json?: Json | null
          status?: string
          stripe_customer_id: string
          stripe_price_id?: string | null
          stripe_subscription_id: string
          updated_at?: string
          user_id?: string | null
        }
        Update: {
          cancel_at_period_end?: boolean | null
          created_at?: string
          current_period_end?: string | null
          current_period_start?: string | null
          estate_id?: string | null
          id?: string
          metadata_json?: Json | null
          status?: string
          stripe_customer_id?: string
          stripe_price_id?: string | null
          stripe_subscription_id?: string
          updated_at?: string
          user_id?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_subscriptions_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_subscriptions_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      fixflow_task_comments: {
        Row: {
          author_name: string | null
          body: string
          created_at: string
          created_by: string | null
          estate_id: string
          id: string
          task_id: string
        }
        Insert: {
          author_name?: string | null
          body: string
          created_at?: string
          created_by?: string | null
          estate_id: string
          id?: string
          task_id: string
        }
        Update: {
          author_name?: string | null
          body?: string
          created_at?: string
          created_by?: string | null
          estate_id?: string
          id?: string
          task_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_task_comments_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_task_comments_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
          {
            foreignKeyName: "fixflow_task_comments_task_id_fkey"
            columns: ["task_id"]
            isOneToOne: false
            referencedRelation: "fixflow_tasks"
            referencedColumns: ["id"]
          },
        ]
      }
      fixflow_tasks: {
        Row: {
          assigned_group: string | null
          assigned_to: string | null
          created_at: string
          created_by: string | null
          deadline: string | null
          description: string | null
          estate_id: string
          id: string
          is_recurring: boolean | null
          kind: string
          priority: string | null
          recurrence_end_date: string | null
          recurrence_interval: number | null
          recurrence_unit: string | null
          related_resident_id: string | null
          status: string
          title: string
          updated_at: string
        }
        Insert: {
          assigned_group?: string | null
          assigned_to?: string | null
          created_at?: string
          created_by?: string | null
          deadline?: string | null
          description?: string | null
          estate_id: string
          id?: string
          is_recurring?: boolean | null
          kind?: string
          priority?: string | null
          recurrence_end_date?: string | null
          recurrence_interval?: number | null
          recurrence_unit?: string | null
          related_resident_id?: string | null
          status?: string
          title: string
          updated_at?: string
        }
        Update: {
          assigned_group?: string | null
          assigned_to?: string | null
          created_at?: string
          created_by?: string | null
          deadline?: string | null
          description?: string | null
          estate_id?: string
          id?: string
          is_recurring?: boolean | null
          kind?: string
          priority?: string | null
          recurrence_end_date?: string | null
          recurrence_interval?: number | null
          recurrence_unit?: string | null
          related_resident_id?: string | null
          status?: string
          title?: string
          updated_at?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_tasks_assigned_to_fkey"
            columns: ["assigned_to"]
            isOneToOne: false
            referencedRelation: "fixflow_resident_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_tasks_assigned_to_fkey"
            columns: ["assigned_to"]
            isOneToOne: false
            referencedRelation: "v_fixflow_residents_by_estate"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_tasks_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_tasks_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
          {
            foreignKeyName: "fixflow_tasks_related_resident_id_fkey"
            columns: ["related_resident_id"]
            isOneToOne: false
            referencedRelation: "fixflow_resident_profiles"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_tasks_related_resident_id_fkey"
            columns: ["related_resident_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_residents_by_estate"
            referencedColumns: ["id"]
          },
        ]
      }
      fixflow_transfer_payments: {
        Row: {
          amount: number
          created_at: string
          due_date: string
          estate_name: string
          id: string
          plan: string
          status: string
          transfer_title: string
          user_id: string
        }
        Insert: {
          amount: number
          created_at?: string
          due_date: string
          estate_name: string
          id?: string
          plan: string
          status?: string
          transfer_title: string
          user_id: string
        }
        Update: {
          amount?: number
          created_at?: string
          due_date?: string
          estate_name?: string
          id?: string
          plan?: string
          status?: string
          transfer_title?: string
          user_id?: string
        }
        Relationships: []
      }
      fixflow_user_estates: {
        Row: {
          apartment: string | null
          building: string | null
          created_at: string
          estate_id: string
          floor: string | null
          role: string
          stairwell: string | null
          user_id: string
        }
        Insert: {
          apartment?: string | null
          building?: string | null
          created_at?: string
          estate_id: string
          floor?: string | null
          role?: string
          stairwell?: string | null
          user_id: string
        }
        Update: {
          apartment?: string | null
          building?: string | null
          created_at?: string
          estate_id?: string
          floor?: string | null
          role?: string
          stairwell?: string | null
          user_id?: string
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_user_estates_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_user_estates_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      newsletter_drafts: {
        Row: {
          ai_generated_probability: number | null
          ai_topic: string | null
          approval_required: boolean | null
          approved_at: string | null
          created_at: string | null
          deleted_at: string | null
          deleted_by: string | null
          extracted_from_url: string | null
          failed_count: number | null
          html_content: string
          id: string
          phishing_risk_level: string | null
          plagiarism_report: Json | null
          plagiarism_score: number | null
          review_notes: string | null
          reviewed_by: string | null
          sent_at: string | null
          sent_to_count: number | null
          soft_deleted: boolean | null
          status: string
          subject: string
          updated_at: string | null
          user_id: string
        }
        Insert: {
          ai_generated_probability?: number | null
          ai_topic?: string | null
          approval_required?: boolean | null
          approved_at?: string | null
          created_at?: string | null
          deleted_at?: string | null
          deleted_by?: string | null
          extracted_from_url?: string | null
          failed_count?: number | null
          html_content: string
          id?: string
          phishing_risk_level?: string | null
          plagiarism_report?: Json | null
          plagiarism_score?: number | null
          review_notes?: string | null
          reviewed_by?: string | null
          sent_at?: string | null
          sent_to_count?: number | null
          soft_deleted?: boolean | null
          status?: string
          subject: string
          updated_at?: string | null
          user_id: string
        }
        Update: {
          ai_generated_probability?: number | null
          ai_topic?: string | null
          approval_required?: boolean | null
          approved_at?: string | null
          created_at?: string | null
          deleted_at?: string | null
          deleted_by?: string | null
          extracted_from_url?: string | null
          failed_count?: number | null
          html_content?: string
          id?: string
          phishing_risk_level?: string | null
          plagiarism_report?: Json | null
          plagiarism_score?: number | null
          review_notes?: string | null
          reviewed_by?: string | null
          sent_at?: string | null
          sent_to_count?: number | null
          soft_deleted?: boolean | null
          status?: string
          subject?: string
          updated_at?: string | null
          user_id?: string
        }
        Relationships: []
      }
      newsletter_send_stats: {
        Row: {
          bounces: number | null
          complaints: number | null
          emails_failed: number | null
          emails_sent: number | null
          id: string
          send_date: string | null
          unsubscribes: number | null
          user_id: string
        }
        Insert: {
          bounces?: number | null
          complaints?: number | null
          emails_failed?: number | null
          emails_sent?: number | null
          id?: string
          send_date?: string | null
          unsubscribes?: number | null
          user_id: string
        }
        Update: {
          bounces?: number | null
          complaints?: number | null
          emails_failed?: number | null
          emails_sent?: number | null
          id?: string
          send_date?: string | null
          unsubscribes?: number | null
          user_id?: string
        }
        Relationships: []
      }
      newsletter_subscribers: {
        Row: {
          email: string
          id: string
          subscribed_at: string | null
          unsubscribed: boolean | null
          unsubscribed_at: string | null
        }
        Insert: {
          email: string
          id?: string
          subscribed_at?: string | null
          unsubscribed?: boolean | null
          unsubscribed_at?: string | null
        }
        Update: {
          email?: string
          id?: string
          subscribed_at?: string | null
          unsubscribed?: boolean | null
          unsubscribed_at?: string | null
        }
        Relationships: []
      }
      pricing_config: {
        Row: {
          amount_grosze: number
          plan_key: string
          price_display: string
          updated_at: string | null
        }
        Insert: {
          amount_grosze?: number
          plan_key: string
          price_display?: string
          updated_at?: string | null
        }
        Update: {
          amount_grosze?: number
          plan_key?: string
          price_display?: string
          updated_at?: string | null
        }
        Relationships: []
      }
      resolutions: {
        Row: {
          closed_at: string | null
          created_at: string
          created_by: string | null
          deadline: string
          description: string | null
          estate_id: string
          id: string
          number: string | null
          status: string
          title: string
          updated_at: string
          votes_abstain: number | null
          votes_against: number | null
          votes_for: number | null
        }
        Insert: {
          closed_at?: string | null
          created_at?: string
          created_by?: string | null
          deadline: string
          description?: string | null
          estate_id: string
          id?: string
          number?: string | null
          status?: string
          title: string
          updated_at?: string
          votes_abstain?: number | null
          votes_against?: number | null
          votes_for?: number | null
        }
        Update: {
          closed_at?: string | null
          created_at?: string
          created_by?: string | null
          deadline?: string
          description?: string | null
          estate_id?: string
          id?: string
          number?: string | null
          status?: string
          title?: string
          updated_at?: string
          votes_abstain?: number | null
          votes_against?: number | null
          votes_for?: number | null
        }
        Relationships: [
          {
            foreignKeyName: "resolutions_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "resolutions_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      shared_user_apps: {
        Row: {
          app_id: string
          app_name: string
          last_seen_at: string
          registered_at: string
          user_id: string
        }
        Insert: {
          app_id: string
          app_name: string
          last_seen_at?: string
          registered_at?: string
          user_id: string
        }
        Update: {
          app_id?: string
          app_name?: string
          last_seen_at?: string
          registered_at?: string
          user_id?: string
        }
        Relationships: []
      }
      shared_users: {
        Row: {
          first_name: string | null
          id: string
        }
        Insert: {
          first_name?: string | null
          id: string
        }
        Update: {
          first_name?: string | null
          id?: string
        }
        Relationships: []
      }
    }
    Views: {
      kpi_cac: {
        Row: {
          acquisition_costs: number | null
          cac: number | null
          month: string | null
          new_count: number | null
        }
        Relationships: []
      }
      kpi_churn: {
        Row: {
          active_start: number | null
          churn_rate_percent: number | null
          churned: number | null
          month: string | null
        }
        Relationships: []
      }
      kpi_ltv: {
        Row: {
          avg_lifetime_months: number | null
          avg_ltv: number | null
          avg_monthly_value: number | null
          median_ltv: number | null
        }
        Relationships: []
      }
      kpi_mrr: {
        Row: {
          churned_mrr: number | null
          customer_count: number | null
          growth_rate_percent: number | null
          month: string | null
          net_mrr: number | null
          new_mrr: number | null
          prev_mrr: number | null
          total_mrr: number | null
        }
        Relationships: []
      }
      v_fixflow_estate_contract: {
        Row: {
          current_period_end: string | null
          estate_id: string | null
          status: string | null
        }
        Insert: {
          current_period_end?: string | null
          estate_id?: string | null
          status?: string | null
        }
        Update: {
          current_period_end?: string | null
          estate_id?: string | null
          status?: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_subscriptions_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_subscriptions_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
      v_fixflow_estate_subscription_status: {
        Row: {
          cancel_at_period_end: boolean | null
          current_period_end: string | null
          estate_id: string | null
          estate_name: string | null
          is_access_allowed: boolean | null
          show_payment_warning: boolean | null
          subscription_status: string | null
        }
        Relationships: []
      }
      v_fixflow_residents_by_estate: {
        Row: {
          apartment: string | null
          building: string | null
          created_at: string | null
          email: string | null
          estate_id: string | null
          floor: string | null
          footbridge: string | null
          id: string | null
          is_verified: boolean | null
          name: string | null
          phone: string | null
          role: string | null
        }
        Relationships: [
          {
            foreignKeyName: "fixflow_user_estates_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "fixflow_estates"
            referencedColumns: ["id"]
          },
          {
            foreignKeyName: "fixflow_user_estates_estate_id_fkey"
            columns: ["estate_id"]
            isOneToOne: false
            referencedRelation: "v_fixflow_estate_subscription_status"
            referencedColumns: ["estate_id"]
          },
        ]
      }
    }
    Functions: {
      anonymize_resident_profiles: {
        Args: { target_profile_id: string }
        Returns: undefined
      }
      crm_anonymize_lead: { Args: { p_lead_id: string }; Returns: undefined }
      crm_next_invoice_number: { Args: never; Returns: string }
      crm_process_email_queue: { Args: never; Returns: undefined }
      crm_to_fixflow_invoice_status: {
        Args: { crm_status: string }
        Returns: string
      }
      fixflow_approve_join_request: {
        Args: { p_request_id: string }
        Returns: undefined
      }
      fixflow_backfill_existing_data: { Args: never; Returns: undefined }
      fixflow_can_rate_report: {
        Args: { p_report_id: string; p_user_id: string }
        Returns: boolean
      }
      fixflow_can_set_priority: {
        Args: { p_user_id: string }
        Returns: boolean
      }
      fixflow_cleanup_expired_announcements: { Args: never; Returns: number }
      fixflow_create_estate: { Args: { p_name: string }; Returns: string }
      fixflow_create_estate_invitation_code: {
        Args: { p_estate_id: string; p_role?: string }
        Returns: string
      }
      fixflow_estate_active: { Args: { p_estate_id: string }; Returns: boolean }
      fixflow_estate_has_active_subscription: {
        Args: { p_estate_id: string }
        Returns: boolean
      }
      fixflow_estate_health_index: {
        Args: { p_estate_id: string }
        Returns: Json
      }
      fixflow_generate_code_string: { Args: never; Returns: string }
      fixflow_generate_report_display_id: {
        Args: { p_estate_id: string }
        Returns: string
      }
      fixflow_get_building_estate_id: {
        Args: { p_building_id: string }
        Returns: string
      }
      fixflow_invalidate_invitation_code: {
        Args: { p_code_id: string }
        Returns: boolean
      }
      fixflow_is_board: { Args: { p_estate_id: string }; Returns: boolean }
      fixflow_is_board_or_admin: {
        Args: { p_user_id: string }
        Returns: boolean
      }
      fixflow_is_estate_admin: {
        Args: { p_estate_id: string }
        Returns: boolean
      }
      fixflow_is_estate_member: {
        Args: { p_estate_id: string }
        Returns: boolean
      }
      fixflow_is_not_resident: { Args: { p_user_id: string }; Returns: boolean }
      fixflow_is_user_blocked:
        | { Args: never; Returns: boolean }
        | { Args: { p_blocked_id: string }; Returns: boolean }
      fixflow_list_resolutions: {
        Args: { p_estate_id: string }
        Returns: {
          closed_at: string
          created_at: string
          deadline: string
          description: string
          id: string
          my_vote: string
          status: string
          title: string
          votes_against: number
          votes_for: number
        }[]
      }
      fixflow_maybe_mask_contacts: {
        Args: { p_email: string; p_estate_id: string; p_phone: string }
        Returns: {
          email: string
          phone: string
        }[]
      }
      fixflow_peek_invitation_code: { Args: { p_code: string }; Returns: Json }
      fixflow_provision_subscription: {
        Args: {
          p_current_period_end?: string
          p_current_period_start?: string
          p_estate_name: string
          p_metadata?: Json
          p_status?: string
          p_stripe_customer_id: string
          p_stripe_price_id: string
          p_stripe_subscription_id: string
          p_user_id: string
        }
        Returns: Json
      }
      fixflow_redeem_invitation_code: {
        Args: {
          p_apartment?: string
          p_building?: string
          p_code: string
          p_floor?: string
          p_info?: string
          p_stairwell?: string
        }
        Returns: Json
      }
      fixflow_reject_join_request: {
        Args: { p_request_id: string }
        Returns: undefined
      }
      fixflow_report_content: {
        Args: {
          p_content_id: string
          p_content_type: Database["public"]["Enums"]["fixflow_content_report_type"]
          p_description?: string
          p_reason: Database["public"]["Enums"]["fixflow_content_report_reason"]
        }
        Returns: Json
      }
      fixflow_send_push_notification: {
        Args: {
          p_body: string
          p_data?: Json
          p_title: string
          p_topic: string
        }
        Returns: undefined
      }
      fixflow_update_subscription_status: {
        Args: {
          p_cancel_at_period_end?: boolean
          p_current_period_end?: string
          p_current_period_start?: string
          p_status: string
          p_stripe_subscription_id: string
        }
        Returns: Json
      }
      mestio_ranking_uchwal: {
        Args: never
        Returns: {
          avg_hours: number
          estate_name: string
          resolved_count: number
        }[]
      }
      newsletter_cleanup: { Args: never; Returns: number }
    }
    Enums: {
      fixflow_building_type: "residential" | "garage"
      fixflow_content_report_reason:
        | "spam"
        | "harassment"
        | "inappropriate"
        | "misinformation"
        | "privacy_violation"
        | "other"
      fixflow_content_report_status:
        | "pending"
        | "reviewed"
        | "action_taken"
        | "dismissed"
      fixflow_content_report_type:
        | "announcement"
        | "report_comment"
        | "emergency_contact"
      fixflow_report_priority: "low" | "normal" | "high" | "critical"
      fixflow_report_status: "new" | "in_progress" | "closed" | "rejected"
    }
    CompositeTypes: {
      [_ in never]: never
    }
  }
}

type DatabaseWithoutInternals = Omit<Database, "__InternalSupabase">

type DefaultSchema = DatabaseWithoutInternals[Extract<keyof Database, "public">]

export type Tables<
  DefaultSchemaTableNameOrOptions extends
    | keyof (DefaultSchema["Tables"] & DefaultSchema["Views"])
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
        DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? (DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"] &
      DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Views"])[TableName] extends {
      Row: infer R
    }
    ? R
    : never
  : DefaultSchemaTableNameOrOptions extends keyof (DefaultSchema["Tables"] &
        DefaultSchema["Views"])
    ? (DefaultSchema["Tables"] &
        DefaultSchema["Views"])[DefaultSchemaTableNameOrOptions] extends {
        Row: infer R
      }
      ? R
      : never
    : never

export type TablesInsert<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Insert: infer I
    }
    ? I
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Insert: infer I
      }
      ? I
      : never
    : never

export type TablesUpdate<
  DefaultSchemaTableNameOrOptions extends
    | keyof DefaultSchema["Tables"]
    | { schema: keyof DatabaseWithoutInternals },
  TableName extends DefaultSchemaTableNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"]
    : never = never,
> = DefaultSchemaTableNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaTableNameOrOptions["schema"]]["Tables"][TableName] extends {
      Update: infer U
    }
    ? U
    : never
  : DefaultSchemaTableNameOrOptions extends keyof DefaultSchema["Tables"]
    ? DefaultSchema["Tables"][DefaultSchemaTableNameOrOptions] extends {
        Update: infer U
      }
      ? U
      : never
    : never

export type Enums<
  DefaultSchemaEnumNameOrOptions extends
    | keyof DefaultSchema["Enums"]
    | { schema: keyof DatabaseWithoutInternals },
  EnumName extends DefaultSchemaEnumNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"]
    : never = never,
> = DefaultSchemaEnumNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[DefaultSchemaEnumNameOrOptions["schema"]]["Enums"][EnumName]
  : DefaultSchemaEnumNameOrOptions extends keyof DefaultSchema["Enums"]
    ? DefaultSchema["Enums"][DefaultSchemaEnumNameOrOptions]
    : never

export type CompositeTypes<
  PublicCompositeTypeNameOrOptions extends
    | keyof DefaultSchema["CompositeTypes"]
    | { schema: keyof DatabaseWithoutInternals },
  CompositeTypeName extends PublicCompositeTypeNameOrOptions extends {
    schema: keyof DatabaseWithoutInternals
  }
    ? keyof DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"]
    : never = never,
> = PublicCompositeTypeNameOrOptions extends {
  schema: keyof DatabaseWithoutInternals
}
  ? DatabaseWithoutInternals[PublicCompositeTypeNameOrOptions["schema"]]["CompositeTypes"][CompositeTypeName]
  : PublicCompositeTypeNameOrOptions extends keyof DefaultSchema["CompositeTypes"]
    ? DefaultSchema["CompositeTypes"][PublicCompositeTypeNameOrOptions]
    : never

export const Constants = {
  public: {
    Enums: {
      fixflow_building_type: ["residential", "garage"],
      fixflow_content_report_reason: [
        "spam",
        "harassment",
        "inappropriate",
        "misinformation",
        "privacy_violation",
        "other",
      ],
      fixflow_content_report_status: [
        "pending",
        "reviewed",
        "action_taken",
        "dismissed",
      ],
      fixflow_content_report_type: [
        "announcement",
        "report_comment",
        "emergency_contact",
      ],
      fixflow_report_priority: ["low", "normal", "high", "critical"],
      fixflow_report_status: ["new", "in_progress", "closed", "rejected"],
    },
  },
} as const
