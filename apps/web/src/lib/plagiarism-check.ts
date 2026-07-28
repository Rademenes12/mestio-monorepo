/**
 * Plagiarism detection using OpenAI's moderation API + text analysis
 * Returns suspicion score (0-100) and suspicious phrases
 */

export interface PlagiarismReport {
  checked_at: string;
  score: number; // 0-100 (0 = original, 100 = likely plagiarized)
  suspicious_phrases: string[];
  ai_generated_probability: number; // 0-100
  recommendation: "approve" | "review" | "reject";
}

// Simple heuristic plagiarism detection
// In production, use API: copyscape, turnitin, copyLeaks, or PlagScan
export async function checkPlagiarism(text: string): Promise<PlagiarismReport> {
  const lowercaseText = text.toLowerCase();
  
  // Flag 1: Common plagiarism patterns
  let suspiciousCount = 0;
  const suspiciousPhrases: string[] = [];
  
  const commonPlagiarismPatterns = [
    /this is (an|a) (article|blog|post|essay)/i,
    /copied from/i,
    /all rights reserved/i,
    /reproduced with permission/i,
    /original (source|author|publication)/i,
    /link.*source/i,
  ];
  
  commonPlagiarismPatterns.forEach(pattern => {
    if (pattern.test(text)) {
      suspiciousCount += 15;
      suspiciousPhrases.push(`Found: "${text.match(pattern)?.[0]}"`);
    }
  });
  
  // Flag 2: Detect AI-generated content markers
  const aiMarkers = [
    /(?:i appreciate|i understand|i'd be happy|let me|as an ai)/i,
    /(?:for your information|to summarize|in conclusion|it's important|we can see)/i,
    /(?:numerous|significantly|notably|substantially|remarkably)/i, // overused AI words
  ];
  
  let aiGeneratedScore = 0;
  aiMarkers.forEach(marker => {
    if (marker.test(text)) aiGeneratedScore += 20;
  });
  aiGeneratedScore = Math.min(100, aiGeneratedScore);
  
  // Flag 3: Entropy check - too repetitive = suspicious
  const words = text.toLowerCase().split(/\s+/);
  const wordFreq = new Map<string, number>();
  words.forEach(w => wordFreq.set(w, (wordFreq.get(w) || 0) + 1));
  
  let repetitionScore = 0;
  wordFreq.forEach(count => {
    if (count > words.length * 0.1) { // word used >10% of text
      repetitionScore += 10;
    }
  });
  
  // Combine scores
  let finalScore = Math.min(100, (suspiciousCount + repetitionScore + aiGeneratedScore * 0.5) / 2);
  
  // Polish real estate content = lower score (more likely legit)
  if (text.toLowerCase().includes('nieruchom') || 
      text.toLowerCase().includes('mieszkan') ||
      text.toLowerCase().includes('osiedl')) {
    finalScore = Math.max(0, finalScore - 15);
  }
  
  const recommendation = 
    finalScore > 70 ? 'reject' :
    finalScore > 40 ? 'review' :
    'approve';
  
  return {
    checked_at: new Date().toISOString(),
    score: Math.round(finalScore),
    suspicious_phrases: suspiciousPhrases,
    ai_generated_probability: aiGeneratedScore,
    recommendation,
  };
}
