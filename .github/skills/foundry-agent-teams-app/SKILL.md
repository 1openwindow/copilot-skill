---
name: foundry-agent-teams-app
description: Set up and debug Foundry agents with MCP tools in Microsoft Teams. Use when asked to preview, test, or debug a Foundry agent in Teams.
---

# Foundry Agent Teams App

Guides users through setting up a Teams app to debug and preview Foundry agents with MCP tools.

## How to Help Users

### Initial Response
"I'll help you set up a Teams app to preview your Foundry agent. Takes ~3 minutes. This will let you test your agent directly in Teams with F5 debugging."

### Execution Approach
**Execute steps interactively:**
1. Explain what this step does (1-2 sentences)
2. Execute the action
3. Highlight key information
4. Move to next step

## Step-by-Step Flow

### Prerequisites Check
Before starting, verify:
- `git --version` (Git installed)
- User has a Foundry agent already created
- User has VS Code or similar IDE installed

### Step 1: Clone Teams App Template
- Action: Clone the repository
- Command: `git clone https://github.com/1openwindow/foundry_agent_teams_app`
- User action: None (automated)

### Step 2: Get Foundry Configuration
- Action: Ask user for their Foundry details
- Required info:
  - Foundry project endpoint (e.g., `https://your-project.api.azure-api.net`)
  - Agent name
- User action: Provide their Foundry endpoint and agent name

### Step 3: Configure the App
- Action: Update configuration files with user's Foundry details
- Files to update: Configuration files in the cloned repo
- User action: None (automated)

### Step 4: Ready to Debug
- Action: Inform user they can press F5
- User action: Open project in IDE and press F5 to start debugging

## Example Interaction

```
User: "I want to test my Foundry agent in Teams"

Copilot: "I'll help you set up a Teams app to preview your agent. Takes ~3 minutes.

**Step 1 of 4: Clone Teams App Template**
I'll clone the template repository to get started.
Ready?"

User: "Yes"

Copilot: [Clones repo]
"✅ Template cloned to: foundry_agent_teams_app/

**Step 2 of 4: Get Your Foundry Configuration**
I need two things from your Foundry setup:
1. Your Foundry project endpoint (e.g., https://your-project.api.azure-api.net)
2. Your agent name

What's your Foundry project endpoint?"

User: "https://myproject.api.azure-api.net"

Copilot: "Got it! What's your agent name?"

User: "my-sharepoint-agent"

Copilot: "Perfect!

**Step 3 of 4: Configure the App**
Updating configuration with your Foundry details...
Ready?"

User: "Yes"

Copilot: [Updates config files]
"✅ Configuration updated!

**Step 4 of 4: Ready to Debug**
All set! 

To start debugging:
1. Open the project folder in VS Code
2. Press F5
3. Teams will launch with your Foundry agent

Your agent is now ready to test in Teams! 🎉"
```

## Troubleshooting

**"Clone failed"**
→ Check internet connection and Git installation

**"Agent not responding in Teams"**
→ Verify Foundry endpoint and agent name are correct

**"F5 doesn't work"**
→ Ensure Microsoft 365 Agents Toolkit extension is installed in VS Code

**"Authentication error"**
→ Check if Foundry agent has proper OAuth configuration

## Configuration Details

The following files typically need configuration:
- `.env` or `env/.env.local` - Environment variables
- `teamsapp.yml` - Teams app configuration
- Agent endpoint and name settings

## Additional Notes
- First run may take longer while dependencies install
- Microsoft 365 Agents Toolkit extension is required for F5 debugging
- Changes to agent config require app restart
- Use Teams App Test Tool for local testing without Teams client
