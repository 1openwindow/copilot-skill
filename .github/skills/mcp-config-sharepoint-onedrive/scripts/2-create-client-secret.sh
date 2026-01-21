#!/bin/bash
set -e

# Step 2: Create Client Secret
# Generates 24-month client secret

echo "============================================"
echo "Step 2: Create Client Secret"
echo "============================================"
echo ""

CONFIG_FILE="$HOME/.agent-dev-meta/.mcp-sharepoint-config.json"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config file not found!"
    echo "Run: ./scripts/1-create-app-registration.sh"
    exit 1
fi

CLIENT_ID=$(jq -r '.clientId' "$CONFIG_FILE")

echo "Creating client secret (24 month expiry)..."
echo ""

SECRET=$(az ad app credential reset \
  --id "$CLIENT_ID" \
  --years 2 \
  --query password \
  -o tsv)

echo "✅ Client secret created!"
echo ""
echo "================================================================"
echo "⚠️  COPY THIS SECRET NOW - it won't be shown again!"
echo ""
echo "    $SECRET"
echo ""
echo "================================================================"
echo ""
echo "Next: ./scripts/3-grant-permissions.sh"


