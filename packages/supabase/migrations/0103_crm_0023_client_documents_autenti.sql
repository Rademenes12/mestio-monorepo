-- Dodaje pola do client_documents na potrzeby integracji z Autenti (e-podpis)

alter table if exists client_documents
  add column if not exists autenti_external_id text,
  add column if not exists autenti_link text,
  add column if not exists autenti_status text default 'draft',
  add column if not exists storage_path text;

comment on column client_documents.autenti_external_id is 'ID dokumentu w Autenti API';
comment on column client_documents.autenti_link is 'Link do podpisania dokumentu w Autenti';
comment on column client_documents.autenti_status is 'Status z Autenti: draft/sent/pending/completed/declined';
comment on column client_documents.storage_path is 'Ścieżka do podpisanego PDF w Supabase Storage';
