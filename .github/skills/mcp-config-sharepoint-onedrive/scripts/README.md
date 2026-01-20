# Automated Setup Scripts

These scripts automate the SharePoint/OneDrive MCP configuration process using Azure CLI. Each script handles one step and clearly shows what it's doing.

## Prerequisites

- **Azure CLI** installed ([install guide](https://docs.microsoft.com/cli/azure/install-azure-cli))
- **jq** installed (for JSON parsing): `brew install jq` or `apt-get install jq`
- Logged in to Azure: `az login`
- Permissions to create app registrations

## Usage

Run scripts in order:

### 1. Create App Registration
```bash
./scripts/1-create-app-registration.sh
```
**What it does:**
- Creates new Entra app registration
- Saves Client ID and Tenant ID to `$HOME/.mcp-sharepoint-config.json`

### 2. Create Client Secret
```bash
./scripts/2-create-client-secret.sh
```
**What it does:**
- Generates 24-month client secret
- Displays secret value (copy it immediately!)

### 3. Grant Permissions
```bash
./scripts/3-grant-permissions.sh
```
**What it does:**
- Provides instructions for manually adding Agent 365 Tools permission
- Requires Global Administrator for admin consent

### 4. Generate Foundry Config
```bash
./scripts/4-generate-foundry-config.sh
```
**What it does:**
- Outputs all values needed for Foundry portal
- Ready to copy-paste into MCP configuration

### 5. Add Redirect URL
```bash
./scripts/5-add-redirect-url.sh
```
**What it does:**
- Prompts for Foundry redirect URL
- Adds it to your app registration

## Full Example

```bash
# Step 1: Create app
./scripts/1-create-app-registration.sh
# Output: entra-app-config.json created

# Step 2: Get secret
./scripts/2-create-client-secret.sh
# Output: Copy the secret value!

# Step 3: Grant permissions (manual in portal)
./scripts/3-grant-permissions.sh
# Follow the instructions shown

# Step 4: Get Foundry config values
./scripts/4-generate-foundry-config.sh
# Copy all values into Foundry portal

# Step 5: Add redirect URL
./scripts/5-add-redirect-url.sh
# Paste redirect URL from Foundry
```

## What Gets Created

- **$HOME/.mcp-sharepoint-config.json**: Stores Client ID and Tenant ID
- **Entra app registration**: "Foundry Agent SharePoint" in Azure Portal
- **Client secret**: 24-month validity
- **Permission**: McpServers.OneDriveSharepoint.All (requires admin consent)
- **Redirect URI**: Foundry's OAuth callback URL

## Troubleshooting

**"az: command not found"**
→ Install Azure CLI: https://docs.microsoft.com/cli/azure/install-azure-cli

**"jq: command not found"**
→ Install jq: `brew install jq` (Mac) or `apt-get install jq` (Linux)

**"Not logged in to Azure CLI"**
→ Run: `az login`

**"Insufficient privileges"**
→ You need permission to create app registrations in Entra ID

**"Cannot grant admin consent"**
→ Ask your Global Administrator to run step 3

## Clean Up

To remove the created resources:

```bash
# Get the Client ID
CLIENT_ID=$(jq -r '.clientId' ~/.mcp-sharepoint-config.json)

# Delete the app registration
az ad app delete --id $CLIENT_ID

# Remove config file
rm ~/.mcp-sharepoint-config.json
```
