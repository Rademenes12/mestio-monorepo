#!/bin/bash
# Deploy Mestio Edge Functions to Supabase
# Usage: ./deploy-edge-functions.sh

set -e

echo "🚀 Deploying Mestio Edge Functions..."

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI is not installed. Install it first:"
    echo "   npm install -g supabase"
    exit 1
fi

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ .env file not found. Create it with SUPABASE_PROJECT_ID"
    exit 1
fi

# Load .env
source .env

echo "📦 Deploying fixflow-cleanup..."
supabase functions deploy fixflow-cleanup --project-ref $SUPABASE_PROJECT_ID

echo "📦 Deploying delete-account..."
supabase functions deploy delete-account --project-ref $SUPABASE_PROJECT_ID

echo "📦 Deploying send-notification..."
supabase functions deploy send-notification --project-ref $SUPABASE_PROJECT_ID

echo "✅ All edge functions deployed successfully!"
echo ""
echo "⚠️  Don't forget to set secrets:"
echo "   supabase secrets set FIREBASE_PROJECT_ID=your_project_id"
echo "   supabase secrets set FIREBASE_CLIENT_EMAIL=your_client_email"
echo "   supabase secrets set FIREBASE_PRIVATE_KEY='your_private_key'"
