#!/usr/bin/env bash
# Export contract ABIs from Foundry build output to the sibling FE repo.
#
# Run from the -sc repo root, e.g.:
#   forge build && bash script/export-abi.sh
#
# Auto-detects the FE repo by name swap: <project>-sc → <project>-fe

set -e

SC_DIR=$(basename "$(pwd)")
FE_DIR=$(echo "$SC_DIR" | sed 's/-sc$/-fe/')
FE_ABI_DIR="../$FE_DIR/src/abi"

if [ ! -d "../$FE_DIR" ]; then
  echo "❌ Sibling FE repo not found at ../$FE_DIR"
  echo "   Expected layout: <Org>/<project>-sc and <Org>/<project>-fe as siblings."
  exit 1
fi

mkdir -p "$FE_ABI_DIR"

if [ ! -d "out" ]; then
  echo "→ out/ not found, running forge build..."
  forge build
fi

exported=0
for sol in src/*.sol; do
  [ -f "$sol" ] || continue
  name=$(basename "$sol" .sol)
  json="out/$name.sol/$name.json"
  if [ -f "$json" ]; then
    jq '.abi' "$json" > "$FE_ABI_DIR/$name.json"
    echo "  ✓ $name.json → $FE_ABI_DIR/"
    exported=$((exported + 1))
  fi
done

if [ "$exported" -eq 0 ]; then
  echo "⚠ No contracts found in src/. Nothing exported."
  exit 0
fi

echo ""
echo "✓ Exported $exported ABI(s) to $FE_ABI_DIR/"
