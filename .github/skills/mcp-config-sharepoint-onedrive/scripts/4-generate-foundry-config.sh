#!/bin/bash
set -e

# Step 4: Generate Foundry Configuration
# =======================================
# This script generates the exact configuration values you need to paste
# into Foundry portal when connecting the MCP tool.
#
# What it does:
# 1. Reads Client ID and Tenant ID from entra-app-config.json
# 2. Generates all OAuth URLs
# 3. Outputs everything in a copy-paste friendly format
#
# Requirements:
# - entra-app-config.json exists

echo "============================================"
echo "Step 4: Generate Foundry Configuration"
echo "============================================"
echo ""

# Check config file exists
if [ ! -f "entra-app-config.json" ]; then
    echo "❌ entra-app-config.json not found!"
    echo "Run ./scripts/1-create-app-registration.sh first"
    exit 1
fi

CLIENT_ID=$(jq -r '.clientId' entra-app-config.json)
TENANT_ID=$(jq -r '.tenantId' entra-app-config.json)

echo "Reading your configuration..."
echo ""
echo "================================================================"
echo "📋 Foundry MCP Configuration"
echo "================================================================"
echo ""
echo "Use these values in Foundry portal:"
echo "(https://ai.azure.com → your agent → Connect a tool → Custom → MCP)"
echo ""
echo "────────────────────────────────────────────────────────────────"
echo "Name:"
echo "SharePoint and OneDrive"
echo ""
echo "Authentication:"
echo "OAuth Identity Passthrough"
echo ""
echo "────────────────────────────────────────────────────────────────"
echo "Client ID:"
echo "$CLIENT_ID"
echo ""
echo "Client Secret:"
echo "[Paste the secret from Step 2]"
echo ""
echo "────────────────────────────────────────────────────────────────"
echo "Token URL:"
echo "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token"
echo ""
echo "Auth URL:"
echo "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/authorize"
echo ""
echo "Refresh URL:"
echo "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token"
echo ""
echo "────────────────────────────────────────────────────────────────"
echo "Scopes:"
echo "ea9ffc3e-8a23-4a7d-836d-234d7c7565c1/McpServers.OneDriveSharepoint.All"
echo ""
echo "================================================================"
echo ""
echo "After saving in Foundry:"
echo "1. Foundry will show you a Redirect URL"
echo "2. Copy that Redirect URL"
echo "3. Run: ./scripts/5-add-redirect-url.sh"
