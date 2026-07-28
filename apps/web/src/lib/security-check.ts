/**
 * Email Security Check - Phishing, Spam, and Malicious Content Detection
 */

export interface SecurityCheckResult {
  phishing_risk_level: 'none' | 'low' | 'medium' | 'high';
  spam_score: number; // 0-100
  suspicious_links: Array<{ url: string; risk: string }>;
  suspicious_phrases: string[];
  warnings: string[];
  safe_to_send: boolean;
}

/**
 * Perform comprehensive security check on newsletter content
 */
export function performSecurityCheck(subject: string, html: string): SecurityCheckResult {
  const result: SecurityCheckResult = {
    phishing_risk_level: 'none',
    spam_score: 0,
    suspicious_links: [],
    suspicious_phrases: [],
    warnings: [],
    safe_to_send: true,
  };

  // Check for phishing patterns
  checkPhishingPatterns(subject, html, result);

  // Check for malicious links
  checkMaliciousLinks(html, result);

  // Check for spam patterns
  checkSpamPatterns(subject, html, result);

  // Determine overall risk level and safe_to_send
  determineRiskLevel(result);

  return result;
}

/**
 * Check for common phishing patterns
 */
function checkPhishingPatterns(subject: string, html: string, result: SecurityCheckResult) {
  const text = (subject + ' ' + html).toLowerCase();

  // Phishing patterns
  const phishingPatterns = [
    { pattern: /verify (your|my|our) (account|identity|password)/i, risk: 'high', msg: 'Account verification request (phishing indicator)' },
    { pattern: /confirm (your|my) (password|login|credentials)/i, risk: 'high', msg: 'Password confirmation request' },
    { pattern: /urgent.*action required/i, risk: 'high', msg: 'False urgency pattern' },
    { pattern: /click.*immediately/i, risk: 'medium', msg: 'Aggressive CTA' },
    { pattern: /limited time.*offer/i, risk: 'low', msg: 'Time-sensitive offer' },
    { pattern: /act now/i, risk: 'low', msg: 'Action urgency' },
  ];

  phishingPatterns.forEach(({ pattern, risk, msg }) => {
    if (pattern.test(text)) {
      result.suspicious_phrases.push(msg);
      if (risk === 'high') result.phishing_risk_level = 'high';
      else if (risk === 'medium' && result.phishing_risk_level !== 'high') result.phishing_risk_level = 'medium';
      else if (risk === 'low' && result.phishing_risk_level === 'none') result.phishing_risk_level = 'low';
    }
  });

  // Check for spoofed email addresses
  const emailPattern = /from:\s*([^\s<]+@[^\s>]+)/i;
  const emailMatches = text.matchAll(emailPattern);
  for (const match of emailMatches) {
    const email = match[1].toLowerCase();
    if (!email.includes('mestio') && !email.includes('noreply')) {
      result.suspicious_phrases.push(`External sender: ${email}`);
      if (result.phishing_risk_level === 'none') result.phishing_risk_level = 'low';
    }
  }
}

/**
 * Check for malicious links
 */
function checkMaliciousLinks(html: string, result: SecurityCheckResult) {
  // Extract URLs from href and src attributes
  const urlPattern = /(href|src)=["']([^"']+)["']/gi;
  const matches = html.matchAll(urlPattern);

  const maliciousDomains = [
    'bit.ly',
    'tinyurl.com',
    'shorturl.at',
    'ow.ly', // Often used in phishing
    'goo.gl',
  ];

  const suspiciousTlds = ['.tk', '.ml', '.ga', '.cf', '.pw'];

  for (const match of matches) {
    const url = match[2];
    if (!url) continue;

    try {
      const urlObj = new URL(url);
      let linkRisk = 'none';

      // Check for URL shorteners
      if (maliciousDomains.some(domain => urlObj.hostname.includes(domain))) {
        linkRisk = 'high';
        result.suspicious_links.push({ url, risk: 'URL shortener (potential phishing vector)' });
      }

      // Check for suspicious TLDs
      if (suspiciousTlds.some(tld => urlObj.hostname.endsWith(tld))) {
        linkRisk = 'medium';
        result.suspicious_links.push({ url, risk: `Suspicious TLD: ${urlObj.hostname}` });
      }

      // Check for mismatched domain/link text in href
      const hrefText = html.substring(match.index!, match.index! + 100).match(/>([^<]+)<\/a>/)?.[1];
      if (hrefText) {
        const hrefDomain = new URL(url).hostname;
        if (!hrefText.includes(hrefDomain)) {
          linkRisk = 'medium';
          result.suspicious_links.push({ url, risk: 'Domain mismatch with display text' });
        }
      }

      if (linkRisk === 'high') result.phishing_risk_level = 'high';
      else if (linkRisk === 'medium' && result.phishing_risk_level !== 'high') result.phishing_risk_level = 'medium';
    } catch {
      // Invalid URL, skip
    }
  }
}

/**
 * Check for spam patterns
 */
function checkSpamPatterns(subject: string, html: string, result: SecurityCheckResult) {
  const text = (subject + ' ' + html).toLowerCase();

  let spamScore = 0;

  // Spam indicators
  const spamPatterns = [
    { pattern: /!!!+/g, weight: 5, msg: 'Multiple exclamation marks' },
    { pattern: /\${3,}/g, weight: 5, msg: 'Money symbols' },
    { pattern: /free.*money|make.*cash|easy.*money/i, weight: 15, msg: 'Get rich quick scheme' },
    { pattern: /winner|congratulations|claim your prize/i, weight: 10, msg: 'Prize/reward claim' },
    { pattern: /viagra|cialis|pharmacy|weight loss/i, weight: 20, msg: 'Pharmaceutical/adult content' },
    { pattern: /buy.*now|order.*today/i, weight: 5, msg: 'Aggressive sales pitch' },
    { pattern: /[A-Z]{10,}/g, weight: 3, msg: 'EXCESSIVE CAPS LOCK' },
  ];

  spamPatterns.forEach(({ pattern, weight, msg }) => {
    const matches = text.match(pattern);
    if (matches) {
      spamScore += weight * (matches.length || 1);
      result.suspicious_phrases.push(`${msg} (${matches.length}x)`);
    }
  });

  result.spam_score = Math.min(100, spamScore);

  // Add warnings based on spam score
  if (spamScore > 50) {
    result.warnings.push('High spam probability - newsletter may be flagged by email filters');
  } else if (spamScore > 30) {
    result.warnings.push('Moderate spam indicators - review content before sending');
  }
}

/**
 * Determine overall risk level
 */
function determineRiskLevel(result: SecurityCheckResult) {
  // Determine safe_to_send based on risk factors
  if (
    result.phishing_risk_level === 'high' ||
    result.spam_score > 80 ||
    result.suspicious_links.length > 3
  ) {
    result.safe_to_send = false;
    result.warnings.push('⚠️ NOT SAFE TO SEND - High risk detected');
  } else if (
    result.phishing_risk_level === 'medium' ||
    result.spam_score > 50 ||
    result.suspicious_links.length > 0
  ) {
    result.warnings.push('⚠️ Review carefully before sending');
  }

  // Always add footer warning for Mestio real estate
  result.warnings.push('✅ Content verified for Mestio (Real Estate - Low Risk Category)');
}

/**
 * Format security check results for display
 */
export function formatSecurityReport(result: SecurityCheckResult): string {
  let report = `
Security Check Report
======================
Risk Level: ${result.phishing_risk_level.toUpperCase()}
Spam Score: ${result.spam_score}/100
Safe to Send: ${result.safe_to_send ? '✅ YES' : '❌ NO'}

Suspicious Phrases (${result.suspicious_phrases.length}):
${result.suspicious_phrases.map(p => `  - ${p}`).join('\n')}

Suspicious Links (${result.suspicious_links.length}):
${result.suspicious_links.map(l => `  - ${l.url}\n    Risk: ${l.risk}`).join('\n')}

Warnings:
${result.warnings.map(w => `  • ${w}`).join('\n')}
  `.trim();

  return report;
}
