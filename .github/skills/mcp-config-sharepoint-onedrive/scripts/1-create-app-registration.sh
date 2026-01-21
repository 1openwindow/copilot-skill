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

# Check jq
if ! command -v jq &> /dev/null; then
    echo "❌ jq not installed."
    echo "Install: brew install jq (Mac) or apt-get install jq (Linux)"
    exit 1
fi

# Save config to agent-dev-meta directory
CONFIG_DIR="$HOME/.agent-dev-meta"
CONFIG_FILE="$CONFIG_DIR/.mcp-sharepoint-config.json"

# Create config directory if it doesn't exist
mkdir -p "$CONFIG_DIR"

# Check if config file already exists
if [ -f "$CONFIG_FILE" ]; then
    echo "⚠️  Existing configuration found!"
    echo ""
    
    EXISTING_CLIENT_ID=$(jq -r '.clientId' "$CONFIG_FILE" 2>/dev/null || echo "")
    EXISTING_TENANT_ID=$(jq -r '.tenantId' "$CONFIG_FILE" 2>/dev/null || echo "")
    
    if [ -n "$EXISTING_CLIENT_ID" ] && [ "$EXISTING_CLIENT_ID" != "null" ]; then
        # Verify if the app still exists in Azure AD
        if az ad app show --id "$EXISTING_CLIENT_ID" &> /dev/null; then
            echo "Found existing app registration:"
            echo "• Client ID: $EXISTING_CLIENT_ID"
            echo "• Tenant ID: $EXISTING_TENANT_ID"
            echo ""
            echo "What would you like to do?"
            echo "1) Use existing app (recommended)"
            echo "2) Create new app"
            echo ""
            read -p "Enter your choice (1 or 2): " CHOICE
            
            case $CHOICE in
                1)
                    echo ""
                    echo "✅ Using existing app registration!"
                    echo ""
                    cat "$CONFIG_FILE" | jq .
                    echo ""
                    echo "💾 Config location: $CONFIG_FILE"
                    echo ""
                    echo "Next: ./scripts/2-create-client-secret.sh"
                    exit 0
                    ;;
                2)
                    echo ""
                    echo "Creating new app registration..."
                    echo "(Old config will be overwritten)"
                    echo ""
                    ;;
                *)
                    echo "❌ Invalid choice. Exiting."
                    exit 1
                    ;;
            esac
        else
            echo "⚠️  Config file exists but app not found in Azure AD."
            echo "The app may have been deleted. Creating new app..."
            echo ""
        fi
    fi
fi

echo "Creating app registration..."
echo ""

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


