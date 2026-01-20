#!/bin/bash
set -e

# Step 5: Add Redirect URL
# =========================
# This script adds the Foundry redirect URL to your app registration.
#
# What it does:
# 1. Prompts you to paste the Redirect URL from Foundry
# 2. Adds it as a web redirect URI in your app registration
#
# Requirements:
# - entra-app-config.json exists
# - Azure CLI logged in
# - You've saved the MCP tool in Foundry and have the redirect URL

echo "============================================"
echo "Step 5: Add Redirect URL"
echo "============================================"
echo ""

# Check config file exists
if [ ! -f "entra-app-config.json" ]; then
    echo "❌ entra-app-config.json not found!"
    echo "Run ./scripts/1-create-app-registration.sh first"
    exit 1
fi

CLIENT_ID=$(jq -r '.clientId' entra-app-config.json)

echo "After saving the MCP tool in Foundry, a Redirect URL is generated."
echo ""
echo "Paste the Redirect URL here:"
read -r REDIRECT_URL

if [ -z "$REDIRECT_URL" ]; then
    echo "❌ No URL provided"
    exit 1
fi

echo ""
echo "Adding redirect URL to app registration..."

# Get current redirect URIs (if any)
CURRENT_URIS=$(az ad app show --id "$CLIENT_ID" --query "web.redirectUris" -o json || echo "[]")

# Add the new URI
NEW_URIS=$(echo "$CURRENT_URIS" | jq --arg uri "$REDIRECT_URL" '. + [$uri] | unique')

# Update the app
az ad app update --id "$CLIENT_ID" --web-redirect-uris ${NEW_URIS[@]//[\[\]\"]/}

echo ""
echo "✅ Redirect URL added successfully!"
echo ""
echo "================================================================"
echo "🎉 Configuration Complete!"
echo "================================================================"
echo ""
echo "Next steps:"
echo "1. Go to your Foundry agent"
echo "2. Start a conversation"
echo "3. Ask: 'List my recent SharePoint files'"
echo "4. First time: Click the consent link and sign in"
echo "5. After consent: Your agent can access SharePoint/OneDrive!"
echo ""
echo "Troubleshooting:"
echo "- If consent link doesn't appear: Check Azure AI User role"
echo "- If permission denied: Verify admin consent was granted"
echo "- If auth fails: Ensure redirect URL matches exactly"
