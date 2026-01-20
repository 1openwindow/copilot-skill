# MCP Configuration Skill for SharePoint and OneDrive

This skill guides users through configuring an MCP server with OAuth identity passthrough for SharePoint and OneDrive access on a Foundry agent.

## Prerequisites
- Azure AI User Role or higher
- Access to Azure Portal for Microsoft Entra app registration
- Access to Foundry portal
- Frontier tenant (for Agent 365 MCP servers)

## Configuration Steps

### Step 1: Create Microsoft Entra App Registration
1. Navigate to Azure Portal > Microsoft Entra ID > App registrations
2. Click "New registration"
3. Provide a name for your app
4. Select supported account types
5. Click "Register"
6. **Save the Application (client) ID** - you'll need this later

### Step 2: Create Client Secret
1. In your app registration, go to "Certificates & secrets"
2. Click "New client secret"
3. Add a description and set expiration
4. Click "Add"
5. **Save the secret value immediately** - it won't be shown again

### Step 3: Grant API Permissions
1. Go to "Manage" > "API Permissions"
2. Click "Add a permission"
3. Search for "Agent 365 Tools" or use the API ID: `ea9ffc3e-8a23-4a7d-836d-234d7c7565c1`
4. Select the permission: `McpServers.OneDriveSharepoint.All`
5. Click "Add permissions"
6. Click "Grant admin consent for [your tenant]"

### Step 4: Configure MCP Server in Foundry Portal
1. Open Foundry portal and navigate to your agent
2. Click "Connect a tool"
3. Select "Custom" > "MCP"
4. Fill in the configuration:
   - **Name**: SharePoint and OneDrive MCP
   - **MCP server endpoint**: [Your MCP server endpoint]
   - **Authentication**: OAuth Identity Passthrough
   - **Client ID**: [From Step 1]
   - **Client Secret**: [From Step 2]
   - **Token URL**: `https://login.microsoftonline.com/{tenantId}/oauth2/v2.0/token`
   - **Auth URL**: `https://login.microsoftonline.com/{tenantId}/oauth2/v2.0/authorize`
   - **Refresh URL**: `https://login.microsoftonline.com/{tenantId}/oauth2/v2.0/token`
   - **Scopes**: `ea9ffc3e-8a23-4a7d-836d-234d7c7565c1/McpServers.OneDriveSharepoint.All`

   Replace `{tenantId}` with your Azure tenant ID

5. Click "Save" or "Connect"
6. **Copy the redirect URL** that is generated

### Step 5: Add Redirect URL to App Registration
1. Return to Azure Portal > Your app registration
2. Go to "Authentication"
3. Click "Add a platform"
4. Select "Web"
5. Paste the redirect URL from Step 4
6. Click "Configure"

### Step 6: Test the Configuration
1. Interact with your Foundry agent
2. The first time, you'll receive a consent link
3. Click the link and sign in with your Microsoft account
4. Grant the requested permissions
5. The agent should now be able to access SharePoint and OneDrive on your behalf

## Important Notes
- OAuth credentials are stored securely and scoped to each user and agent
- Access tokens typically expire after 1 hour
- Refresh tokens are used to obtain new access tokens automatically
- Users can revoke access at any time through their account settings

## Troubleshooting
- **Consent link not appearing**: Check that users have Azure AI User Role
- **Permission errors**: Verify admin consent was granted in Step 3
- **Authentication failures**: Ensure redirect URL in Step 5 matches exactly
- **Token URL errors**: Verify tenant ID is correct in all URLs
