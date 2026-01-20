#!/bin/bash
set -e

# Step 3: Grant API Permissions (Manual Step)
# Shows instructions for adding permission in portal

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

echo "⚠️  This step requires manual action in Azure Portal"
echo ""
echo "1. Go to: https://portal.azure.com"
echo "2. Navigate: Microsoft Entra ID → App registrations"
echo "3. Find: Foundry Agent SharePoint"
echo "4. Go to: API permissions → Add a permission"
echo "5. Search: ea9ffc3e-8a23-4a7d-836d-234d7c7565c1"
echo "6. Select: McpServers.OneDriveSharepoint.All"
echo "7. Click: Add permissions"
echo "8. Click: Grant admin consent for [Your Org]"
echo ""
echo "⚠️  Requires Global Administrator role"
echo ""
echo "After completing, run: ./scripts/4-generate-foundry-config.sh"


