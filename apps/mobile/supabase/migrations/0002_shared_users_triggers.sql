create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  begin
    insert into public.shared_users (id)
    values (new.id)
    on conflict (id) do nothing;
  exception when others then
    -- Auth is shared by all apps in this Supabase project. A shared profile
    -- bootstrap problem must be visible in logs, but must not block user
    -- creation for every app that depends on auth.users.
    raise warning 'handle_new_user failed for user %: %', new.id, sqlerrm;
  end;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_user();
