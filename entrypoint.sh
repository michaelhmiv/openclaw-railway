#!/bin/bash
set -e

# Ensure /data/.openclaw directory exists
mkdir -p /data/.openclaw/agents/main/agent /data/.openclaw/skills

# Initialize config only if it doesn't exist (preserve existing)
if [ ! -f /data/.openclaw/openclaw.json ] && [ -n "$OPENCLAW_CONFIG_BASE64" ]; then
    echo "Initializing config from OPENCLAW_CONFIG_BASE64..."
    echo "$OPENCLAW_CONFIG_BASE64" | base64 -d > /data/.openclaw/openclaw.json
fi

# Initialize skills/agents only if not already done
if [ -n "$OPENCLAW_SKILLS_B64" ]; then
    if [ ! -f /data/.openclaw/skills/.initialized ]; then
        echo "Initializing skills from OPENCLAW_SKILLS_B64..."
        echo "$OPENCLAW_SKILLS_B64" | base64 -d | tar -xzf - -C /data/.openclaw
        chmod +x /data/.openclaw/skills/*/describe-image /data/.openclaw/skills/*/code-task 2>/dev/null || true
        touch /data/.openclaw/skills/.initialized
    fi
fi

# Export environment
export OPENCLAW_STATE_DIR=/data/.openclaw
export OPENCLAW_CONFIG_PATH=/data/.openclaw/openclaw.json
export HOME=/data

# Run the command (as root - simpler for Railway)
exec "$@"
