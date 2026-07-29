import { supabase } from "@/lib/supabase";
import BlogTeaserSectionClient from "./BlogTeaserSectionClient";

async function getLatestPosts(limit: number) {
  const { data } = await supabase
    .from("blog_posts")
    .select("id, title, excerpt, tags, slug")
    .eq("status", "published")
    .order("published_at", { ascending: false })
    .limit(limit);
  return (data || []).map((row: Record<string, unknown>) => ({
    ...row,
    tag: Array.isArray(row.tags) && row.tags.length > 0 ? String(row.tags[0]) : String(row.tag ?? ""),
  }));
}

export default async function BlogTeaserSection() {
  const posts = await getLatestPosts(3);
  return <BlogTeaserSectionClient posts={posts} />;
}
