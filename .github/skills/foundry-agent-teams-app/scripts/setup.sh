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

# Create env directory
mkdir -p env

# Create configuration for all three debug scenarios
echo "Creating configuration files..."

# Playground debug
cat > env/.env.playground.user << EOF
# Foundry Agent Configuration - Playground Debug
FOUNDRY_ENDPOINT=$FOUNDRY_ENDPOINT
AGENT_NAME=$AGENT_NAME
EOF

# Local debug
cat > env/.env.local.user << EOF
# Foundry Agent Configuration - Local Debug
FOUNDRY_ENDPOINT=$FOUNDRY_ENDPOINT
AGENT_NAME=$AGENT_NAME
EOF

# Remote debug
cat > env/.env.dev.user << EOF
# Foundry Agent Configuration - Remote Debug
FOUNDRY_ENDPOINT=$FOUNDRY_ENDPOINT
AGENT_NAME=$AGENT_NAME
EOF

echo "✅ Configuration files created:"
echo "  - env/.env.playground.user (Playground debug)"
echo "  - env/.env.local.user (Local debug)"
echo "  - env/.env.dev.user (Remote debug)"
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
