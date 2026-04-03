#!/bin/bash
set -e

echo "──────────────────────────────────────────"
echo " Dev container post-create setup"
echo "──────────────────────────────────────────"

SECRETS_FILE="/home/vscode/.secrets/.env"
BASHRC="/home/vscode/.bashrc"

if [ -f "$SECRETS_FILE" ]; then
  echo "▶ Loading secrets into .bashrc..."
  grep -qxF ". $SECRETS_FILE" "$BASHRC" || echo ". $SECRETS_FILE" >> "$BASHRC"
  echo "✓ Secrets will load in every new terminal"
else
  echo "⚠ Secrets file not found at $SECRETS_FILE"
  echo "  Create ~/.config/devcontainer-secrets/.env on your host and rebuild"
fi

if [ -f "package-lock.json" ]; then
  echo "▶ Installing root npm dependencies..."
  npm ci
fi

# if [ -f "frontend/package-lock.json" ]; then
#   echo "▶ Installing frontend npm dependencies..."
#   (cd frontend && npm ci)
# fi

# if [ -f "backend/package-lock.json" ]; then
#   echo "▶ Installing backend npm dependencies..."
#   (cd backend && npm ci)
# fi

# if [ -f "ml/requirements.txt" ]; then
#   echo "▶ Installing Python ML dependencies..."
#   pip install --quiet -r ml/requirements.txt
# fi

echo ""
echo "✓ Environment ready."
echo "  Node $(node --version) | Python $(python --version) | CDK $(cdk --version | head -1)"
echo ""