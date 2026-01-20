#!/bin/bash
set -e

# Step 5: Add Redirect URL
# Adds Foundry redirect URL to app registration

echo "============================================"
echo "Step 5: Add Redirect URL"
echo "============================================"
echo ""

CONFIG_FILE="$HOME/.mcp-sharepoint-config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config file not found!"
    echo "Run: ./scripts/1-create-app-registration.sh"
    exit 1
fi

CLIENT_ID=$(jq -r '.clientId' "$CONFIG_FILE")

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
echo "Next: Add this tool to your agent"
echo ""
echo "1. Go to: https://ai.azure.com"
echo "2. Select your agent"
echo "3. Click 'Tools' or find the tools section"
echo "4. Add the 'SharePoint and OneDrive' tool"
echo "5. Test it by asking: 'List my recent 3 documents on OneDrive'"
echo "6. First time: Click consent link and sign in"
echo "7. Done! Your agent can now access SharePoint/OneDrive"


