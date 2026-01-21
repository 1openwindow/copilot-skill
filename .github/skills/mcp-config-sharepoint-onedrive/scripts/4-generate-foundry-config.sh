#!/bin/bash
set -e

# Step 4: Generate Foundry Configuration
# Outputs formatted values for Foundry portal

echo "============================================"
echo "Step 4: Generate Foundry Configuration"
echo "============================================"
echo ""

CONFIG_FILE="$HOME/.agent-dev-meta/.mcp-sharepoint-config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config file not found!"
    echo "Run: ./scripts/1-create-app-registration.sh"
    exit 1
fi

CLIENT_ID=$(jq -r '.clientId' "$CONFIG_FILE")
TENANT_ID=$(jq -r '.tenantId' "$CONFIG_FILE")

echo "📋 Copy these values into Foundry MCP configuration:"
echo ""
echo "────────────────────────────────────────"
echo "Name:"
echo "SharePoint and OneDrive"
echo ""
echo "Remote MCP Server endpoint:"
echo "https://agent365.svc.cloud.microsoft/agents/servers/mcp_ODSPRemoteServer"
echo ""
echo "Authentication:"
echo "OAuth Identity Passthrough"
echo ""
echo "Client ID:"
echo "$CLIENT_ID"
echo ""
echo "Client Secret:"
echo "[paste from Step 2]"
echo ""
echo "Token URL:"
echo "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token"
echo ""
echo "Auth URL:"
echo "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/authorize"
echo ""
echo "Refresh URL:"
echo "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token"
echo ""
echo "Scopes:"
echo "ea9ffc3e-8a23-4a7d-836d-234d7c7565c1/McpServers.OneDriveSharepoint.All"
echo "────────────────────────────────────────"
echo ""
echo "After saving in Foundry:"
echo "1. Copy the Redirect URL"
echo "2. Run: ./scripts/5-add-redirect-url.sh"


