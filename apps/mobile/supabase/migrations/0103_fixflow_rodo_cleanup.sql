-- ============================================================
-- RODO — automatyczne usuwanie danych osiedla po zakończeniu
-- umowy + okres karencji (90 dni)
-- ============================================================

-- ============================================================
-- 1. Funkcja: czyści dane osiedla, którego umowa wygasła
-- ============================================================
create or replace function public.fixflow_cleanup_expired_estates()
returns int -- liczba usuniętych osiedli
language plpgsql
security definer
as $$
declare
  v_count int := 0;
  v_estate record;
begin
  for v_estate in
    select e.id, e.name
    from fixflow_estates e
    where e.contract_end is not null
      and e.contract_end + interval '90 days' < now()
      and e.status != 'deleted'
  loop
    raise notice 'fixflow_cleanup_expired_estates: cleaning % (%)', v_estate.name, v_estate.id;

    -- Delete storage files for all reports in this estate
    -- (handled separately via fixflow-cleanup for per-user; bulk here)
    delete from storage.objects
    where bucket_id = 'fixflow-report-photos'
      and path_tokens[1] = v_estate.id::text;

    -- Delete report images (FK to reports)
    delete from fixflow_report_images ri
    using fixflow_reports r
    where r.id = ri.report_id and r.estate_id = v_estate.id;

    -- Delete report comments
    delete from fixflow_report_comments rc
    using fixflow_reports r
    where r.id = rc.report_id and r.estate_id = v_estate.id;

    -- Delete reports
    delete from fixflow_reports where estate_id = v_estate.id;

    -- Delete resolutions + votes
    delete from fixflow_resolution_votes rv
    using fixflow_resolutions r
    where r.id = rv.resolution_id and r.estate_id = v_estate.id;

    delete from fixflow_resolutions where estate_id = v_estate.id;

    -- Delete announcements
    delete from fixflow_announcements where estate_id = v_estate.id;

    -- Delete emergency contacts
    delete from fixflow_emergency_contacts where estate_id = v_estate.id;

    -- Delete maintenance schedules
    delete from fixflow_maintenance_schedules where estate_id = v_estate.id;

    -- Delete feedback
    delete from fixflow_feedback where estate_id = v_estate.id;

    -- Delete resident profiles and memberships (but KEEP the auth.users!)
    delete from fixflow_resident_profiles rp
    using fixflow_user_estates ue
    where ue.user_id = rp.id and ue.estate_id = v_estate.id;

    delete from fixflow_user_estates where estate_id = v_estate.id;

    -- Delete estate structure
    delete from estate_tenants et
    using estate_units eu
    where eu.id = et.unit_id and eu.estate_id = v_estate.id;

    delete from estate_units where estate_id = v_estate.id;

    delete from estate_buildings where estate_id = v_estate.id;

    -- Mark estate as deleted
    update fixflow_estates
    set status = 'deleted',
        name = name || ' [USUNIĘTE ' || to_char(now(), 'YYYY-MM-DD') || ']',
        updated_at = now()
    where id = v_estate.id;

    v_count := v_count + 1;
  end loop;

  return v_count;
end;
$$;

comment on function public.fixflow_cleanup_expired_estates() is
  'Czyści osiedla po 90 dniach od zakończenia umowy. Wywoływana codziennie przez pg_cron.';

-- ============================================================
-- 2. Harmonogram — codziennie o 3:00 nad ranem
-- ============================================================
select cron.schedule(
  'fixflow-rodo-cleanup',
  '0 3 * * *',
  $$select public.fixflow_cleanup_expired_estates()$$
);
