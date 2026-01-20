---
name: mcp-config-sharepoint-onedrive
description: Configure MCP server with OAuth identity passthrough for Microsoft SharePoint and OneDrive access on Foundry agents. Use this when asked to set up, configure, or debug MCP servers for SharePoint or OneDrive integration.
---

# MCP Configuration for SharePoint and OneDrive

This skill guides users through connecting SharePoint/OneDrive to their Foundry agent using OAuth identity passthrough.

## Conversation Flow Guidelines

**Be conversational, friendly, and minimize questions.** Guide users step-by-step through portal actions with clear instructions.

### Initial Response

When a user says they want SharePoint/OneDrive access for their agent:

1. **Acknowledge and reassure**: "I'll help you connect SharePoint/OneDrive to your Foundry agent. This takes about 5 minutes."

2. **Assume defaults** (don't ask unless needed):
   - Assume they have a Foundry agent already
   - Assume they have basic Azure portal access
   - Only ask critical blocking questions

3. **Ask ONE question maximum upfront**:
   - "Quick check: Can you (or your admin) grant admin consent in Azure Entra ID? This is the only permission that might need admin help."
   - If YES → Proceed with full instructions
   - If NO → Tell them: "You'll need a Global Administrator for one step (granting consent). Let's start the setup, and I'll highlight when to involve them."

4. **Provide complete step-by-step instructions immediately** - don't make them ask for each step.

5. **Offer script automation**: After explaining what needs to be done, offer: "Would you like me to provide a script to help with this step? You can review what it does before running it."

## Instruction Style

### ✅ DO:
- Give clear portal paths: "Open Azure Portal → Microsoft Entra ID → App registrations"
- Provide exact values to copy/paste when possible
- Use action verbs: "Click", "Navigate to", "Copy", "Paste"
- Show progress: "Step 1 of 6", "Almost done!"
- Provide specific field names and values
- Give context only when it helps: "(This lets your agent access SharePoint as you)"
- **Offer automated scripts** for steps that can be scripted (Azure CLI, PowerShell)
- **Explain what each script does** before running it

### ❌ DON'T:
- Ask unnecessary verification questions
- Use technical jargon without context
- Give incomplete instructions that require follow-up
- Make users confirm they completed each step
- Ask about prerequisites one by one
- Run scripts without explaining what they do first

## Complete Configuration Steps

Present these steps in a friendly, complete format. Users should be able to follow through without asking for more details.

### Example Response Format

"I'll help you connect SharePoint/OneDrive to your Foundry agent. This takes about 5 minutes. Quick check: Can you (or your admin) grant admin consent in Azure Entra ID?"

[Wait for response, then provide ALL steps:]

**Step 1 of 6: Create Entra App Registration**

Open Azure Portal → Microsoft Entra ID → App registrations
1. Click **"New registration"**
2. Name: `Foundry Agent SharePoint` (or any name you like)
3. Supported account types: **Single tenant**
4. Click **"Register"**
5. Copy the **Application (client) ID** - keep this handy

**Step 2 of 6: Get Your Tenant ID**

While still in your app registration:
1. Look for **Directory (tenant) ID** on the overview page
2. Copy this value - you'll need it in Step 4

**Step 3 of 6: Create Client Secret**

In your app registration:
1. Go to **"Certificates & secrets"**
2. Click **"New client secret"**
3. Description: `Foundry MCP`
4. Expiration: Choose your preference (recommend 12-24 months)
5. Click **"Add"**
6. **Copy the secret Value immediately** (it won't show again!)

**Step 4 of 6: Grant API Permissions** ⚠️ (Admin consent needed here)

1. Go to **"API permissions"**
2. Click **"Add a permission"** → **"APIs my organization uses"**
3. Search for: `ea9ffc3e-8a23-4a7d-836d-234d7c7565c1`
4. Select **"Agent 365 Tools"**
5. Check **`McpServers.OneDriveSharepoint.All`**
6. Click **"Add permissions"**
7. Click **"Grant admin consent for [Your Org]"** (requires Global Admin)
8. Confirm when prompted

**Step 5 of 6: Configure MCP Tool in Foundry**

Open https://ai.azure.com → your agent
1. Click **"Connect a tool"** → **"Custom"** → **"MCP"**
2. Fill in these exact values:

```
Name: SharePoint and OneDrive

Authentication: OAuth Identity Passthrough

Client ID: [paste your Client ID from Step 1]
Client Secret: [paste your secret from Step 3]

Token URL: https://login.microsoftonline.com/[YOUR-TENANT-ID]/oauth2/v2.0/token
Auth URL: https://login.microsoftonline.com/[YOUR-TENANT-ID]/oauth2/v2.0/authorize  
Refresh URL: https://login.microsoftonline.com/[YOUR-TENANT-ID]/oauth2/v2.0/token

Scopes: ea9ffc3e-8a23-4a7d-836d-234d7c7565c1/McpServers.OneDriveSharepoint.All
```

(Replace `[YOUR-TENANT-ID]` with your Tenant ID from Step 2)

3. Click **"Save"** or **"Connect"**
4. **Copy the Redirect URL** that appears after saving

**Step 6 of 6: Add Redirect URL**

Back in Azure Portal → your app registration:
1. Go to **"Authentication"**
2. Click **"Add a platform"** → **"Web"**
3. Paste the Redirect URL from Step 5
4. Click **"Configure"**

**✅ Done! Test it:**
Chat with your agent and ask: "List my recent SharePoint files"
- First time: You'll get a consent link - click it and sign in
- After consent: Your agent can access your SharePoint/OneDrive!

**Having issues?** Let me know what error you're seeing and I'll help troubleshoot.

## Automated Script Approach

**For users who prefer automation**, offer scripts for Azure CLI steps. Always:
1. **Explain what the script does** in plain language
2. **Show the script** before running it
3. **Ask permission**: "Would you like me to run this script for you?"
4. **Verify prerequisites**: "This requires Azure CLI. Do you have it installed?"

### Script Guidelines

When offering scripts:
- **One script per step** (not one monolithic script)
- **Include comments** explaining each command
- **Echo what's happening** so users see progress
- **Handle errors gracefully** with clear messages
- **Save outputs** (like Client ID, Tenant ID) for next steps

### Available Scripts

#### Script 1: Create Entra App Registration
**What it does**: Creates app registration and retrieves Client ID and Tenant ID

```bash
# This script:
# 1. Creates a new Entra app registration named "Foundry Agent SharePoint"
# 2. Outputs the Client ID and Tenant ID
# 3. Saves them to entra-app-config.json

az ad app create --display-name "Foundry Agent SharePoint" \
  --sign-in-audience AzureADMyOrg \
  --query "{clientId:appId, tenantId:tenant}" \
  -o json > entra-app-config.json

cat entra-app-config.json
echo "✅ App created! Client ID and Tenant ID saved to entra-app-config.json"
```

#### Script 2: Create Client Secret
**What it does**: Generates a client secret (24-month expiry) and displays it

```bash
# This script:
# 1. Reads the Client ID from entra-app-config.json
# 2. Creates a new client secret with 24-month expiry
# 3. Displays the secret value (copy it immediately!)

CLIENT_ID=$(jq -r '.clientId' entra-app-config.json)

az ad app credential reset --id $CLIENT_ID \
  --years 2 \
  --query password \
  -o tsv

echo ""
echo "⚠️  IMPORTANT: Copy the secret value above immediately!"
echo "It won't be shown again."
```

#### Script 3: Grant API Permissions
**What it does**: Adds Agent 365 Tools permission for SharePoint/OneDrive

```bash
# This script:
# 1. Reads the Client ID from entra-app-config.json
# 2. Adds the McpServers.OneDriveSharepoint.All permission
# 3. You still need to manually grant admin consent in the portal

CLIENT_ID=$(jq -r '.clientId' entra-app-config.json)
API_ID="ea9ffc3e-8a23-4a7d-836d-234d7c7565c1"
PERMISSION_ID="<permission-guid-for-sharepoint>" # Look up the actual GUID

# Add the permission
az ad app permission add --id $CLIENT_ID \
  --api $API_ID \
  --api-permissions "$PERMISSION_ID=Scope"

echo "✅ Permission added!"
echo "⚠️  You must still grant admin consent in Azure Portal:"
echo "   Go to App registrations > Your app > API permissions"
echo "   Click 'Grant admin consent for [Your Org]'"
```

#### Script 4: Generate Foundry Configuration
**What it does**: Creates the exact configuration values for Foundry portal

```bash
# This script:
# 1. Reads your Client ID and Tenant ID
# 2. Generates all the URLs and values for Foundry
# 3. Outputs them in a copy-paste friendly format

CLIENT_ID=$(jq -r '.clientId' entra-app-config.json)
TENANT_ID=$(jq -r '.tenantId' entra-app-config.json)

echo ""
echo "📋 Copy these values into Foundry:"
echo ""
echo "Name: SharePoint and OneDrive"
echo "Authentication: OAuth Identity Passthrough"
echo ""
echo "Client ID: $CLIENT_ID"
echo "Client Secret: [paste your secret from Script 2]"
echo ""
echo "Token URL: https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token"
echo "Auth URL: https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/authorize"
echo "Refresh URL: https://login.microsoftonline.com/$TENANT_ID/oauth2/v2.0/token"
echo ""
echo "Scopes: ea9ffc3e-8a23-4a7d-836d-234d7c7565c1/McpServers.OneDriveSharepoint.All"
```

#### Script 5: Add Redirect URL
**What it does**: Adds the Foundry redirect URL to your app registration

```bash
# This script:
# 1. Asks you to paste the Redirect URL from Foundry
# 2. Adds it to your app registration's web redirect URIs

CLIENT_ID=$(jq -r '.clientId' entra-app-config.json)

echo "Paste the Redirect URL from Foundry:"
read REDIRECT_URL

az ad app update --id $CLIENT_ID \
  --web-redirect-uris "$REDIRECT_URL"

echo "✅ Redirect URL added!"
```

### How to Offer Scripts

**Example conversation flow:**

User: "I need SharePoint access"

Copilot: "I'll help you connect SharePoint/OneDrive! Quick check: Can you grant admin consent in Azure Entra ID?"

User: "Yes"

Copilot: "Great! You can do this manually in the portal, OR I can provide Azure CLI scripts to automate most steps. 

**Manual approach**: I'll give you exact portal instructions (5-10 min)
**Script approach**: Automated scripts for each step - you can see what each does (3-5 min, requires Azure CLI)

Which do you prefer?"

**If they choose scripts:**
"Perfect! First, let's verify: Do you have Azure CLI installed? (Run `az --version` to check)"

Then proceed step-by-step with scripts, explaining each one.

## Troubleshooting

If users encounter issues, diagnose and provide specific solutions:

**"I don't see the consent link"**
→ Check: Do you have Azure AI User role? Try refreshing the agent chat.

**"Permission denied errors"**  
→ Check: Was admin consent granted in Step 4? Ask your Global Admin to grant it.

**"Authentication failed"**
→ Check: Does the Redirect URL in Entra Authentication exactly match the one from Foundry?

**"Invalid tenant"**
→ Check: Did you replace `[YOUR-TENANT-ID]` with your actual tenant ID in all three URLs?

**"I can't grant admin consent"**
→ Forward Step 4 to your Global Administrator to complete that part.

**"No agent in Foundry"**
→ "Let me help you create one first: Go to https://ai.azure.com → Create agent → give it a name and choose a model (GPT-4 recommended) → Save. Then we'll add SharePoint access."

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
