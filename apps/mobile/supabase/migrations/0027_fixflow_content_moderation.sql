-- =====================================================
-- Migration: Content Moderation System
-- Description: User-generated content reporting mechanism
--              Required for App Store & Google Play compliance
-- =====================================================

-- Create updated_at helper function if not exists
create or replace function shared_update_updated_at_column()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

-- Content report types enum
create type fixflow_content_report_type as enum (
  'announcement',
  'report_comment',
  'emergency_contact'
);

-- Content report reasons enum
create type fixflow_content_report_reason as enum (
  'spam',
  'harassment',
  'inappropriate',
  'misinformation',
  'privacy_violation',
  'other'
);

-- Content report status enum
create type fixflow_content_report_status as enum (
  'pending',
  'reviewed',
  'action_taken',
  'dismissed'
);

-- Content reports table
create table if not exists fixflow_content_reports (
  id uuid primary key default gen_random_uuid(),
  
  -- Reporter info
  reporter_id uuid not null references auth.users(id) on delete cascade,
  
  -- Content being reported
  content_type fixflow_content_report_type not null,
  content_id uuid not null,
  
  -- Report details
  reason fixflow_content_report_reason not null,
  description text,
  
  -- Moderation status
  status fixflow_content_report_status not null default 'pending',
  reviewed_at timestamptz,
  reviewed_by uuid references auth.users(id) on delete set null,
  moderator_notes text,
  
  -- Metadata
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  
  -- Prevent duplicate reports from same user for same content
  unique(reporter_id, content_type, content_id)
);

-- Indexes
create index idx_fixflow_content_reports_reporter on fixflow_content_reports(reporter_id);
create index idx_fixflow_content_reports_content on fixflow_content_reports(content_type, content_id);
create index idx_fixflow_content_reports_status on fixflow_content_reports(status);
create index idx_fixflow_content_reports_created on fixflow_content_reports(created_at desc);

-- Updated_at trigger
create trigger set_fixflow_content_reports_updated_at
  before update on fixflow_content_reports
  for each row
  execute function shared_update_updated_at_column();

-- RLS: Enable
alter table fixflow_content_reports enable row level security;

-- RLS: Users can view their own reports
create policy "Users can view own reports"
  on fixflow_content_reports
  for select
  using (auth.uid() = reporter_id);

-- RLS: Users can create reports (rate limited by function)
create policy "Users can create reports"
  on fixflow_content_reports
  for insert
  with check (auth.uid() = reporter_id);

-- RLS: Only managers/admins can update/review reports
create policy "Managers can review reports"
  on fixflow_content_reports
  for update
  using (
    exists (
      select 1 from fixflow_user_estates
      where user_id = auth.uid()
        and role in ('manager', 'admin')
    )
  );

-- =====================================================
-- RPC Function: Report Content with Rate Limiting
-- =====================================================

create or replace function fixflow_report_content(
  p_content_type fixflow_content_report_type,
  p_content_id uuid,
  p_reason fixflow_content_report_reason,
  p_description text default null
)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user_id uuid;
  v_report_count integer;
  v_report_id uuid;
begin
  -- Get authenticated user
  v_user_id := auth.uid();
  
  if v_user_id is null then
    return jsonb_build_object(
      'success', false,
      'error', 'unauthenticated'
    );
  end if;
  
  -- Rate limiting: max 5 reports per user per 24 hours
  select count(*)
  into v_report_count
  from fixflow_content_reports
  where reporter_id = v_user_id
    and created_at > now() - interval '24 hours';
  
  if v_report_count >= 5 then
    return jsonb_build_object(
      'success', false,
      'error', 'rate_limit_exceeded'
    );
  end if;
  
  -- Validate content exists based on type
  case p_content_type
    when 'announcement' then
      if not exists (select 1 from fixflow_announcements where id = p_content_id) then
        return jsonb_build_object(
          'success', false,
          'error', 'content_not_found'
        );
      end if;
    
    when 'report_comment' then
      if not exists (select 1 from fixflow_report_comments where id = p_content_id) then
        return jsonb_build_object(
          'success', false,
          'error', 'content_not_found'
        );
      end if;
    
    when 'emergency_contact' then
      if not exists (select 1 from fixflow_emergency_contacts where id = p_content_id) then
        return jsonb_build_object(
          'success', false,
          'error', 'content_not_found'
        );
      end if;
  end case;
  
  -- Insert report (or return existing if duplicate)
  insert into fixflow_content_reports (
    reporter_id,
    content_type,
    content_id,
    reason,
    description,
    status
  )
  values (
    v_user_id,
    p_content_type,
    p_content_id,
    p_reason,
    p_description,
    'pending'
  )
  on conflict (reporter_id, content_type, content_id)
  do nothing
  returning id into v_report_id;
  
  -- Check if this was a duplicate
  if v_report_id is null then
    return jsonb_build_object(
      'success', false,
      'error', 'already_reported'
    );
  end if;
  
  return jsonb_build_object(
    'success', true,
    'report_id', v_report_id
  );
end;
$$;

-- Grant execute to authenticated users
grant execute on function fixflow_report_content to authenticated;

-- =====================================================
-- Comments
-- =====================================================

comment on table fixflow_content_reports is 
  'User-generated content reports for moderation (App Store/Google Play compliance)';

comment on column fixflow_content_reports.reporter_id is 
  'User who submitted the report';

comment on column fixflow_content_reports.content_type is 
  'Type of content being reported';

comment on column fixflow_content_reports.content_id is 
  'UUID of the reported content item';

comment on column fixflow_content_reports.reason is 
  'Predefined reason category for the report';

comment on column fixflow_content_reports.description is 
  'Optional detailed description from reporter';

comment on column fixflow_content_reports.status is 
  'Moderation workflow status';

comment on function fixflow_report_content is 
  'Submit content report with rate limiting (max 5 reports/24h per user)';
