#!/bin/bash
set -e

# Step 2: Create Client Secret
# =============================
# This script creates a client secret for authenticating your MCP server.
#
# What it does:
# 1. Reads the Client ID from entra-app-config.json
# 2. Creates a client secret with 24-month expiry
# 3. Displays the secret value (YOU MUST COPY THIS!)
#
# Requirements:
# - entra-app-config.json exists (from script 1)
# - Azure CLI logged in

echo "============================================"
echo "Step 2: Create Client Secret"
echo "============================================"
echo ""

# Check config file exists
if [ ! -f "entra-app-config.json" ]; then
    echo "❌ entra-app-config.json not found!"
    echo "Run ./scripts/1-create-app-registration.sh first"
    exit 1
fi

CLIENT_ID=$(jq -r '.clientId' entra-app-config.json)

echo "Creating client secret for app: $CLIENT_ID"
echo "Expiry: 24 months"
echo ""

# Create client secret
SECRET=$(az ad app credential reset \
  --id "$CLIENT_ID" \
  --years 2 \
  --query password \
  -o tsv)

echo "✅ Client secret created!"
echo ""
echo "================================================================"
echo "⚠️  IMPORTANT: Copy this secret value immediately!"
echo ""
echo "    $SECRET"
echo ""
echo "This value won't be shown again. You'll need it in Step 5."
echo "================================================================"
echo ""
echo "Next step: Run ./scripts/3-grant-permissions.sh"
