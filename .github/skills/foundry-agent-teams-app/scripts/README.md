# Foundry Agent Teams App Scripts

## Setup Script

**`setup.sh`** - Complete setup automation

Clones the Teams app template and configures it with your Foundry agent details.

### Usage

```bash
./scripts/setup.sh
```

### What it does

1. Clones `https://github.com/1openwindow/foundry_agent_teams_app`
2. Prompts for:
   - Foundry project endpoint
   - Agent name
3. Creates/updates configuration files
4. Shows next steps to start debugging

### After Setup

```bash
cd foundry_agent_teams_app
code .  # Open in VS Code
# Press F5 to debug
```
