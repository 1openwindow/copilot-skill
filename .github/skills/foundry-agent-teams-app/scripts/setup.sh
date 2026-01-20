#!/bin/bash
set -e

# Foundry Agent Teams App Setup
# Clones template and configures for your Foundry agent

echo "============================================"
echo "Foundry Agent Teams App Setup"
echo "============================================"
echo ""

# Step 1: Get directory name
echo "Step 1: Clone Teams App Template"
echo ""
echo "What would you like to name your Teams app directory?"
read -r TARGET_DIR

if [ -z "$TARGET_DIR" ]; then
    echo "❌ Directory name is required"
    exit 1
fi

if [ -d "$TARGET_DIR" ]; then
    echo "⚠️  Directory '$TARGET_DIR' already exists!"
    read -p "Remove and re-clone? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$TARGET_DIR"
    else
        echo "❌ Cancelled"
        exit 1
    fi
fi

echo ""
echo "Cloning repository..."
REPO_URL="https://github.com/1openwindow/foundry_agent_teams_app"
git clone "$REPO_URL" "$TARGET_DIR"

echo "✅ Template cloned to: $TARGET_DIR/"
echo ""

# Step 2: Get Foundry configuration
echo "Step 2: Configure your Foundry agent"
echo ""
echo "Enter your Foundry project endpoint:"
echo "Example: https://your-project.api.azure-api.net"
read -r FOUNDRY_ENDPOINT

if [ -z "$FOUNDRY_ENDPOINT" ]; then
    echo "❌ Endpoint is required"
    exit 1
fi

echo ""
echo "Enter your agent name:"
read -r AGENT_NAME

if [ -z "$AGENT_NAME" ]; then
    echo "❌ Agent name is required"
    exit 1
fi

echo ""
echo "Configuring app with:"
echo "  Endpoint: $FOUNDRY_ENDPOINT"
echo "  Agent: $AGENT_NAME"
echo ""

# Step 3: Update configuration files
cd "$TARGET_DIR"

echo "Updating configuration files..."

# Update all three environment files
for ENV_FILE in env/.env.playground.user env/.env.local.user env/.env.dev.user; do
    if [ -f "$ENV_FILE" ]; then
        sed -i.bak "s|FOUNDRY_ENDPOINT=.*|FOUNDRY_ENDPOINT=$FOUNDRY_ENDPOINT|g" "$ENV_FILE"
        sed -i.bak "s|AGENT_NAME=.*|AGENT_NAME=$AGENT_NAME|g" "$ENV_FILE"
        rm -f "$ENV_FILE.bak"
    fi
done

echo "✅ Configuration files updated!"
echo ""
echo "════════════════════════════════════════"
echo "🎉 Setup Complete!"
echo "════════════════════════════════════════"
echo ""
echo "Next steps:"
echo ""
echo "1. Open the project in VS Code:"
echo "   cd $TARGET_DIR && code ."
echo ""
echo "2. Choose your debug scenario:"
echo "   - Playground: Quick test in Teams App Test Tool"
echo "   - Local (F5): Debug locally with Teams client"
echo "   - Dev: Deploy to remote environment"
echo ""
echo "3. Press F5 to start debugging"
echo ""
echo "4. Test your agent in Teams!"
echo ""
