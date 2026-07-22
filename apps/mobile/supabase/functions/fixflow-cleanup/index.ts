import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "npm:@supabase/supabase-js@2";

const supabaseUrl = Deno.env.get("SUPABASE_URL") ?? "";
const supabaseServiceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "";

if (!supabaseUrl || !supabaseServiceRoleKey) {
  throw new Error("Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
}

serve(async (req) => {
  try {
    // Verify user authentication
    const authHeader = req.headers.get("Authorization") ?? "";
    if (!authHeader.startsWith("Bearer ")) {
      return new Response(
        JSON.stringify({ error: "missing_bearer_token" }),
        { status: 401, headers: { "Content-Type": "application/json" } }
      );
    }

    const token = authHeader.replace("Bearer ", "").trim();
    
    const userClient = createClient(supabaseUrl, Deno.env.get("SUPABASE_ANON_KEY") ?? "", {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    const { data: { user }, error: userError } = await userClient.auth.getUser(token);
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: "invalid_user_token" }),
        { status: 401, headers: { "Content-Type": "application/json" } }
      );
    }

    const userId = user.id;
    console.log(`Cleaning up FixFlow data for user: ${userId}`);

    const adminClient = createClient(supabaseUrl, supabaseServiceRoleKey, {
      auth: { persistSession: false, autoRefreshToken: false },
    });

    // Delete user's reports (only those created by user, not assigned)
    // Note: Must delete comments and images first due to FK constraints
    const { error: commentsError } = await adminClient
      .from("fixflow_report_comments")
      .delete()
      .eq("author_id", userId);
    
    if (commentsError) {
      console.error("Failed to delete comments:", commentsError);
    }

    // Get user's reports before deleting them (for photo cleanup).
    // Match by BOTH the stable reporter_user_id AND reporter_email: older
    // rows (created before reporter_user_id existed) or rows whose email
    // no longer matches the current account email would otherwise survive
    // deletion if matched by email alone.
    const emailFilter = user.email ? `,reporter_email.eq.${user.email}` : "";
    const { data: userReports, error: reportsFetchError } = await adminClient
      .from("fixflow_reports")
      .select("id, estate_id")
      .or(`reporter_user_id.eq.${userId}${emailFilter}`);
    
    if (reportsFetchError) {
      console.error("Failed to fetch user reports:", reportsFetchError);
    }

    // Delete report images (FK cascade should handle this, but be explicit)
    if (userReports && userReports.length > 0) {
      const reportIds = userReports.map(r => r.id);
      const { error: imagesError } = await adminClient
        .from("fixflow_report_images")
        .delete()
        .in("report_id", reportIds);
      
      if (imagesError) {
        console.error("Failed to delete report images:", imagesError);
      }
    }

    // Now delete the reports (same stable-id + email match as the fetch above)
    const { error: reportsError } = await adminClient
      .from("fixflow_reports")
      .delete()
      .or(`reporter_user_id.eq.${userId}${emailFilter}`);
    
    if (reportsError) {
      console.error("Failed to delete reports:", reportsError);
    }

    // Delete user's shared profile (shared_users table used across all apps)
    const { error: sharedUsersError } = await adminClient
      .from("shared_users")
      .delete()
      .eq("id", userId);
    if (sharedUsersError) {
      console.error("Failed to delete shared_users row:", sharedUsersError);
    }

    // Delete user's resident profile
    const { error: profileError } = await adminClient
      .from("fixflow_resident_profiles")
      .delete()
      .eq("id", userId);
    
    if (profileError) {
      console.error("Failed to delete profile:", profileError);
    }

    // Delete user's estate memberships
    const { error: estatesError } = await adminClient
      .from("fixflow_user_estates")
      .delete()
      .eq("user_id", userId);
    
    if (estatesError) {
      console.error("Failed to delete estate memberships:", estatesError);
    }

    // Delete user's permissions
    const { error: permissionsError } = await adminClient
      .from("fixflow_permissions")
      .delete()
      .eq("user_id", userId);
    
    if (permissionsError) {
      console.error("Failed to delete permissions:", permissionsError);
    }

    // Delete user's content reports (both reports BY and ABOUT this user)
    const { error: contentReportsError } = await adminClient
      .from("fixflow_content_reports")
      .delete()
      .or(`reporter_id.eq.${userId},content_id.eq.${userId}`);
    
    if (contentReportsError) {
      console.error("Failed to delete content reports:", contentReportsError);
    }

    // Delete user's photos from storage
    // SECURITY FIX: Must list files in folder first, then delete individual files
    if (userReports && userReports.length > 0) {
      for (const report of userReports) {
        if (report.estate_id && report.id) {
          const folderPath = `${report.estate_id}/${report.id}`;
          
          try {
            // List all files in the report folder
            const { data: files, error: listError } = await adminClient.storage
              .from("fixflow-report-photos")
              .list(folderPath);
            
            if (listError) {
              console.log(`Storage list error for ${folderPath}: ${listError.message}`);
              continue;
            }
            
            if (files && files.length > 0) {
              // Build full paths for each file
              const filePaths = files.map(f => `${folderPath}/${f.name}`);
              
              const { error: removeError } = await adminClient.storage
                .from("fixflow-report-photos")
                .remove(filePaths);
              
              if (removeError) {
                console.log(`Storage remove error for ${folderPath}: ${removeError.message}`);
              } else {
                console.log(`Deleted ${filePaths.length} files from ${folderPath}`);
              }
            }
          } catch (storageError) {
            console.log(`Storage cleanup error for ${folderPath}: ${storageError}`);
          }
        }
      }
    }

    console.log(`FixFlow cleanup completed for user: ${userId}`);

    return new Response(
      JSON.stringify({ success: true, message: "FixFlow data cleaned up" }),
      { status: 200, headers: { "Content-Type": "application/json" } }
    );
  } catch (error) {
    console.error("Cleanup error:", error);
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { "Content-Type": "application/json" } }
    );
  }
});
