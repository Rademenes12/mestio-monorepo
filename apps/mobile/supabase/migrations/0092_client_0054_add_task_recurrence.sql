-- Migration: Add recurrence fields to fixflow_tasks
-- Run in Supabase SQL Editor

ALTER TABLE public.fixflow_tasks ADD COLUMN IF NOT EXISTS is_recurring boolean DEFAULT false;
ALTER TABLE public.fixflow_tasks ADD COLUMN IF NOT EXISTS recurrence_interval integer;
ALTER TABLE public.fixflow_tasks ADD COLUMN IF NOT EXISTS recurrence_unit text;
ALTER TABLE public.fixflow_tasks ADD COLUMN IF NOT EXISTS recurrence_end_date timestamptz;
