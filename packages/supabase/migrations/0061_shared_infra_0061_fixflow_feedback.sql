-- Migration: fixflow_feedback table for in-app user feedback
-- Replaces mailto: flow with server-side submission

CREATE TABLE IF NOT EXISTS public.fixflow_feedback (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('bug', 'idea', 'question')),
  message TEXT NOT NULL,
  user_role TEXT,
  user_email TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_fixflow_feedback_created_at
  ON public.fixflow_feedback (created_at DESC);

ALTER TABLE public.fixflow_feedback ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "feedback_insert_own" ON public.fixflow_feedback;
CREATE POLICY "feedback_insert_own" ON public.fixflow_feedback
  FOR INSERT TO authenticated
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "feedback_select_admin" ON public.fixflow_feedback;
CREATE POLICY "feedback_select_admin" ON public.fixflow_feedback
  FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.fixflow_user_estates
      WHERE user_id = auth.uid() AND role IN ('admin', 'board')
    )
  );

GRANT SELECT, INSERT ON public.fixflow_feedback TO authenticated;

ALTER PUBLICATION supabase_realtime ADD TABLE public.fixflow_feedback;
