-- 0019: Complete Newsletter Approval Workflow with Multi-Step Review
-- Tables: approval_logs, newsletter_send_stats, content_extraction_cache

-- 1. APPROVAL LOGS - Track who approved what and when
create table if not exists approval_logs (
  id uuid default gen_random_uuid() primary key,
  draft_id uuid not null references newsletter_drafts(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  
  -- Action type
  action text not null check (action in ('submitted_for_review', 'reviewed_and_approved', 'reviewed_and_rejected', 'sent')),
  
  -- Review details
  review_notes text,
  approval_required_by text, -- email of required approver
  
  -- Security checks performed
  plagiarism_checked boolean default false,
  plagiarism_score numeric(5,2),
  phishing_checked boolean default false,
  phishing_risk_level text, -- 'none', 'low', 'medium', 'high'
  ai_content_checked boolean default false,
  ai_probability numeric(5,2),
  
  created_at timestamp default now(),
  created_by uuid references auth.users(id) on delete set null
);

-- 2. DAILY SEND STATS - Track sends per day (rate limiting)
create table if not exists newsletter_send_stats (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  
  send_date date default current_date,
  emails_sent integer default 0,
  emails_failed integer default 0,
  bounces integer default 0,
  complaints integer default 0,
  unsubscribes integer default 0,
  
  constraint daily_user_unique unique(user_id, send_date)
);

-- 3. CONTENT EXTRACTION CACHE - Cache extracted content from URLs
create table if not exists content_extraction_cache (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  
  source_url text not null,
  extracted_title text,
  extracted_content text,
  extracted_html text,
  
  -- Metadata
  source_type text, -- 'blog', 'news', 'document', 'webpage'
  content_hash text, -- SHA256 of extracted content for deduplication
  
  created_at timestamp default now(),
  expires_at timestamp default (now() + interval '7 days'),
  
  constraint cache_url_user_unique unique(user_id, source_url)
);

-- 4. UPDATE newsletter_drafts - Add missing fields for approval workflow
alter table newsletter_drafts 
  add column if not exists ai_generated_probability numeric(5,2),
  add column if not exists phishing_risk_level text default 'none' check (phishing_risk_level in ('none', 'low', 'medium', 'high')),
  add column if not exists approval_required boolean default false,
  add column if not exists soft_deleted boolean default false,
  add column if not exists deleted_by uuid references auth.users(id) on delete set null,
  add column if not exists deleted_at timestamp,
  add column if not exists extracted_from_url text; -- URL it was extracted from

-- 5. RLS POLICIES
alter table approval_logs enable row level security;
alter table newsletter_send_stats enable row level security;
alter table content_extraction_cache enable row level security;

create policy "Users can view approval logs for their drafts"
  on approval_logs for select
  using (
    draft_id in (
      select id from newsletter_drafts 
      where user_id = auth.uid()
    )
  );

create policy "Users can view own send stats"
  on newsletter_send_stats for select
  using (auth.uid() = user_id);

create policy "Users can insert own send stats"
  on newsletter_send_stats for insert
  with check (auth.uid() = user_id);

create policy "Users can update own send stats"
  on newsletter_send_stats for update
  using (auth.uid() = user_id);

create policy "Users can view own extraction cache"
  on content_extraction_cache for select
  using (auth.uid() = user_id);

create policy "Users can insert own extraction cache"
  on content_extraction_cache for insert
  with check (auth.uid() = user_id);

create policy "Users can delete expired cache"
  on content_extraction_cache for delete
  using (auth.uid() = user_id);

-- 6. INDEXES for performance
create index if not exists idx_approval_logs_draft_id on approval_logs(draft_id);
create index if not exists idx_approval_logs_user_id on approval_logs(user_id);
create index if not exists idx_approval_logs_created_at on approval_logs(created_at desc);
create index if not exists idx_send_stats_user_date on newsletter_send_stats(user_id, send_date);
create index if not exists idx_extraction_cache_url_hash on content_extraction_cache(content_hash);
create index if not exists idx_extraction_cache_expires on content_extraction_cache(expires_at);

-- 7. CLEANUP: Remove expired cache entries (should run as a cron job)
-- For now, manually: delete from content_extraction_cache where expires_at < now();
