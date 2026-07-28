-- Newsletter drafts workflow: draft → pending_review → approved → sent
create table newsletter_drafts (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  
  -- Content
  subject text not null,
  html_content text not null,
  ai_topic text, -- original AI topic if generated
  
  -- Workflow status
  status text not null default 'draft' check (status in ('draft', 'pending_review', 'approved', 'sent')),
  plagiarism_score numeric(5,2), -- 0-100 (100 = likely plagiarized)
  plagiarism_report jsonb, -- { checked_at, words_checked, suspicious_phrases: [] }
  
  -- Review metadata
  reviewed_by uuid references auth.users(id) on delete set null,
  review_notes text,
  approved_at timestamp,
  
  -- Send metadata
  sent_at timestamp,
  sent_to_count integer default 0,
  failed_count integer default 0,
  
  created_at timestamp default now(),
  updated_at timestamp default now()
);

-- RLS: users can only see/edit their own drafts
alter table newsletter_drafts enable row level security;

create policy "Users can view own drafts"
  on newsletter_drafts for select
  using (auth.uid() = user_id);

create policy "Users can insert own drafts"
  on newsletter_drafts for insert
  with check (auth.uid() = user_id);

create policy "Users can update own drafts"
  on newsletter_drafts for update
  using (auth.uid() = user_id);

create policy "Admins can review/approve (for now allow all users - TODO: add role check)"
  on newsletter_drafts for update
  using (true);

-- Indexes
create index idx_newsletter_drafts_user_id on newsletter_drafts(user_id);
create index idx_newsletter_drafts_status on newsletter_drafts(status);
create index idx_newsletter_drafts_created_at on newsletter_drafts(created_at desc);
