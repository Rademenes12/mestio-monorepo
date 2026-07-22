-- Check storage buckets
SELECT id, name, public FROM storage.buckets WHERE name LIKE 'fixflow%';

-- Check storage policies  
SELECT name, definition FROM storage.policies WHERE bucket_id = 'fixflow-report-photos';
