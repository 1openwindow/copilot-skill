# Foundry Agent Teams App Scripts

## Setup Script

**`setup.sh`** - Complete setup automation

Clones the Teams app template and configures it with your Foundry agent details.

### Usage

```bash
./scripts/setup.sh
```

### What it does

1. Asks for directory name for the Teams app
2. Clones `https://github.com/1openwindow/foundry_agent_teams_app`
3. Prompts for:
   - Foundry project endpoint
   - Agent name
4. Updates environment files:
   - `env/.env.playground.user`
   - `env/.env.local.user`
   - `env/.env.dev.user`
5. Shows next steps to start debugging

### After Setup

```bash
cd <your-directory-name>
code .  # Open in VS Code
# Press F5 to debug
```
