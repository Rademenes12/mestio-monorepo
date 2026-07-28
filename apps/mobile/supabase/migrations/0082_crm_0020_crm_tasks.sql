-- Jeśli tabela istnieje z błędną strukturą - usuń ją
drop table if exists crm_tasks;

-- Tasks / To-Do module
create table crm_tasks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  title text not null,
  description text,
  priority text not null default 'medium' check (priority in ('low', 'medium', 'high', 'urgent')),
  status text not null default 'pending' check (status in ('pending', 'in_progress', 'done')),
  due_date timestamp,
  completed_at timestamp,
  created_at timestamp default now(),
  updated_at timestamp default now()
);

alter table crm_tasks enable row level security;

create policy "Users can manage own tasks"
  on crm_tasks for all
  using (auth.uid() = user_id);

create index idx_crm_tasks_user_status on crm_tasks(user_id, status);
create index idx_crm_tasks_due_date on crm_tasks(due_date);
