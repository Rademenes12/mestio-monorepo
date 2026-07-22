/**
 * Input sanitization utilities for the Mestio monorepo.
 * Provides HTML stripping, SQL injection prevention, email/URL validation,
 * and HTML attribute escaping.
 */

/** Strip all HTML tags from a string, returning plain text. */
export function sanitizeHtml(str: string): string {
  if (!str) return "";
  return str
    .replace(/<[^>]*>/g, "")
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&amp;/g, "&")
    .replace(/&quot;/g, '"')
    .replace(/&#x27;/g, "'")
    .replace(/&#x2F;/g, "/")
    .trim();
}

/** SQL injection pattern signatures to detect and strip. */
const SQL_INJECTION_PATTERNS = [
  /(\bUNION\b.*\bSELECT\b)/i,
  /(\bSELECT\b.*\bFROM\b)/i,
  /(\bINSERT\b\s+\bINTO\b)/i,
  /(\bUPDATE\b\s+\w+\s+\bSET\b)/i,
  /(\bDELETE\b\s+\bFROM\b)/i,
  /(\bDROP\b\s+(TABLE|DATABASE|INDEX|VIEW))/i,
  /(\bALTER\b\s+(TABLE|DATABASE))/i,
  /(\bEXEC\b\s*\(|xp_cmdshell)/i,
  /(\bOR\b\s+\d+\s*=\s*\d+)/i,
  /(';\s*--)/,
  /(\/\*.*\*\/)/,
  /(\\x[0-9a-fA-F]{2})/,
  /(\bSLEEP\s*\(|BENCHMARK\s*\()/i,
  /(\bINFORMATION_SCHEMA\b)/i,
];

/** Strip known SQL injection patterns from a string.
 *  Returns the sanitized string with injection patterns removed.
 *  Note: this is a defense-in-depth measure; parameterized queries
 *  should always be the primary defense. */
export function sanitizeSql(str: string): string {
  if (!str) return "";
  let sanitized = str;
  for (const pattern of SQL_INJECTION_PATTERNS) {
    sanitized = sanitized.replace(pattern, "[REDACTED]");
  }
  return sanitized;
}

/** Validate an email address with a strict RFC 5322–compatible regex.
 *  Returns true if the email looks valid. */
export function validateEmail(email: string): boolean {
  if (!email || email.length > 254) return false;
  const emailRegex =
    /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/;
  return emailRegex.test(email);
}

/** Validate a URL and reject dangerous protocols like javascript: or data:.
 *  Accepts http, https, and relative URLs. */
export function validateUrl(url: string): boolean {
  if (!url) return false;

  // Block known-dangerous protocols
  const dangerousProtocols = /^(javascript|data|vbscript|file):/i;
  if (dangerousProtocols.test(url.trim())) return false;

  // Allow relative URLs
  if (url.startsWith("/") && !url.startsWith("//")) return true;
  if (url.startsWith("#")) return true;

  try {
    const parsed = new URL(url);
    const allowedProtocols = ["http:", "https:", "mailto:", "tel:"];
    return allowedProtocols.includes(parsed.protocol);
  } catch {
    return false;
  }
}

/** Escape a string for safe use in HTML attributes.
 *  Replaces &, ", ', <, > with their corresponding entities. */
export function escapeAttr(str: string): string {
  if (!str) return "";
  return str
    .replace(/&/g, "&amp;")
    .replace(/"/g, "&quot;")
    .replace(/'/g, "&#x27;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}
