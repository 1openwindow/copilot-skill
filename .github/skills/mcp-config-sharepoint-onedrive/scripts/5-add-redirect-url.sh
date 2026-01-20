#!/bin/bash
set -e

# Step 5: Add Redirect URL
# Adds Foundry redirect URL to app registration

echo "============================================"
echo "Step 5: Add Redirect URL"
echo "============================================"
echo ""

if [ ! -f "entra-app-config.json" ]; then
    echo "❌ entra-app-config.json not found!"
    echo "Run: ./scripts/1-create-app-registration.sh"
    exit 1
fi

CLIENT_ID=$(jq -r '.clientId' entra-app-config.json)

echo "Paste the Redirect URL from Foundry:"
read -r REDIRECT_URL

if [ -z "$REDIRECT_URL" ]; then
    echo "❌ No URL provided"
    exit 1
fi

echo ""
echo "Adding redirect URL..."

# Get current URIs and add new one
CURRENT_URIS=$(az ad app show --id "$CLIENT_ID" --query "web.redirectUris" -o json || echo "[]")
NEW_URIS=$(echo "$CURRENT_URIS" | jq --arg uri "$REDIRECT_URL" '. + [$uri] | unique')
az ad app update --id "$CLIENT_ID" --web-redirect-uris ${NEW_URIS[@]//[\[\]\"]/}

echo ""
echo "✅ Redirect URL added!"
echo ""
echo "════════════════════════════════════════"
echo "🎉 Configuration Complete!"
echo "════════════════════════════════════════"
echo ""
echo "Test it:"
echo "1. Chat with your Foundry agent"
echo "2. Ask: 'List my recent SharePoint files'"
echo "3. First time: Click consent link and sign in"
echo "4. Done! Agent can now access SharePoint/OneDrive"

