/**
 * Unsplash API integration for real estate newsletter images
 * Auto-replaces [IMAGE: description] with real URLs
 */

export interface UnsplashPhoto {
  id: string;
  urls: {
    small: string;
    regular: string;
    full: string;
  };
  user: {
    name: string;
  };
  links: {
    html: string;
  };
}

const UNSPLASH_API_URL = "https://api.unsplash.com";
const ACCESS_KEY = process.env.NEXT_PUBLIC_UNSPLASH_ACCESS_KEY;

export async function searchUnsplashPhotos(query: string, count: number = 1): Promise<UnsplashPhoto[]> {
  if (!ACCESS_KEY) {
    console.warn("Unsplash API key not configured, using placeholder images");
    return [];
  }

  try {
    const response = await fetch(
      `${UNSPLASH_API_URL}/search/photos?query=${encodeURIComponent(query)}&per_page=${count}&order_by=relevant`,
      {
        headers: {
          Authorization: `Client-ID ${ACCESS_KEY}`,
        },
      }
    );

    if (!response.ok) {
      console.error("Unsplash API error:", response.status);
      return [];
    }

    const data = await response.json() as { results: UnsplashPhoto[] };
    return data.results || [];
  } catch (error) {
    console.error("Unsplash fetch error:", error);
    return [];
  }
}

/**
 * Replace [IMAGE: description] placeholders with real Unsplash URLs
 */
export async function replaceImagePlaceholders(html: string): Promise<string> {
  const imageRegex = /\[IMAGE:\s*([^\]]+)\]/gi;
  const matches = Array.from(html.matchAll(imageRegex));

  let result = html;
  for (const match of matches) {
    const description = match[1].trim();
    const photos = await searchUnsplashPhotos(description, 1);

    if (photos.length > 0) {
      const photo = photos[0];
      const imageHtml = `
        <div style="margin: 20px 0; text-align: center;">
          <img src="${photo.urls.regular}" alt="${description}" style="max-width: 100%; height: auto; border-radius: 8px; margin: 0 auto; display: block;">
          <p style="font-size: 11px; color: #999; margin-top: 8px;">
            Fot. <a href="${photo.links.html}?utm_source=mestio&utm_medium=newsletter" style="color: #999; text-decoration: none;">${photo.user.name}</a> / Unsplash
          </p>
        </div>
      `;
      result = result.replace(match[0], imageHtml);
    } else {
      // Fallback: solid color placeholder
      const placeholderHtml = `
        <div style="margin: 20px 0; text-align: center; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 60px; border-radius: 8px; color: white;">
          <p style="margin: 0; font-size: 14px; font-weight: bold;">📸 ${description}</p>
          <p style="margin: 5px 0 0 0; font-size: 12px; opacity: 0.8;">(Brak zdjęcia na Unsplash)</p>
        </div>
      `;
      result = result.replace(match[0], placeholderHtml);
    }
  }

  return result;
}
