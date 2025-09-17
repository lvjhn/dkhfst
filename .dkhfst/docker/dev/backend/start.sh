#!/usr/bin/env bash

VENDOR_DIR="./vendor"

if [ ! -d "$VENDOR_DIR" ] || [ -z "$(ls -A "$VENDOR_DIR" 2>/dev/null)" ]; then
    echo "⚠️ Vendor directory missing or empty. Idling container..."
    tail -f /dev/null   # keep container alive
else
    echo "✅ Vendor is ready. Starting Laravel..."
    php artisan serve --host 0.0.0.0 --port 8000
fi
