# Foundry Agent Skills

A collection of interactive skills for working with Azure Foundry agents.

## Overview

This repository contains skills for:

### 1. MCP Configuration (SharePoint/OneDrive)
Located in: `.github/skills/foundry-mcp-config/`

Provides a guided, step-by-step process for:
- Creating Microsoft Entra app registrations
- Configuring OAuth permissions
- Setting up MCP servers in Foundry portal
- Managing redirect URLs
- Testing the configuration

### 2. Foundry Agent Teams App
Located in: `.github/skills/foundry-teams-app/`

Guides setup of a Teams app for debugging and previewing Foundry agents:
- Clone Teams app template
- Configure Foundry agent connection
- Enable F5 debugging in VS Code
- Test agents in Microsoft Teams

## Prerequisites

### For MCP Configuration

Before running this skill, ensure you have:

1. **Azure AI User Role** or higher
2. **Access to Azure Portal** with permissions to:
   - Create app registrations in Microsoft Entra ID
   - Grant admin consent for API permissions
3. **Access to Foundry portal** with permissions to configure agents
4. **Frontier tenant** (required for Agent 365 MCP servers)

### For Foundry Agent Teams App

1. **Git** installed
2. **VS Code** with Microsoft 365 Agents Toolkit extension
3. **Node.js** (required by Microsoft 365 Agents Toolkit)
4. **Foundry agent** already created and configured

## MCP Configuration Details

### What This Skill Configures

This skill configures access to **SharePoint and OneDrive** using:

- **Permission**: `McpServers.OneDriveSharepoint.All`
- **API ID**: `ea9ffc3e-8a23-4a7d-836d-234d7c7565c1`
- **Authentication**: OAuth Identity Passthrough

### Configuration Steps

The skill guides you through:

1. **Create Microsoft Entra App Registration**
   - Register a new application
   - Obtain Client ID

2. **Create Client Secret**
   - Generate a secret for authentication
   - Store securely

3. **Grant API Permissions**
   - Add Agent 365 Tools API permissions
   - Grant admin consent for SharePoint/OneDrive access

4. **Configure MCP Server in Foundry**
   - Set up OAuth identity passthrough
   - Configure endpoints (token, auth, refresh URLs)
   - Define scopes

5. **Add Redirect URL**
   - Add Foundry's redirect URL to your Entra app
   - Enable authentication flow

6. **Test Configuration**
   - Interact with your agent
   - Complete user consent
   - Verify access

### Output

The script generates:
- Interactive guidance through each step
- A configuration file with your settings: `~/.agent-dev-meta/.mcp-sharepoint-config.json`
- Color-coded instructions for easy following

### Security Notes

- Client secrets are **not** saved to configuration files
- OAuth credentials are stored securely by Foundry Agent Service
- Credentials are scoped per-user and per-agent
- Access tokens expire after ~1 hour (automatically refreshed)
- Users can revoke access anytime through their Microsoft account settings

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Consent link not appearing | Verify users have Azure AI User Role |
| Permission errors | Ensure admin consent was granted in Azure Portal |
| Authentication failures | Check redirect URL matches exactly |
| Token URL errors | Verify tenant ID is correct in all URLs |

### Additional MCP Servers

This skill focuses on SharePoint and OneDrive. To configure other Agent 365 MCP servers, use these permissions:

- Outlook Mail: `McpServers.Mail.All`
- Outlook Calendar: `McpServers.Calendar.All`
- Teams: `McpServers.Teams.All`
- User Profile: `McpServers.Me.All`
- SharePoint Lists: `McpServers.SharepointLists.All`
- Word: `McpServers.Word.All`
- Copilot Search: `McpServers.CopilotMCP.All`
- Admin Center: `McpServers.M365Admin.All`
- Dataverse: `McpServers.Dataverse.All`

### OAuth Identity Passthrough

This configuration uses **OAuth identity passthrough**, which:

- Prompts users to sign in and grant permissions
- Securely stores user credentials within Foundry Agent Service
- Uses user credentials only for MCP server communication
- Limits access based on specified scopes
- Maintains separate credentials for each user-agent pair

#### Token Types

- **Access Token**: Short-lived (typically 1 hour), used to call APIs
- **Refresh Token**: Long-lived, used to obtain new access tokens

---

## Foundry Agent Teams App Details

This skill helps you set up a Microsoft Teams app to test and debug your Foundry agents locally.

### What It Does

1. **Clones Template**: Gets the latest Teams app template from GitHub
2. **Configures Agent**: Sets up your Foundry project endpoint and agent name
3. **Enables Debugging**: Allows F5 debugging in VS Code with Microsoft 365 Agents Toolkit

### Setup Process

The automated script (`setup.sh`) will:
- Clone the repository to `foundry_agent_teams_app/`
- Prompt for your Foundry endpoint and agent name
- Create configuration files
- Display next steps for VS Code

### After Setup

1. Open the project in VS Code
2. Press **F5** to start debugging
3. Teams will launch with your agent
4. Test your agent interactions in Teams chat

### Troubleshooting

| Issue | Solution |
|-------|----------|
| Clone fails | Check Git installation and internet connection |
| Agent not responding | Verify Foundry endpoint and agent name |
| F5 doesn't work | Install Microsoft 365 Agents Toolkit extension in VS Code |
| Authentication error | Check Foundry agent OAuth configuration |

---

## References

- [Microsoft Entra App Registration Guide](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app)
- [OAuth 2.0 Documentation](https://oauth.net/2/)
- Foundry Agent Service Documentation

## License

This skill is provided as-is for educational and configuration purposes.
