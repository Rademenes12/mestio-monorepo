import { createClient } from 'npm:@supabase/supabase-js@2';

const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
const supabaseAnonKey = Deno.env.get('SUPABASE_ANON_KEY') ?? '';
const supabaseServiceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';

// Deploy this shared function with verify_jwt=false. Projects using ES256 or
// other asymmetric JWT signing keys can fail Supabase's legacy edge verifier
// before this code runs. The function still requires and validates the user's
// bearer token explicitly below.
if (!supabaseUrl || !supabaseAnonKey || !supabaseServiceRoleKey) {
  throw new Error(
    'Missing required env vars: SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_ROLE_KEY',
  );
}

const json = (status: number, body: Record<string, unknown>) =>
  new Response(
    JSON.stringify(body),
    {
      status,
      headers: {
        'Content-Type': 'application/json',
      },
    },
  );

Deno.serve(async (request: Request) => {
  if (request.method !== 'POST') {
    return json(405, { error: 'method_not_allowed' });
  }

  const authorization = request.headers.get('Authorization') ?? '';
  const token = authorization.startsWith('Bearer ')
    ? authorization.replace('Bearer ', '').trim()
    : '';

  if (!token) {
    return json(401, { error: 'missing_bearer_token' });
  }

  const userClient = createClient(
    supabaseUrl,
    supabaseAnonKey,
    {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    },
  );

  const { data: userData, error: userError } = await userClient.auth.getUser(token);
  if (userError || !userData.user) {
    return json(401, { error: 'invalid_user_token' });
  }

  const userId = userData.user.id;

  const adminClient = createClient(
    supabaseUrl,
    supabaseServiceRoleKey,
    {
      auth: {
        persistSession: false,
        autoRefreshToken: false,
      },
    },
  );

  // App-specific extension:
  // Keep this shared function minimal. If an app needs cleanup, do it before
  // calling delete-account, or add a separate prefixed function such as
  // myapp-cleanup-storage.

  const { error: deleteError } = await adminClient.auth.admin.deleteUser(userId);
  if (deleteError) {
    console.error('deleteUser failed', deleteError);
    return json(500, {
      error: 'delete_account_failed',
      details: deleteError.message,
      code: deleteError.status ?? deleteError.code,
    });
  }

  return json(200, { ok: true });
});
