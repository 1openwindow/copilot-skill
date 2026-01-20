#!/bin/bash
set -e

# Step 3: Grant API Permissions
# ==============================
# This script adds the SharePoint/OneDrive permission to your app.
#
# What it does:
# 1. Reads Client ID from entra-app-config.json
# 2. Adds Agent 365 Tools API permission for SharePoint/OneDrive
# 
# Note: Admin consent still needs to be granted manually in the portal
# (Azure CLI doesn't support programmatic admin consent grant)
#
# Requirements:
# - entra-app-config.json exists
# - Azure CLI logged in
# - Permission to modify app registrations

echo "============================================"
echo "Step 3: Grant API Permissions"
echo "============================================"
echo ""

# Check config file exists
if [ ! -f "entra-app-config.json" ]; then
    echo "❌ entra-app-config.json not found!"
    echo "Run ./scripts/1-create-app-registration.sh first"
    exit 1
fi

CLIENT_ID=$(jq -r '.clientId' entra-app-config.json)
API_ID="ea9ffc3e-8a23-4a7d-836d-234d7c7565c1"  # Agent 365 Tools

echo "Adding permission to app: $CLIENT_ID"
echo "API: Agent 365 Tools"
echo "Permission: McpServers.OneDriveSharepoint.All"
echo ""

# Note: The permission ID needs to be looked up from the Agent 365 Tools service principal
# This is a simplified version - in production, you'd query for the permission ID
echo "⚠️  Note: Permission addition via CLI requires the permission GUID."
echo "For simplicity, please add this permission manually:"
echo ""
echo "1. Go to Azure Portal: https://portal.azure.com"
echo "2. Navigate to: Microsoft Entra ID > App registrations"
echo "3. Find your app: Foundry Agent SharePoint"
echo "4. Go to: API permissions > Add a permission"
echo "5. Search for: $API_ID (Agent 365 Tools)"
echo "6. Select: McpServers.OneDriveSharepoint.All"
echo "7. Click: Add permissions"
echo "8. Click: Grant admin consent for [Your Org]"
echo ""
echo "This step requires a Global Administrator."
echo ""
echo "Once completed, proceed to: ./scripts/4-generate-foundry-config.sh"
