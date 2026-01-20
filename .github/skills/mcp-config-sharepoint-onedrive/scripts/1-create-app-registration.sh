#!/bin/bash
set -e

# Step 1: Create Entra App Registration
# Creates app registration and saves Client ID + Tenant ID

echo "============================================"
echo "Step 1: Create Entra App Registration"
echo "============================================"
echo ""

# Check Azure CLI
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI not installed."
    echo "Install: https://docs.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

# Check login
if ! az account show &> /dev/null; then
    echo "❌ Not logged in to Azure CLI."
    echo "Run: az login"
    exit 1
fi

echo "Creating app registration..."
echo ""

# Save config to current directory (not inside skills folder)
CONFIG_FILE="$HOME/.mcp-sharepoint-config.json"

# Create app
az ad app create \
  --display-name "Foundry Agent SharePoint" \
  --sign-in-audience AzureADMyOrg \
  --query "{clientId:appId}" \
  -o json > "$CONFIG_FILE"

# Add tenant ID
TENANT_ID=$(az account show --query tenantId -o tsv)
jq --arg tid "$TENANT_ID" '. + {tenantId: $tid}' "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"

echo "✅ App created!"
echo ""
cat "$CONFIG_FILE" | jq .
echo ""
echo "💾 Config saved to: $CONFIG_FILE"
echo ""
echo "Next: ./scripts/2-create-client-secret.sh"


