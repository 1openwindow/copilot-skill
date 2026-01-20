# MCP Configuration Skill

An interactive skill for configuring Model Context Protocol (MCP) servers with OAuth identity passthrough on Foundry agents, specifically for Microsoft SharePoint and OneDrive access.

## Overview

This skill provides a guided, step-by-step process for:
- Creating Microsoft Entra app registrations
- Configuring OAuth permissions
- Setting up MCP servers in Foundry portal
- Managing redirect URLs
- Testing the configuration

## Files

- `mcp-config-skill.sh` - Interactive bash script that guides you through the configuration
- `mcp-config-skill.md` - Detailed documentation with all steps and troubleshooting

## Quick Start

Run the interactive script:

```bash
./mcp-config-skill.sh
```

The script will guide you through each step and save your configuration details.

## Prerequisites

Before running this skill, ensure you have:

1. **Azure AI User Role** or higher
2. **Access to Azure Portal** with permissions to:
   - Create app registrations in Microsoft Entra ID
   - Grant admin consent for API permissions
3. **Access to Foundry portal** with permissions to configure agents
4. **Frontier tenant** (required for Agent 365 MCP servers)

## What This Skill Configures

This skill configures access to **SharePoint and OneDrive** using:

- **Permission**: `McpServers.OneDriveSharepoint.All`
- **API ID**: `ea9ffc3e-8a23-4a7d-836d-234d7c7565c1`
- **Authentication**: OAuth Identity Passthrough

## Configuration Steps

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

## Output

The script generates:
- Interactive guidance through each step
- A configuration file with your settings: `mcp-config-YYYYMMDD-HHMMSS.txt`
- Color-coded instructions for easy following

## Security Notes

- Client secrets are **not** saved to configuration files
- OAuth credentials are stored securely by Foundry Agent Service
- Credentials are scoped per-user and per-agent
- Access tokens expire after ~1 hour (automatically refreshed)
- Users can revoke access anytime through their Microsoft account settings

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Consent link not appearing | Verify users have Azure AI User Role |
| Permission errors | Ensure admin consent was granted in Azure Portal |
| Authentication failures | Check redirect URL matches exactly |
| Token URL errors | Verify tenant ID is correct in all URLs |

## Additional MCP Servers

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
- Foundry Agent Service Documentation

## License

This skill is provided as-is for educational and configuration purposes.
