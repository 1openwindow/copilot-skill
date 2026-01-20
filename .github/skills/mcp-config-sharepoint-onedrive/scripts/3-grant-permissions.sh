#!/bin/bash
set -e

# Step 3: Grant API Permissions
# Adds permission and attempts admin consent

echo "============================================"
echo "Step 3: Grant API Permissions"
echo "============================================"
echo ""

CONFIG_FILE="$HOME/.mcp-sharepoint-config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config file not found!"
    echo "Run: ./scripts/1-create-app-registration.sh"
    exit 1
fi

CLIENT_ID=$(jq -r '.clientId' "$CONFIG_FILE")
API_ID="ea9ffc3e-8a23-4a7d-836d-234d7c7565c1"

echo "Adding SharePoint/OneDrive permission..."
echo ""

# Find the service principal for Agent 365 Tools
echo "Looking up Agent 365 Tools service principal..."
SP_OBJECT_ID=$(az ad sp list --filter "appId eq '$API_ID'" --query "[0].id" -o tsv)

if [ -z "$SP_OBJECT_ID" ]; then
    echo "⚠️  Agent 365 Tools service principal not found in your tenant"
    echo "This might mean your tenant doesn't have Agent 365 MCP enabled yet."
    echo ""
    echo "Manual steps:"
    echo "1. Go to: https://portal.azure.com"
    echo "2. Microsoft Entra ID → App registrations → Your app"
    echo "3. API permissions → Add → Search: $API_ID"
    echo "4. Select: McpServers.OneDriveSharepoint.All"
    echo "5. Grant admin consent"
    exit 1
fi

# Get the permission ID for OneDriveSharepoint.All
PERMISSION_ID=$(az ad sp show --id $SP_OBJECT_ID \
    --query "oauth2PermissionScopes[?value=='McpServers.OneDriveSharepoint.All'].id" \
    -o tsv)

if [ -z "$PERMISSION_ID" ]; then
    echo "❌ Could not find OneDriveSharepoint permission"
    exit 1
fi

# Add the permission
echo "Adding permission to app..."
az ad app permission add \
    --id "$CLIENT_ID" \
    --api "$API_ID" \
    --api-permissions "$PERMISSION_ID=Scope" 2>/dev/null || echo "Permission may already exist"

echo "✅ Permission added!"
echo ""

# Attempt to grant admin consent
echo "Attempting to grant admin consent..."
echo "(This requires Global Administrator role)"
echo ""

if az ad app permission admin-consent --id "$CLIENT_ID" 2>/dev/null; then
    echo "✅ Admin consent granted!"
    echo ""
    echo "Next: ./scripts/4-generate-foundry-config.sh"
else
    echo ""
    echo "⚠️  Could not grant admin consent automatically"
    echo "You need Global Administrator role for this step."
    echo ""
    echo "Please ask your Global Admin to:"
    echo "1. Go to: https://portal.azure.com"
    echo "2. Microsoft Entra ID → App registrations"
    echo "3. Find: Foundry Agent SharePoint"
    echo "4. API permissions → Grant admin consent for [Your Org]"
    echo ""
    echo "After admin grants consent, run: ./scripts/4-generate-foundry-config.sh"
fi



