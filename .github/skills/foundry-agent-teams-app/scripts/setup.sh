#!/bin/bash
set -e

# Foundry Agent Teams App Setup
# Clones template and configures for your Foundry agent

echo "============================================"
echo "Foundry Agent Teams App Setup"
echo "============================================"
echo ""

# Step 1: Clone repository
echo "Step 1: Cloning Teams app template..."
echo ""

REPO_URL="https://github.com/1openwindow/foundry_agent_teams_app"
TARGET_DIR="foundry_agent_teams_app"

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

git clone "$REPO_URL" "$TARGET_DIR"

echo "✅ Template cloned!"
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

# Update .env file if it exists
if [ -f "env/.env.local.user" ]; then
    echo "Updating env/.env.local.user..."
    sed -i.bak "s|FOUNDRY_ENDPOINT=.*|FOUNDRY_ENDPOINT=$FOUNDRY_ENDPOINT|g" env/.env.local.user
    sed -i.bak "s|AGENT_NAME=.*|AGENT_NAME=$AGENT_NAME|g" env/.env.local.user
    rm -f env/.env.local.user.bak
fi

# Create config file if needed
mkdir -p env
cat > env/.env.local.user << EOF
# Foundry Agent Configuration
FOUNDRY_ENDPOINT=$FOUNDRY_ENDPOINT
AGENT_NAME=$AGENT_NAME
EOF

echo "✅ Configuration complete!"
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
echo "2. Press F5 to start debugging"
echo ""
echo "3. Teams will launch with your Foundry agent"
echo ""
echo "4. Test your agent in Teams!"
echo ""
