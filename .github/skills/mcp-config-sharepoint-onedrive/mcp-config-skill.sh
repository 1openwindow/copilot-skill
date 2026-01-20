#!/bin/bash

# MCP Configuration Skill for SharePoint and OneDrive
# Interactive guide for configuring OAuth identity passthrough on Foundry Agent

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "\n${BLUE}===================================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}===================================================================${NC}\n"
}

# Function to print info
print_info() {
    echo -e "${GREEN}ℹ${NC} $1"
}

# Function to print warnings
print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to wait for user
wait_for_user() {
    echo -e "\n${YELLOW}Press Enter to continue...${NC}"
    read
}

# Function to get user input
get_input() {
    local prompt="$1"
    local var_name="$2"
    echo -e "${GREEN}?${NC} $prompt"
    read -r $var_name
}

# Main script
clear
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   MCP Configuration Skill for SharePoint and OneDrive         ║${NC}"
echo -e "${BLUE}║   Configure OAuth Identity Passthrough on Foundry Agent       ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"

print_info "This skill will guide you through configuring an MCP server"
print_info "for SharePoint and OneDrive access on your Foundry agent."
print_warning "Prerequisites:"
echo "  - Azure AI User Role or higher"
echo "  - Access to Azure Portal (Microsoft Entra ID)"
echo "  - Access to Foundry portal"
echo "  - Frontier tenant"
wait_for_user

# Step 1: Create Entra App
print_header "Step 1: Create Microsoft Entra App Registration"
print_info "Instructions:"
echo "1. Open Azure Portal: https://portal.azure.com"
echo "2. Navigate to: Microsoft Entra ID > App registrations"
echo "3. Click 'New registration'"
echo "4. Enter a name (e.g., 'Foundry Agent SharePoint MCP')"
echo "5. Select account types (usually 'Single tenant')"
echo "6. Click 'Register'"
wait_for_user

get_input "Enter the Application (client) ID from the app registration:" CLIENT_ID
get_input "Enter your Azure Tenant ID:" TENANT_ID
print_info "✓ Client ID saved: $CLIENT_ID"
print_info "✓ Tenant ID saved: $TENANT_ID"

# Step 2: Create Client Secret
print_header "Step 2: Create Client Secret"
print_info "Instructions:"
echo "1. In your app registration, go to 'Certificates & secrets'"
echo "2. Click 'New client secret'"
echo "3. Add a description (e.g., 'Foundry MCP Secret')"
echo "4. Set expiration period"
echo "5. Click 'Add'"
print_warning "IMPORTANT: Copy the secret VALUE immediately - it won't be shown again!"
wait_for_user

get_input "Enter the Client Secret value:" CLIENT_SECRET
print_info "✓ Client secret saved (hidden)"

# Step 3: Grant Permissions
print_header "Step 3: Grant API Permissions"
print_info "Instructions:"
echo "1. Go to 'Manage' > 'API Permissions'"
echo "2. Click 'Add a permission'"
echo "3. Search for 'Agent 365 Tools'"
echo "   If not found, search for: ea9ffc3e-8a23-4a7d-836d-234d7c7565c1"
echo "4. Select permission: McpServers.OneDriveSharepoint.All"
echo "5. Click 'Add permissions'"
echo "6. Click 'Grant admin consent for [your tenant]'"
print_warning "Admin consent is required for the permission to work!"
wait_for_user

# Step 4: Configure Foundry Portal
print_header "Step 4: Configure MCP Server in Foundry Portal"
print_info "Configuration values to use:"
echo ""
echo "Name: SharePoint and OneDrive MCP"
echo "Authentication: OAuth Identity Passthrough"
echo ""
echo -e "${GREEN}Client ID:${NC} $CLIENT_ID"
echo -e "${GREEN}Client Secret:${NC} [Your secret value]"
echo ""
echo -e "${GREEN}Token URL:${NC}"
echo "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token"
echo ""
echo -e "${GREEN}Auth URL:${NC}"
echo "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/authorize"
echo ""
echo -e "${GREEN}Refresh URL:${NC}"
echo "https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token"
echo ""
echo -e "${GREEN}Scopes:${NC}"
echo "ea9ffc3e-8a23-4a7d-836d-234d7c7565c1/McpServers.OneDriveSharepoint.All"
echo ""
print_info "Instructions:"
echo "1. Open Foundry portal and navigate to your agent"
echo "2. Click 'Connect a tool'"
echo "3. Select 'Custom' > 'MCP'"
echo "4. Fill in the values shown above"
echo "5. Click 'Save' or 'Connect'"
echo "6. COPY the redirect URL that is generated"
wait_for_user

get_input "Enter the Redirect URL provided by Foundry:" REDIRECT_URL
print_info "✓ Redirect URL saved: $REDIRECT_URL"

# Step 5: Add Redirect URL
print_header "Step 5: Add Redirect URL to App Registration"
print_info "Instructions:"
echo "1. Return to Azure Portal > Your app registration"
echo "2. Go to 'Authentication'"
echo "3. Click 'Add a platform'"
echo "4. Select 'Web'"
echo "5. Paste this Redirect URL:"
echo -e "   ${GREEN}$REDIRECT_URL${NC}"
echo "6. Click 'Configure'"
wait_for_user

# Step 6: Test
print_header "Step 6: Test the Configuration"
print_info "Instructions:"
echo "1. Interact with your Foundry agent"
echo "2. You should receive a consent link (first time)"
echo "3. Click the link and sign in with your Microsoft account"
echo "4. Grant the requested permissions"
echo "5. The agent should now access SharePoint and OneDrive"
wait_for_user

# Summary
print_header "Configuration Complete!"
print_info "Summary of your configuration:"
echo ""
echo -e "${GREEN}Application (Client) ID:${NC} $CLIENT_ID"
echo -e "${GREEN}Tenant ID:${NC} $TENANT_ID"
echo -e "${GREEN}Permission:${NC} McpServers.OneDriveSharepoint.All"
echo -e "${GREEN}Redirect URL:${NC} $REDIRECT_URL"
echo ""
print_info "Your MCP server is now configured for SharePoint and OneDrive access!"
print_warning "Important notes:"
echo "  - OAuth credentials are stored securely per user and agent"
echo "  - Access tokens expire after ~1 hour (automatically refreshed)"
echo "  - Users can revoke access anytime through account settings"
echo ""
print_info "For troubleshooting, refer to: mcp-config-skill.md"

# Save configuration to file
CONFIG_FILE="mcp-config-$(date +%Y%m%d-%H%M%S).txt"
cat > "$CONFIG_FILE" <<EOF
MCP Configuration for SharePoint and OneDrive
Generated: $(date)
================================================

Application (Client) ID: $CLIENT_ID
Tenant ID: $TENANT_ID
Redirect URL: $REDIRECT_URL

Token URL: https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token
Auth URL: https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/authorize
Refresh URL: https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token
Scopes: ea9ffc3e-8a23-4a7d-836d-234d7c7565c1/McpServers.OneDriveSharepoint.All

Permission: McpServers.OneDriveSharepoint.All
EOF

print_info "Configuration saved to: $CONFIG_FILE"
print_warning "Note: Client secret is NOT saved in this file for security"
echo ""
