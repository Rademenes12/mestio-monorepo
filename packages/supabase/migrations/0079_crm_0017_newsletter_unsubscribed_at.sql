-- 0017: Dodanie kolumny unsubscribed_at do newsletter_subscribers
alter table newsletter_subscribers add column if not exists unsubscribed_at timestamptz;
