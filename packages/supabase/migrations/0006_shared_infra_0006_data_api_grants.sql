grant select, insert, update
on table public.shared_users
to authenticated;

grant select, insert, update
on table public.shared_user_apps
to authenticated;

revoke execute
on function public.handle_new_user()
from anon, authenticated, service_role, public;
