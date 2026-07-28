import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
const supabaseAnonKey = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
const supabaseServiceRoleKey =
  Deno.env.get("SERVICE_ROLE_KEY") ??
  Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ??
  "";

interface NotificationRequest {
  topic: string;
  title: string;
  body: string;
  data?: Record<string, string>;
}

interface FcmMessage {
  message: {
    topic: string;
    notification: {
      title: string;
      body: string;
    };
    data?: Record<string, string>;
  };
}

serve(async (req) => {
  try {
    // SECURITY FIX: Always require JWT authentication
    const authHeader = req.headers.get("Authorization") ?? "";
    const token = authHeader.startsWith("Bearer ") ? authHeader.replace("Bearer ", "").trim() : "";

    if (!token) {
      return new Response(
        JSON.stringify({ error: "missing_bearer_token" }),
        { status: 401, headers: { "Content-Type": "application/json" } }
      );
    }

    // Trusted internal callers (the fixflow_report_change DB trigger, which
    // has no end-user session to attach) authenticate with the service_role
    // key instead of a user JWT.
    const isTrustedServiceCall =
      supabaseServiceRoleKey.length > 0 && token === supabaseServiceRoleKey;

    // DEBUG: check if secret is loaded
    const debugMode = Deno.env.get("DEBUG") === "true";
    if (debugMode) {
      return new Response(
        JSON.stringify({
          hasSecret: supabaseServiceRoleKey.length > 0,
          secretLength: supabaseServiceRoleKey.length,
          tokenLength: token.length,
          match: token === supabaseServiceRoleKey,
        }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    }

    if (!isTrustedServiceCall) {
      const supabase = createClient(supabaseUrl, supabaseAnonKey, {
        auth: { persistSession: false, autoRefreshToken: false },
      });
      const { data: { user }, error: authError } = await supabase.auth.getUser(token);
      if (authError || !user) {
        return new Response(
          JSON.stringify({ error: "invalid_token", hasSecret: supabaseServiceRoleKey.length > 0, secretStart: supabaseServiceRoleKey.substring(0, 20), tokenStart: token.substring(0, 20) }),
          { status: 401, headers: { "Content-Type": "application/json" } }
        );
      }
    }

    const { topic, title, body, data }: NotificationRequest = await req.json();

    if (!topic || !title || !body) {
      return new Response(
        JSON.stringify({ error: "Missing required fields: topic, title, body" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Get Firebase credentials from environment
    const firebaseProjectId = Deno.env.get("FIREBASE_PROJECT_ID");
    const firebaseClientEmail = Deno.env.get("FIREBASE_CLIENT_EMAIL");
    const firebasePrivateKey = Deno.env.get("FIREBASE_PRIVATE_KEY");

    // DEBUG: log what we have
    console.log("FIREBASE_PROJECT_ID:", firebaseProjectId ? "set" : "missing");
    console.log("FIREBASE_CLIENT_EMAIL:", firebaseClientEmail ? "set" : "missing");
    console.log("FIREBASE_PRIVATE_KEY:", firebasePrivateKey ? "set (len=" + firebasePrivateKey.length + ")" : "missing");

    if (!firebaseProjectId || !firebaseClientEmail || !firebasePrivateKey) {
      console.warn("Firebase credentials not configured, skipping push notification");
      return new Response(
        JSON.stringify({ 
          success: false, 
          message: "Firebase credentials not configured - notification logged but not sent"
        }),
        { status: 200, headers: { "Content-Type": "application/json" } }
      );
    }

    // Get FCM access token using service account
    const fcmAccessToken = await getFcmAccessToken(
      firebaseClientEmail,
      firebasePrivateKey
    );

    // Send FCM message
    const fcmMessage: FcmMessage = {
      message: {
        topic: sanitizeTopic(topic),
        notification: { title, body },
        data: data || {},
      },
    };

    const fcmResponse = await fetch(
      `https://fcm.googleapis.com/v1/projects/${firebaseProjectId}/messages:send`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + fcmAccessToken,
        },
        body: JSON.stringify(fcmMessage),
      }
    );

    if (!fcmResponse.ok) {
      const errorText = await fcmResponse.text();
      console.error("FCM send failed:", errorText);
      return new Response(
        JSON.stringify({ success: false, error: errorText }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }

    const result = await fcmResponse.json();
    console.log("FCM message sent successfully:", result);

    return new Response(
      JSON.stringify({ success: true, messageId: result.name }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("Edge function error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});

async function getFcmAccessToken(
  clientEmail: string,
  privateKey: string
): Promise<string> {
  const jwtHeader = { alg: "RS256", typ: "JWT" };
  const now = Math.floor(Date.now() / 1000);
  const jwtClaim = {
    iss: clientEmail,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    exp: now + 3600,
    iat: now,
  };

  const encodedHeader = base64UrlEncode(JSON.stringify(jwtHeader));
  const encodedClaim = base64UrlEncode(JSON.stringify(jwtClaim));
  const signatureInput = `${encodedHeader}.${encodedClaim}`;

  // Sign JWT with RSA-SHA256
  const key = await crypto.subtle.importKey(
    "pkcs8",
    parsePrivateKey(privateKey),
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"]
  );

  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(signatureInput)
  );

  const jwt = `${signatureInput}.${base64UrlEncodeBuffer(signature)}`;

  // Exchange JWT for access token
  const tokenResponse = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: `grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer&assertion=${jwt}`,
  });

  const tokenData = await tokenResponse.json();
  if (!tokenData.access_token) {
    throw new Error(`Failed to get access token: ${JSON.stringify(tokenData)}`);
  }

  return tokenData.access_token;
}

function parsePrivateKey(key: string): ArrayBuffer {
  const keyContent = key
    .replace(/-----BEGIN PRIVATE KEY-----/g, "")
    .replace(/-----END PRIVATE KEY-----/g, "")
    .replace(/\\n/g, "")
    .replace(/\s/g, "");
  return base64Decode(keyContent);
}

function base64UrlEncode(str: string): string {
  return btoa(str).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function base64UrlEncodeBuffer(buffer: ArrayBuffer): string {
  const bytes = new Uint8Array(buffer);
  let binary = "";
  for (const byte of bytes) {
    binary += String.fromCharCode(byte);
  }
  return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function base64Decode(str: string): ArrayBuffer {
  const binary = atob(str);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) {
    bytes[i] = binary.charCodeAt(i);
  }
  return bytes.buffer;
}

function sanitizeTopic(topic: string): string {
  return topic.replace(/[^a-zA-Z0-9-_.~%]/g, "_").toLowerCase();
}
