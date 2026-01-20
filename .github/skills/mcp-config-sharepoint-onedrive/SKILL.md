---
name: mcp-config-sharepoint-onedrive
description: Configure MCP server with OAuth identity passthrough for Microsoft SharePoint and OneDrive access on Foundry agents. Use this when asked to set up, configure, or debug MCP servers for SharePoint or OneDrive integration.
---

# MCP Configuration for SharePoint and OneDrive

This skill provides a step-by-step guide for configuring an MCP server with OAuth identity passthrough to enable SharePoint and OneDrive access on Foundry agents.

## When to Use This Skill

Use this skill when:
- Setting up SharePoint or OneDrive integration with Foundry agents
- Configuring OAuth identity passthrough for MCP servers
- Debugging authentication issues with Microsoft 365 MCP servers
- Creating Microsoft Entra app registrations for MCP

## Pre-Configuration Checks

### Step 0: Verify Prerequisites and Agent Setup

Before starting the configuration, perform these checks:

#### Check 1: Verify Foundry Agent Exists
Ask the user: "Do you have an existing Foundry agent you want to configure, or would you like me to guide you through creating a new agent first?"

- If **NO agent exists**, offer to:
  1. Guide them through creating a new agent in Foundry portal
  2. Help set up basic agent configuration (name, model, system message)
  3. Then proceed with MCP configuration
  
- If **agent exists**, confirm the agent name and proceed to prerequisites check

#### Check 2: Verify Account Prerequisites
Help the user verify they have the required access by asking them to check:

1. **Azure AI User Role or Higher**
   - Ask: "Can you access Azure AI Foundry portal at https://ai.azure.com?"
   - Ask: "Can you view and configure agents in the portal?"
   - If NO: They need to request Azure AI User role from their admin

2. **Azure Portal Access for Entra ID**
   - Ask: "Can you access Azure Portal at https://portal.azure.com?"
   - Ask: "Can you navigate to Microsoft Entra ID > App registrations?"
   - Ask: "Can you create new app registrations?"
   - If NO: They need app registration creation permissions

3. **Admin Consent Permissions**
   - Ask: "Are you a Global Administrator, or can you request admin consent from one?"
   - Note: Admin consent is required to grant API permissions
   - If NO: They'll need to work with their Global Administrator

4. **Frontier Tenant (Agent 365 MCP)**
   - Ask: "Are you on a Frontier tenant for Agent 365 MCP servers?"
   - Note: This is specifically required for Agent 365 MCP servers
   - If unsure: They should check with their Azure administrator

#### Check 3: Foundry Portal Access
- Ask: "Can you access Foundry portal and configure tools on your agent?"
- Ask: "What is the name of the agent you want to configure?"
- Document the agent name for reference during configuration

**Important**: If any prerequisite checks fail, pause the configuration and help the user resolve access issues first before proceeding.

## Configuration Process

### Step 1: Create Microsoft Entra App Registration
1. Navigate to Azure Portal > Microsoft Entra ID > App registrations
2. Click "New registration"
3. Provide a name (e.g., "Foundry Agent SharePoint MCP")
4. Select supported account types (usually "Single tenant")
5. Click "Register"
6. **Save the Application (client) ID** - needed for Step 4

### Step 2: Create Client Secret
1. In your app registration, go to "Certificates & secrets"
2. Click "New client secret"
3. Add a description (e.g., "Foundry MCP Secret")
4. Set expiration period
5. Click "Add"
6. **Save the secret value immediately** - it won't be shown again

### Step 3: Grant API Permissions
1. Go to "Manage" > "API Permissions"
2. Click "Add a permission"
3. Search for "Agent 365 Tools" or use API ID: `ea9ffc3e-8a23-4a7d-836d-234d7c7565c1`
4. Select the permission: `McpServers.OneDriveSharepoint.All`
5. Click "Add permissions"
6. Click "Grant admin consent for [your tenant]"
7. **Admin consent is required** for the permission to work

### Step 4: Configure MCP Server in Foundry Portal
1. Open Foundry portal and navigate to your agent
2. Click "Connect a tool"
3. Select "Custom" > "MCP"
4. Fill in the configuration:
   - **Name**: SharePoint and OneDrive MCP
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

## Interactive Script

An interactive bash script is available at `mcp-config-skill.sh` that guides you through the configuration process with color-coded prompts and saves configuration details.

Run it with:
```bash
./mcp-config-skill.sh
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Consent link not appearing | Verify users have Azure AI User Role |
| Permission errors | Ensure admin consent was granted in Step 3 |
| Authentication failures | Check redirect URL in Step 5 matches exactly |
| Token URL errors | Verify tenant ID is correct in all URLs |

## Security Notes

- Client secrets should **never** be committed to version control
- OAuth credentials are stored securely by Foundry Agent Service
- Credentials are scoped per-user and per-agent
- Access tokens expire after ~1 hour (automatically refreshed via refresh token)
- Users can revoke access anytime through their Microsoft account settings

## Additional MCP Servers

This skill focuses on SharePoint and OneDrive. To configure other Agent 365 MCP servers, use these permissions with the same API ID (`ea9ffc3e-8a23-4a7d-836d-234d7c7565c1`):

- Outlook Mail: `McpServers.Mail.All`
- Outlook Calendar: `McpServers.Calendar.All`
- Teams: `McpServers.Teams.All`
- User Profile: `McpServers.Me.All`
- SharePoint Lists: `McpServers.SharepointLists.All`
- Word: `McpServers.Word.All`
- Copilot Search: `McpServers.CopilotMCP.All`
- Admin Center: `McpServers.M365Admin.All`
- Dataverse: `McpServers.Dataverse.All`

## OAuth Identity Passthrough

This configuration uses **OAuth identity passthrough**, which:
- Prompts users to sign in and grant permissions
- Securely stores user credentials within Foundry Agent Service
- Uses user credentials only for MCP server communication
- Limits access based on specified scopes
- Maintains separate credentials for each user-agent pair

### Token Types
- **Access Token**: Short-lived (typically 1 hour), used to call APIs
- **Refresh Token**: Long-lived, used to obtain new access tokens

## References

- [Microsoft Entra App Registration Guide](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app)
- [OAuth 2.0 Documentation](https://oauth.net/2/)
- Agent 365 Tools API ID: `ea9ffc3e-8a23-4a7d-836d-234d7c7565c1`
