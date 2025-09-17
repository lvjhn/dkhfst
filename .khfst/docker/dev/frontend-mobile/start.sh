#!/bin/bash

MODULES_DIR="./node_modules"

if [ ! -d "$MODULES_DIR" ] || [ -z "$(ls -A "$MODULES_DIR" 2>/dev/null)" ]; then
    echo "⚠️ Modules directory missing or empty. Idling container..."
    tail -f /dev/null   # keep container alive
else
    echo "✅ Modules directory is ready. Starting vite..."
    npm run dev -- --host 0.0.0.0 --port 5173
fi
