#!/bin/bash
# Fixes the "permission is on but macOS still asks" problem after a rebuild.
# Rebuilds invalidate the ad-hoc signature, so the TCC grant must be renewed.
set -e

echo "▸ Stopping RTL Fixer..."
killall RTLFixer 2>/dev/null || true

echo "▸ Resetting stale Accessibility grant for com.rtlfixer.app..."
tccutil reset Accessibility com.rtlfixer.app || true

echo "▸ Relaunching app so it re-registers itself..."
open "/Applications/RTL Fixer.app" 2>/dev/null || open "$(dirname "$0")/build/RTL Fixer.app"

cat <<'EOF'

✅ حالا:
   1. برو System Settings ← Privacy & Security ← Accessibility
   2. سوییچ «RTL Fixer» رو روشن کن
   3. ⌥R بزن و لذت ببر 🎉

EOF
