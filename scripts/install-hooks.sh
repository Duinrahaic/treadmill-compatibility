#!/bin/bash
# Install git hooks

HOOK_DIR=".git/hooks"
SCRIPT_DIR="scripts"

echo "Installing git hooks..."

# Create pre-commit hook
cat > "$HOOK_DIR/pre-commit" << 'EOF'
#!/bin/bash

# Check if any treadmill data files are being committed
if git diff --cached --name-only | grep -q "^data/treadmills/.*\.json$"; then
  echo "📦 Treadmill data changed, running compile..."

  # Run compile script
  node scripts/compile.js

  # Check if compilation produced changes
  if ! git diff --quiet data/treadmills.json; then
    echo "✅ Compiled dataset updated, adding to commit..."
    git add data/treadmills.json
  else
    echo "✅ Compiled dataset unchanged"
  fi
fi
EOF

chmod +x "$HOOK_DIR/pre-commit"

echo "✅ Git hooks installed successfully!"
echo ""
echo "The pre-commit hook will automatically:"
echo "  • Run compile.js when you commit treadmill data files"
echo "  • Add the compiled dataset to your commit"
