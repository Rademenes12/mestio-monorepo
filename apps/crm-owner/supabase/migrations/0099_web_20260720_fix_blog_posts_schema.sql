-- Dodanie brakujących kolumn do blog_posts (zgodnie z API /api/crm/blog)
ALTER TABLE public.blog_posts
  ADD COLUMN IF NOT EXISTS content TEXT,
  ADD COLUMN IF NOT EXISTS author_name TEXT,
  ADD COLUMN IF NOT EXISTS tags TEXT[] DEFAULT '{}',
  ADD COLUMN IF NOT EXISTS cover_image TEXT;

-- Przekopiuj istniejące dane z body -> content, cover_url -> cover_image
UPDATE public.blog_posts
SET 
  content = COALESCE(content, body),
  cover_image = COALESCE(cover_image, cover_url);
