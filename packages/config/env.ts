/**
 * Environment variable validation for the Mestio monorepo.
 * Validates required env vars at startup and fails fast with a clear error message.
 */

const REQUIRED_ENV_VARS: Record<
  string,
  { description: string; requiredIn: ("web" | "crm-owner" | "crm-client" | "all")[] }
> = {
  NEXT_PUBLIC_SUPABASE_URL: {
    description: "Supabase project URL",
    requiredIn: ["all"],
  },
  NEXT_PUBLIC_SUPABASE_ANON_KEY: {
    description: "Supabase anonymous (public) key",
    requiredIn: ["all"],
  },
  SUPABASE_SERVICE_ROLE_KEY: {
    description: "Supabase service role key (server-side only)",
    requiredIn: ["web", "crm-owner"],
  },
  STRIPE_SECRET_KEY: {
    description: "Stripe secret API key",
    requiredIn: ["web"],
  },
  NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY: {
    description: "Stripe publishable key",
    requiredIn: ["web"],
  },
  STRIPE_WEBHOOK_SECRET: {
    description: "Stripe webhook signing secret",
    requiredIn: ["web"],
  },
  RESEND_API_KEY: {
    description: "Resend email API key",
    requiredIn: ["web", "crm-owner"],
  },
};

export type AppName = "web" | "crm-owner" | "crm-client";

export interface EnvValidationResult {
  valid: boolean;
  missing: string[];
  warnings: string[];
}

/**
 * Validate that all required environment variables are set for the given app.
 * Call this at startup (e.g., in instrumentation.ts or a top-level layout).
 *
 * @param appName - The name of the app to validate env vars for.
 * @param throwOnError - If true, throws an Error listing all missing vars.
 * @returns An EnvValidationResult with details.
 */
export function validateEnv(
  appName: AppName,
  throwOnError = true
): EnvValidationResult {
  const missing: string[] = [];
  const warnings: string[] = [];

  for (const [varName, config] of Object.entries(REQUIRED_ENV_VARS)) {
    if (
      config.requiredIn.includes("all") ||
      config.requiredIn.includes(appName)
    ) {
      if (!process.env[varName] || process.env[varName]!.trim() === "") {
        missing.push(`${varName} (${config.description})`);
      }
    }
  }

  // Check for optional but recommended vars
  if (!process.env.NEXT_PUBLIC_SITE_URL) {
    warnings.push("NEXT_PUBLIC_SITE_URL is not set — using default");
  }

  const result: EnvValidationResult = {
    valid: missing.length === 0,
    missing,
    warnings,
  };

  if (!result.valid && throwOnError) {
    const message =
      `❌ Missing required environment variables for app "${appName}":\n` +
      missing.map((m) => `   • ${m}`).join("\n") +
      "\n\nPlease set these in your .env.local file or deployment environment.";
    throw new Error(message);
  }

  return result;
}

/**
 * Lightweight version that logs warnings instead of throwing.
 * Suitable for client-side or non-critical paths.
 */
export function checkEnvWarnings(appName: AppName): void {
  const result = validateEnv(appName, false);
  if (!result.valid) {
    console.warn(
      `[env] Missing vars for ${appName}:`,
      result.missing.join(", ")
    );
  }
  if (result.warnings.length > 0) {
    console.warn(`[env] Warnings for ${appName}:`, result.warnings.join(", "));
  }
}
