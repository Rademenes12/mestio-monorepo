"use client";
/* eslint-disable react-hooks/set-state-in-effect */

import { useEffect, useRef, useState } from "react";
import { createClient } from "@/lib/supabase/client";

function tint(hex: string, a: number): string {
  const n = parseInt(hex.slice(1), 16);
  return `rgba(${(n >> 16) & 255},${(n >> 8) & 255},${n & 255},${a})`;
}

interface BlogPost {
  id: string;
  title: string;
  slug: string;
  status: string;
  category: string | null;
  cover_url: string | null;
  created_at: string;
}

const COVERS = [
  "from-azure to-blueprint",
  "from-amber to-[#C98800]",
  "from-success to-blueprint",
];

const STATUS_META: Record<string, { label: string; color: string }> = {
  published: { label: "Opublikowany", color: "#2E9E6B" },
  draft: { label: "Szkic", color: "#6B7A90" },
  scheduled: { label: "Zaplanowany", color: "#F2A900" },
};

export default function BlogPage() {
  const [posts, setPosts] = useState<BlogPost[]>([]);
  const [loading, setLoading] = useState(true);
  const [showEditor, setShowEditor] = useState(false);
  const [editingId, setEditingId] = useState<string | null>(null);
  const [form, setForm] = useState({
    title: "", slug: "", body: "", excerpt: "", category: "", status: "draft", cover_url: "",
  });
  const [saving, setSaving] = useState(false);
  const [publishingWww, setPublishingWww] = useState<string | null>(null);
  const [message, setMessage] = useState<string | null>(null);
  const [toast, setToast] = useState<string | null>(null);
  const [uploading, setUploading] = useState(false);
  const bodyRef = useRef<HTMLTextAreaElement>(null);
  const coverInputRef = useRef<HTMLInputElement>(null);
  const supabase = createClient();

  const notify = (m: string) => {
    setToast(m);
    setTimeout(() => setToast(null), 2800);
  };

  const fetchPosts = async () => {
    setLoading(true);
    const { data } = await supabase
      .from("blog_posts")
      .select("*")
      .order("created_at", { ascending: false });
    setPosts((data as BlogPost[]) ?? []);
    setLoading(false);
  };

   
  useEffect(() => {
    void fetchPosts();
    // Otwórz edytor gdy przyszliśmy z przycisku "+ Nowy artykuł" (?new=1)
    if (new URLSearchParams(window.location.search).get("new") === "1") {
      setShowEditor(true);
    }
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  const generateSlug = (t: string) =>
    t.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");

  const startNew = () => {
    setEditingId(null);
    setForm({ title: "", slug: "", body: "", excerpt: "", category: "", status: "draft", cover_url: "" });
    setShowEditor(true);
    setMessage(null);
  };

  const startEdit = async (id: string) => {
    const { data } = await supabase.from("blog_posts").select("*").eq("id", id).single();
    if (!data) return;
    setEditingId(id);
    setForm({
      title: data.title ?? "",
      slug: data.slug ?? "",
      body: data.body ?? "",
      excerpt: data.excerpt ?? "",
      category: data.category ?? "",
      status: data.status ?? "draft",
      cover_url: data.cover_url ?? "",
    });
    setShowEditor(true);
    setMessage(null);
  };

  const handleSave = async () => {
    if (!form.title.trim()) return;
    setSaving(true);
    setMessage(null);
    const slug = form.slug.trim() || generateSlug(form.title);
    const payload = {
      title: form.title,
      slug,
      body: form.body || "<p></p>",
      excerpt: form.excerpt || null,
      category: form.category || null,
      status: form.status,
      cover_url: form.cover_url || null,
    };

    const { error } = editingId
      ? await supabase.from("blog_posts").update({ ...payload, updated_at: new Date().toISOString() }).eq("id", editingId)
      : await supabase.from("blog_posts").insert(payload);

    if (error) {
      // Blad zostaje widoczny wewnatrz otwartego edytora, zeby uzytkownik mogl poprawic i sprobowac ponownie.
      setMessage(`Błąd: ${error.message}`);
    } else {
      notify(editingId ? "Zaktualizowano artykuł" : "Zapisano artykuł");
    setForm({ title: "", slug: "", body: "", excerpt: "", category: "", status: "draft", cover_url: "" });
      setEditingId(null);
      setShowEditor(false);
      fetchPosts();
    }
    setSaving(false);
  };

  const handlePublish = async (id: string) => {
    const { error } = await supabase
      .from("blog_posts")
      .update({ status: "published", published_at: new Date().toISOString() })
      .eq("id", id);
    if (error) {
      notify("Błąd publikacji: " + error.message);
      return;
    }
    notify("Artykuł opublikowany");
    fetchPosts();
  };

  const handleDelete = async (id: string, title: string, slug: string) => {
    if (!confirm(`Na pewno usunąć artykuł "${title}"?\n\nZostanie też usunięty ze strony mestio.pl.`)) return;

    const { error } = await supabase.from("blog_posts").delete().eq("id", id);
    if (error) {
      notify("Błąd usuwania: " + error.message);
      return;
    }

    fetch("/api/publish-blog/" + encodeURIComponent(slug), { method: "DELETE" })
      .catch(() => {});

    notify("Artykuł usunięty");
    fetchPosts();
  };

  const uploadImage = async (file: File): Promise<string | null> => {
    setUploading(true);
    try {
      const formData = new FormData();
      formData.append("file", file);
      const res = await fetch("/api/upload-blog-image", { method: "POST", body: formData });
      const data = await res.json();
      if (!res.ok) {
        notify("Błąd uploadu: " + (data.error || res.status));
        return null;
      }
      return data.url;
    } catch {
      notify("Błąd uploadu grafiki");
      return null;
    } finally {
      setUploading(false);
    }
  };

  const uploadAndSetCover = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const url = await uploadImage(file);
    if (url) setForm(f => ({ ...f, cover_url: url }));
    e.target.value = "";
  };

  const uploadAndInsertToBody = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    const url = await uploadImage(file);
    if (url) {
      const imgTag = `<img src="${url}" alt="" />`;
      const ta = bodyRef.current;
      if (ta) {
        const start = ta.selectionStart;
        const end = ta.selectionEnd;
        const before = form.body.slice(0, start);
        const after = form.body.slice(end);
        setForm(f => ({ ...f, body: before + imgTag + after }));
        setTimeout(() => {
          ta.focus();
          ta.setSelectionRange(start + imgTag.length, start + imgTag.length);
        }, 50);
      } else {
        setForm(f => ({ ...f, body: f.body + imgTag }));
      }
    }
    e.target.value = "";
  };

  const publishToWww = async (post: BlogPost) => {
    setPublishingWww(post.id);

    const { data: full } = await supabase
      .from("blog_posts")
      .select("*")
      .eq("id", post.id)
      .single();

    if (!full) {
      notify("Błąd: nie znaleziono artykułu");
      setPublishingWww(null);
      return;
    }

    const excerpt = full.excerpt && full.excerpt.length >= 10
      ? full.excerpt
      : (full.body || full.title || "").slice(0, 150).replace(/<[^>]*>/g, "").trim() || "Artykuł na blogu Mestio";

    const res = await fetch("/api/publish-blog", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        title: full.title,
        slug: full.slug,
        content: full.body,
        excerpt,
        cover_image: full.cover_url || undefined,
        author_name: "Mestio",
        published_at: full.published_at || undefined,
        tags: full.category ? [full.category] : undefined,
        status: "published",
      }),
    });

    setPublishingWww(null);

    if (res.status === 201) {
      notify("Opublikowano na stronie WWW!");
      await supabase.from("blog_posts").update({ www_slug: full.slug }).eq("id", post.id);
    } else if (res.status === 409) {
      const patchRes = await fetch("/api/publish-blog/" + encodeURIComponent(full.slug), {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          title: full.title,
          content: full.body,
          excerpt,
          cover_image: full.cover_url || undefined,
          tags: full.category ? [full.category] : undefined,
          status: "published",
        }),
      });

      if (patchRes.ok) {
        notify("Zaktualizowano na stronie WWW!");
        await supabase.from("blog_posts").update({ www_slug: full.slug }).eq("id", post.id);
      } else {
        const data = await patchRes.json();
        notify(`Błąd aktualizacji na WWW (${patchRes.status}): ${data?.error || JSON.stringify(data)}`);
      }
    } else {
      const data = await res.json();
      console.error("[publish-blog] Error response:", data);
      notify(`Błąd publikacji na WWW (${res.status}): ${data?.error || data?.details || JSON.stringify(data)}`);
    }
  };

  return (
    <div className="max-w-5xl mx-auto space-y-4">
      {showEditor && (
        <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-6 space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-[6px] block">Tytuł</label>
              <input value={form.title} onChange={(e) => setForm({ ...form, title: e.target.value, slug: generateSlug(e.target.value) })} className="w-full text-[13.5px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all" />
            </div>
            <div>
              <label className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-[6px] block">Slug</label>
              <input value={form.slug} onChange={(e) => setForm({ ...form, slug: e.target.value })} className="w-full text-[13.5px] font-[family-name:var(--font-mono)] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all" />
            </div>
          </div>
          <div className="grid grid-cols-3 gap-4">
            <div>
              <label className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-[6px] block">Kategoria</label>
              <input value={form.category} onChange={(e) => setForm({ ...form, category: e.target.value })} className="w-full text-[13.5px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all" />
            </div>
            <div>
              <label className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-[6px] block">Meta description</label>
              <input value={form.excerpt} onChange={(e) => setForm({ ...form, excerpt: e.target.value })} className="w-full text-[13.5px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all" />
            </div>
            <div>
              <label className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-[6px] block">Status</label>
              <select value={form.status} onChange={(e) => setForm({ ...form, status: e.target.value })} className="w-full text-[13.5px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all">
                <option value="draft">Szkic</option>
                <option value="published">Opublikowany</option>
                <option value="scheduled">Zaplanowany</option>
              </select>
            </div>
          </div>
          <div>
            <label className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] mb-[6px] block">URL okładki (obrazek)</label>
            <div className="flex gap-2">
              <input value={form.cover_url} onChange={(e) => setForm({ ...form, cover_url: e.target.value })} placeholder="https://example.com/obrazek.jpg" className="flex-1 text-[13.5px] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all" />
              <input type="file" accept="image/*" ref={coverInputRef} onChange={uploadAndSetCover} className="hidden" />
              <button type="button" onClick={() => coverInputRef.current?.click()} disabled={uploading} className="px-4 py-[12px] rounded-[11px] bg-[#F4F7FB] text-[12px] font-semibold text-azure hover:bg-[#EAEFF5] transition-colors disabled:opacity-50 shrink-0">
                {uploading ? "..." : "Wybierz"}
              </button>
            </div>
            {form.cover_url && (
              <img src={form.cover_url} alt="" className="mt-2 h-20 rounded-[8px] object-cover" />
            )}
          </div>
           <div>
             <div className="flex items-center justify-between mb-[6px]">
               <label className="font-[family-name:var(--font-mono)] text-[10px] tracking-[.5px] uppercase text-[#8A98AB] block">Treść (HTML)</label>
               <div className="flex gap-2 items-center">
                 <input type="file" accept="image/*" id="body-img-upload" onChange={uploadAndInsertToBody} className="hidden" />
                 <button type="button" onClick={() => document.getElementById("body-img-upload")?.click()} disabled={uploading} className="px-3 py-[6px] rounded-[8px] bg-blue-50 hover:bg-blue-100 text-[12px] font-semibold text-blue-600 transition-colors disabled:opacity-50 flex items-center gap-1">
                   {uploading ? "⏳ Przesyłanie..." : "🖼️ Wstaw obrazek"}
                 </button>
               </div>
             </div>
             <textarea ref={bodyRef} value={form.body} onChange={(e) => setForm({ ...form, body: e.target.value })} rows={6} className="w-full text-[13px] font-[family-name:var(--font-mono)] bg-[#F4F7FB] rounded-[11px] px-[14px] py-[12px] text-ink outline-none focus:ring-2 focus:ring-azure/30 transition-all resize-y leading-relaxed" />
           </div>
          {message && (
            <div className="bg-danger/5 text-danger text-[13.5px] px-[16px] py-[12px] rounded-[11px] border border-danger/20 leading-relaxed">
              {message}
            </div>
          )}
          <div className="flex items-center gap-[10px]">
            <button onClick={handleSave} disabled={saving} className="px-7 py-[13px] bg-gradient-to-br from-azure to-blueprint text-white font-semibold text-[13.5px] rounded-[11px] hover:brightness-105 active:scale-[0.98] transition-all disabled:opacity-50">
              {saving ? "Zapisywanie..." : "Zapisz artykuł"}
            </button>
            <button onClick={() => setShowEditor(false)} disabled={saving} className="px-6 py-[13px] bg-[#F4F7FB] text-[#5A6B80] font-semibold text-[13.5px] rounded-[11px] hover:bg-[#EAEFF5] transition-colors disabled:opacity-50">
              Anuluj
            </button>
          </div>
        </div>
      )}

      <div className="flex flex-col gap-3">
        {loading ? (
          <div className="flex flex-col gap-3 animate-pulse">
            {[0, 1, 2].map((i) => (
              <div key={i} className="h-[86px] bg-white rounded-[18px] shadow-[var(--shadow-card)]" />
            ))}
          </div>
        ) : posts.length === 0 ? (
          <div className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-[30px] text-center text-[#9AA7B8] text-[13.5px]">
            Brak artykułów.{" "}
            <button onClick={startNew} className="text-azure font-semibold hover:underline">
              Napisz pierwszy artykuł →
            </button>
          </div>
        ) : (
          posts.map((b, i) => {
            const meta = STATUS_META[b.status] ?? STATUS_META.draft;
            return (
              <div key={b.id} className="bg-white rounded-[18px] shadow-[var(--shadow-card)] p-[18px] px-5 flex items-center gap-4">
                <div className={`w-20 h-14 rounded-[10px] bg-gradient-to-br ${COVERS[i % COVERS.length]} shrink-0`} />
                <div className="flex-1 min-w-0">
                  <div className="font-[family-name:var(--font-heading)] font-semibold text-[15px] text-ink">{b.title}</div>
                  <div className="text-[12.5px] text-[#7C8AA0] mt-[3px]">{b.category ?? "—"} · {new Date(b.created_at).toLocaleDateString("pl-PL")}</div>
                </div>
                <span className="font-[family-name:var(--font-mono)] text-[10px] font-semibold px-[9px] py-[3px] rounded-full shrink-0" style={{ background: tint(meta.color, 0.13), color: meta.color }}>{meta.label}</span>
                <div className="flex gap-[8px] shrink-0">
                   <button onClick={() => startEdit(b.id)} className="px-[13px] py-[8px] rounded-[9px] bg-blue-50 hover:bg-blue-100 text-[12.5px] font-semibold text-blue-600 transition-colors flex items-center gap-1">✏️ Edytuj</button>
                  {b.status !== "published" && (
                    <button onClick={() => handlePublish(b.id)} className="px-[13px] py-[8px] rounded-[9px] bg-success text-[12.5px] font-semibold text-white hover:brightness-105 transition-all">Publikuj</button>
                  )}
                  {b.status === "published" && (
                    <button onClick={() => publishToWww(b)} disabled={publishingWww === b.id} className="px-[13px] py-[8px] rounded-[9px] bg-blueprint text-[12.5px] font-semibold text-white hover:brightness-110 transition-all disabled:opacity-50">
                      {publishingWww === b.id ? "Publikowanie..." : "Opublikuj na stronie"}
                    </button>
                  )}
                  <button onClick={() => handleDelete(b.id, b.title, b.slug)} className="px-[13px] py-[8px] rounded-[9px] bg-danger/10 text-[12.5px] font-semibold text-danger hover:bg-danger/20 transition-colors">Usuń</button>
                </div>
              </div>
            );
          })
        )}
      </div>

      {toast && (
        <div className="fixed left-1/2 bottom-6 -translate-x-1/2 bg-ink text-white text-[12.5px] font-medium px-5 py-3 rounded-full shadow-[0_10px_30px_rgba(14,26,43,.4)] z-50 max-w-[90vw]">
          {toast}
        </div>
      )}
    </div>
  );
}
