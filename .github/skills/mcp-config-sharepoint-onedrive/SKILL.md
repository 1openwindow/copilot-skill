---
name: mcp-config-sharepoint-onedrive
description: Configure MCP server with OAuth for SharePoint/OneDrive access on Foundry agents. Use when asked to set up SharePoint/OneDrive MCP integration.
---

# MCP SharePoint/OneDrive Configuration

Guides users through connecting SharePoint/OneDrive to Foundry agents via OAuth identity passthrough.

## How to Help Users

### Initial Response
"I'll help you connect SharePoint/OneDrive to your Foundry agent. Takes ~5 minutes. Quick check: Can you (or your admin) grant admin consent in Azure Entra ID?"

### Execution Approach
**Execute scripts interactively step-by-step:**
1. Explain what this step does (1-2 sentences)
2. Ask: "Ready to run this?"
3. Execute script with bash tool
4. Highlight key outputs (Client ID, secret, etc.)
5. Move to next step

**Don't:** Dump all scripts for manual copy-paste.

## Script Execution Flow

### Prerequisites Check
Before starting, verify:
- `az --version` (Azure CLI installed)
- `jq --version` (JSON parser installed)
- `az account show` (logged in)

If missing, guide installation first.

### Step-by-Step Scripts

**Step 1: Create App Registration**
- Script: `./scripts/1-create-app-registration.sh`
- Does: Checks for existing app, creates Entra app if needed, saves Client ID and Tenant ID
- User action: If existing app found, choose to reuse or create new

**Step 2: Create Client Secret**
- Script: `./scripts/2-create-client-secret.sh`
- Does: Generates 24-month secret
- User action: **Copy the secret immediately!**

**Step 3: Grant Permissions** (Automated with fallback)
- Script: `./scripts/3-grant-permissions.sh`
- Does: Looks up permission, adds it, attempts admin consent
- User action: None if you have Global Admin role, otherwise ask admin to grant consent

**Step 4: Generate Foundry Config**
- Script: `./scripts/4-generate-foundry-config.sh`
- Does: Outputs formatted config values
- User action: Copy values into Foundry portal

**Step 5: Add Redirect URL**
- Script: `./scripts/5-add-redirect-url.sh`
- Does: Adds Foundry redirect URL to app
- User action: Paste redirect URL when prompted
- Final output: Show the completion message with next steps to the user

## Example Interaction

```
User: "I need SharePoint access for my agent"

Copilot: "I'll help! Takes ~5 minutes. Can you grant admin consent?"

User: "Yes"

Copilot: "Perfect! I'll run automated scripts step-by-step.

**Step 1 of 5: Create App Registration**
Creates Entra app and saves your Client ID/Tenant ID.
Ready to run?"

User: "Yes"

Copilot: [Executes script 1]
"✅ Done!
• Client ID: abc-123-...
• Tenant ID: xyz-789-...

**Step 2 of 5: Create Client Secret**
Generates secret (24mo expiry). ⚠️ Copy it immediately!
Ready?"

User: "Yes"

Copilot: [Executes script 2]
"✅ Done! Secret: [displays secret]

**Step 3 of 5: Grant API Permissions**
Adds SharePoint/OneDrive permission and grants admin consent.
Ready?"

User: "Yes"

Copilot: [Executes script 3]
"✅ Permission added and admin consent granted!

**Step 4 of 5: Generate Foundry Config**
Outputs all values for Foundry portal.
Ready?"

User: "Yes"

Copilot: [Executes script 4]
"✅ Done! Here are the exact values to paste into Foundry (copy-ready):
[pastes the formatted config block from the script output]"

**Step 5 of 5: Add Redirect URL**
After saving the config in Foundry, copy the redirect URL and paste it here.
Ready?"

User: "Yes"

Copilot: [Executes script 5 and shows completion message]
"✅ Redirect URL added!

════════════════════════════════════════
🎉 Configuration Complete!
════════════════════════════════════════

Next: Add this tool to your agent

1. Go to: https://ai.azure.com
2. Select your agent
3. Click 'Tools' or find the tools section
4. Add the 'SharePoint and OneDrive' tool
5. Test it by asking: 'List my recent 3 documents on OneDrive'
6. First time: Click consent link and sign in
7. Done! Your agent can now access SharePoint/OneDrive"
```

## Troubleshooting

**"Consent link not showing"**
→ Check Azure AI User role, refresh agent chat

**"Permission denied"**
→ Verify admin consent was granted in Step 3

**"Auth failed"**
→ Redirect URL must match exactly

**"Invalid tenant"**
→ Check tenant ID in all three URLs

**"Can't grant admin consent"**
→ Ask Global Administrator to complete Step 3

## Manual Portal Steps (If Scripts Not Available)

If user prefers manual or Azure CLI unavailable, provide these portal instructions:

1. **Azure Portal** → Microsoft Entra ID → App registrations → New registration
   - Name: "Foundry Agent SharePoint"
   - Single tenant → Register
   - Copy Client ID and Tenant ID

2. **Certificates & secrets** → New client secret
   - 24 month expiry → Copy secret value

3. **API permissions** → Add permission
   - Search: `ea9ffc3e-8a23-4a7d-836d-234d7c7565c1`
   - Select: `McpServers.OneDriveSharepoint.All`
   - Grant admin consent

4. **Foundry portal** → Agent → Tools → Connect a tool → Custom MCP
   - Name: SharePoint and OneDrive
   - **Remote MCP Server endpoint**: `https://agent365.svc.cloud.microsoft/agents/servers/mcp_ODSPRemoteServer`
   - Auth: OAuth Identity Passthrough
   - Client ID/Secret: from above
   - Token URL: `https://login.microsoftonline.com/{tenantId}/oauth2/v2.0/token`
   - Auth URL: `https://login.microsoftonline.com/{tenantId}/oauth2/v2.0/authorize`
   - Refresh URL: Same as Token URL
   - Scopes: `ea9ffc3e-8a23-4a7d-836d-234d7c7565c1/McpServers.OneDriveSharepoint.All`
   - Copy redirect URL after saving

5. **Azure Portal** → App → Authentication → Add platform → Web
   - Paste redirect URL → Configure

## Additional MCP Servers

Same process, different permissions (all use API ID `ea9ffc3e-8a23-4a7d-836d-234d7c7565c1`):
- Outlook Mail: `McpServers.Mail.All`
- Calendar: `McpServers.Calendar.All`
- Teams: `McpServers.Teams.All`
- Word: `McpServers.Word.All`

## Security Notes
- Secrets never committed to code
- OAuth creds stored securely by Foundry
- Per-user, per-agent scoping
- Tokens auto-refresh
- Users can revoke access anytime
