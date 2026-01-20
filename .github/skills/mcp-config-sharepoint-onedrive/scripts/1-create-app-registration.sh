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

# Create app
az ad app create \
  --display-name "Foundry Agent SharePoint" \
  --sign-in-audience AzureADMyOrg \
  --query "{clientId:appId}" \
  -o json > entra-app-config.json

# Add tenant ID
TENANT_ID=$(az account show --query tenantId -o tsv)
jq --arg tid "$TENANT_ID" '. + {tenantId: $tid}' entra-app-config.json > temp.json
mv temp.json entra-app-config.json

echo "✅ App created!"
echo ""
cat entra-app-config.json | jq .
echo ""
echo "Next: ./scripts/2-create-client-secret.sh"

