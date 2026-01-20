#!/bin/bash
set -e

# Step 1: Create Entra App Registration
# ======================================
# This script creates a new Microsoft Entra app registration for your Foundry agent
# and retrieves the Client ID and Tenant ID needed for OAuth configuration.
#
# What it does:
# 1. Creates app registration named "Foundry Agent SharePoint"
# 2. Configures it for single-tenant (your organization only)
# 3. Saves Client ID and Tenant ID to entra-app-config.json
#
# Requirements:
# - Azure CLI installed and logged in (az login)
# - Permission to create app registrations

echo "============================================"
echo "Step 1: Create Entra App Registration"
echo "============================================"
echo ""
echo "This will create a new app registration in Microsoft Entra ID."
echo ""

# Check if Azure CLI is installed
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI is not installed."
    echo "Install it from: https://docs.microsoft.com/cli/azure/install-azure-cli"
    exit 1
fi

# Check if logged in
if ! az account show &> /dev/null; then
    echo "❌ Not logged in to Azure CLI."
    echo "Run: az login"
    exit 1
fi

echo "Creating app registration..."
echo ""

# Create the app registration
az ad app create \
  --display-name "Foundry Agent SharePoint" \
  --sign-in-audience AzureADMyOrg \
  --query "{clientId:appId}" \
  -o json > entra-app-config.json

# Get tenant ID
TENANT_ID=$(az account show --query tenantId -o tsv)

# Add tenant ID to config
jq --arg tid "$TENANT_ID" '. + {tenantId: $tid}' entra-app-config.json > temp.json
mv temp.json entra-app-config.json

echo "✅ App registration created successfully!"
echo ""
echo "📋 Your configuration:"
cat entra-app-config.json | jq .
echo ""
echo "💾 Configuration saved to: entra-app-config.json"
echo ""
echo "Next step: Run ./scripts/2-create-client-secret.sh"
