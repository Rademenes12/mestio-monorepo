const WWW_URL = "https://mestio.pl/api/crm/blog";
const API_KEY = process.env.CRM_BLOG_API_KEY;

export async function callMestioApi(method: "POST" | "PATCH" | "DELETE", body?: Record<string, unknown>, slug?: string) {
  if (!API_KEY) {
    throw new Error("CRM_BLOG_API_KEY not configured");
  }

  const url = slug ? `${WWW_URL}/${encodeURIComponent(slug)}` : WWW_URL;

  const res = await fetch(url, {
    method,
    headers: {
      "x-api-key": API_KEY,
      "Content-Type": "application/json",
    },
    body: body ? JSON.stringify(body) : undefined,
  });

  let data;
  const contentType = res.headers.get("content-type");
  if (contentType?.includes("application/json")) {
    data = await res.json();
  } else {
    const text = await res.text();
    data = { error: `mestio.pl returned ${res.status}: ${text.slice(0, 200)}` };
  }

  if (!res.ok) {
    console.error(`[mestio-api] ${method} ${url}:`, JSON.stringify(data));
  }

  return { status: res.status, data };
}
