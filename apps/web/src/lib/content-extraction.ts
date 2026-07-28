/**
 * Content extraction from URLs for newsletter generation
 * Extracts article text, metadata, and creates clean HTML for newsletters
 */

export interface ExtractedContent {
  title: string;
  content: string;
  html: string;
  source_url: string;
  extracted_at: string;
  content_hash: string;
  source_type: 'blog' | 'news' | 'document' | 'webpage';
}

/**
 * Extract text content from URL using simple fetch and DOM parsing
 * Works in Node.js environment
 */
export async function extractContentFromUrl(url: string): Promise<ExtractedContent> {
  try {
    // Validate URL
    const urlObj = new URL(url);
    const response = await fetch(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      },
    });

    if (!response.ok) {
      throw new Error(`HTTP ${response.status}: ${response.statusText}`);
    }

    const html = await response.text();
    const extracted = parseHtmlContent(html, urlObj.hostname);

    // Generate content hash for deduplication
    const contentHash = generateContentHash(extracted.content);

    return {
      title: extracted.title,
      content: extracted.content,
      html: extracted.html,
      source_url: url,
      extracted_at: new Date().toISOString(),
      content_hash: contentHash,
      source_type: detectSourceType(urlObj.hostname),
    };
  } catch (error) {
    throw new Error(`Failed to extract content from ${url}: ${error instanceof Error ? error.message : 'unknown error'}`);
  }
}

/**
 * Parse HTML and extract main content
 */
function parseHtmlContent(html: string, hostname: string) {
  // Remove script and style elements
  let cleaned = html
    .replace(/<script\b[^<]*(?:(?!<\/script>)<[^<]*)*<\/script>/gi, '')
    .replace(/<style\b[^<]*(?:(?!<\/style>)<[^<]*)*<\/style>/gi, '')
    .replace(/<noscript\b[^<]*(?:(?!<\/noscript>)<[^<]*)*<\/noscript>/gi, '');

  // Extract title
  const titleMatch = cleaned.match(/<title[^>]*>([^<]+)<\/title>/i);
  const title = titleMatch ? titleMatch[1].trim() : 'Newsletter Content';

  // Extract main content - look for article, main, or largest text block
  const mainContentMatch = cleaned.match(
    /<(?:article|main|div[^>]*class="[^"]*(?:content|article|post|entry|body)[^"]*"[^>]*)(?:[^>]*)>(.+?)<\/(?:article|main|div)>/i
  );

  let contentHtml = mainContentMatch ? mainContentMatch[1] : cleaned;

  // Clean up HTML - keep only semantic tags
  contentHtml = cleanHtml(contentHtml);

  // Extract plain text
  const text = extractPlainText(contentHtml);

  // Limit content to ~3000 characters for newsletter
  const limitedContent = text.substring(0, 3000);

  return {
    title,
    content: limitedContent,
    html: contentHtml.substring(0, 5000),
  };
}

/**
 * Clean HTML - keep only semantic tags, remove attributes except href/src
 */
function cleanHtml(html: string): string {
  // Keep only semantic tags
  const allowedTags = ['p', 'div', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6', 'ul', 'ol', 'li', 'strong', 'em', 'a', 'img', 'br'];
  
  let cleaned = html;

  // Remove onclick, onload, javascript: etc
  cleaned = cleaned.replace(/\s*on\w+\s*=\s*["'][^"']*["']/gi, '');
  cleaned = cleaned.replace(/\s*on\w+\s*=\s*\w+/gi, '');
  cleaned = cleaned.replace(/javascript:/gi, '');

  // Remove ads and tracking
  cleaned = cleaned.replace(/<[^>]*(?:ad|tracking|analytics|advertisement)[^>]*>/gi, '');

  // Remove all HTML tags not in allowedTags
  cleaned = cleaned.replace(/<\/?(?!(?:p|div|h[1-6]|ul|ol|li|strong|em|a|img|br)(?:\s|>))[^>]+>/gi, '');

  // Clean up whitespace
  cleaned = cleaned.replace(/\s+/g, ' ').trim();

  return cleaned;
}

/**
 * Extract plain text from HTML
 */
function extractPlainText(html: string): string {
  let text = html;

  // Replace common HTML entities
  text = text.replace(/&nbsp;/gi, ' ');
  text = text.replace(/&lt;/gi, '<');
  text = text.replace(/&gt;/gi, '>');
  text = text.replace(/&amp;/gi, '&');
  text = text.replace(/&quot;/gi, '"');
  text = text.replace(/&#039;/gi, "'");

  // Remove HTML tags
  text = text.replace(/<[^>]*>/g, ' ');

  // Clean up whitespace
  text = text.replace(/\s+/g, ' ').trim();

  return text;
}

/**
 * Generate hash of content for deduplication
 */
function generateContentHash(content: string): string {
  // Simple hash function - in production use crypto.createHash('sha256')
  let hash = 0;
  for (let i = 0; i < content.length; i++) {
    const char = content.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash = hash & hash;
  }
  return Math.abs(hash).toString(16);
}

/**
 * Detect source type from hostname
 */
function detectSourceType(hostname: string): 'blog' | 'news' | 'document' | 'webpage' {
  const lower = hostname.toLowerCase();

  if (lower.includes('blog') || lower.includes('medium') || lower.includes('wordpress')) {
    return 'blog';
  }
  if (lower.includes('news') || lower.includes('bbc') || lower.includes('cnn') || lower.includes('nyt')) {
    return 'news';
  }
  if (lower.includes('pdf') || lower.includes('doc')) {
    return 'document';
  }

  return 'webpage';
}

/**
 * Convert extracted content to newsletter-ready HTML
 */
export function convertToNewsletterHtml(extracted: ExtractedContent, recipientCount: number): {
  subject: string;
  html: string;
} {
  const subject = `${extracted.title} - Mestio Newsletter`;

  const html = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="margin: 0; padding: 0; font-family: Arial, sans-serif; background-color: #f5f5f5;">
  <div style="max-width: 600px; margin: 0 auto; background-color: white; padding: 40px; line-height: 1.6; color: #333;">
    
    <!-- Header -->
    <div style="text-align: center; margin-bottom: 30px; border-bottom: 2px solid #0066cc; padding-bottom: 20px;">
      <h1 style="margin: 0; color: #0066cc; font-size: 24px;">Mestio Newsletter</h1>
      <p style="margin: 5px 0 0 0; color: #666; font-size: 12px;">Zarządzanie osiedlami i nieruchomościami</p>
    </div>

    <!-- Main Content -->
    <div style="margin-bottom: 30px;">
      <h2 style="color: #0066cc; margin-top: 0;">${extracted.title}</h2>
      <p style="color: #666; font-size: 12px; margin: 0 0 20px 0;">Źródło: <a href="${extracted.source_url}" style="color: #0066cc; text-decoration: none;">${new URL(extracted.source_url).hostname}</a></p>
      <div style="line-height: 1.8;">
        ${extracted.html}
      </div>
    </div>

    <!-- CTA -->
    <div style="background-color: #f0f0f0; padding: 20px; border-radius: 8px; text-align: center; margin-bottom: 30px;">
      <p style="margin: 0 0 15px 0; font-size: 14px;">Chcesz dowiedzieć się więcej?</p>
      <a href="${extracted.source_url}" style="display: inline-block; background-color: #0066cc; color: white; padding: 12px 30px; text-decoration: none; border-radius: 5px; font-weight: bold;">Przeczytaj więcej</a>
    </div>

    <!-- Footer -->
    <div style="border-top: 1px solid #ddd; padding-top: 20px; text-align: center; color: #666; font-size: 11px;">
      <p style="margin: 0 0 10px 0;">Mestio - Zarządzanie Osiedlami</p>
      <p style="margin: 0;">
        <a href="https://mestio.pl" style="color: #0066cc; text-decoration: none;">Strona główna</a> | 
        <a href="https://mestio.pl/kontakt" style="color: #0066cc; text-decoration: none;">Kontakt</a> | 
        <a href="https://mestio.pl/newsletter/unsubscribe" style="color: #0066cc; text-decoration: none;">Wypisz się</a>
      </p>
      <p style="margin: 10px 0 0 0; font-size: 10px; color: #999;">
        Ten newsletter został wysłany do ${recipientCount} odbiorców z Mestio.
      </p>
    </div>

  </div>
</body>
</html>
  `.trim();

  return { subject, html };
}
