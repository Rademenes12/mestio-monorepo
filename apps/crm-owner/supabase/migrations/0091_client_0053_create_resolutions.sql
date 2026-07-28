-- Migration: Create resolutions table for voting
-- Run this in Supabase SQL Editor

CREATE TABLE IF NOT EXISTS public.resolutions (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  estate_id uuid NOT NULL REFERENCES public.fixflow_estates(id) ON DELETE CASCADE,
  title text NOT NULL,
  description text,
  deadline timestamptz NOT NULL,
  status text NOT NULL DEFAULT 'open',
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  votes_for integer DEFAULT 0,
  votes_against integer DEFAULT 0,
  votes_abstain integer DEFAULT 0,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.resolutions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "admin_board_all" ON public.resolutions
  FOR ALL
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = resolutions.estate_id
      AND ue.user_id = auth.uid()
      AND ue.role IN ('admin', 'board')
    )
  );

CREATE POLICY "residents_select_active" ON public.resolutions
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates ue
      WHERE ue.estate_id = resolutions.estate_id
      AND ue.user_id = auth.uid()
    )
  );

CREATE INDEX IF NOT EXISTS idx_resolutions_estate ON public.resolutions(estate_id);
CREATE INDEX IF NOT EXISTS idx_resolutions_status ON public.resolutions(status);
