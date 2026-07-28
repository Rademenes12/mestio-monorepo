-- Migration: Create fixflow_tasks table
-- Run this in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS public.fixflow_tasks (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  status text NOT NULL DEFAULT 'Otwarte',
  priority text DEFAULT 'normal',
  deadline timestamptz,
  assigned_to uuid REFERENCES public.fixflow_resident_profiles(id) ON DELETE SET NULL,
  related_resident_id uuid REFERENCES public.fixflow_resident_profiles(id) ON DELETE SET NULL,
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.fixflow_tasks ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "admin_board_all" ON public.fixflow_tasks;
CREATE POLICY "admin_board_all" ON public.fixflow_tasks
  FOR ALL
  USING (
    auth.uid() IN (
      SELECT user_id FROM public.fixflow_user_estates
      WHERE estate_id = fixflow_tasks.estate_id
      AND role IN ('admin', 'board')
    )
  );

CREATE INDEX IF NOT EXISTS idx_fixflow_tasks_estate ON public.fixflow_tasks(estate_id);
CREATE INDEX IF NOT EXISTS idx_fixflow_tasks_status ON public.fixflow_tasks(status);
CREATE INDEX IF NOT EXISTS idx_fixflow_tasks_deadline ON public.fixflow_tasks(deadline);
CREATE INDEX IF NOT EXISTS idx_fixflow_tasks_related ON public.fixflow_tasks(related_resident_id);
