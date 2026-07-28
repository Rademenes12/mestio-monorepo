-- 0016: Dodanie kolumny www_slug do blog_posts (sledzenie publikacji na WWW)
alter table blog_posts add column if not exists www_slug text;
comment on column blog_posts.www_slug is 'Slug pod jakim artykul zostal opublikowany na mestio.pl. NULL = jeszcze nie opublikowany.';
