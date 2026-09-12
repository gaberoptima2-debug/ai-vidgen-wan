#!/usr/bin/env bash
set -u

TEMPLATE_DIR=/ai-vidgen-template
RUNTIME_DIR=/comfyui-runtime
RUNTIME_URL="https://github.com/Hearmeman24/comfyui-runtime.git"

echo "AI VIDGEN custom boot"
echo "TEMPLATE_DIR=$TEMPLATE_DIR"

if [ ! -f "$TEMPLATE_DIR/template.json" ]; then
  echo "Missing $TEMPLATE_DIR/template.json"
  exit 1
fi

if [ ! -f "$TEMPLATE_DIR/pins.json" ]; then
  echo "Missing $TEMPLATE_DIR/pins.json"
  exit 1
fi

RUNTIME_REF="$(python3 -c "import json; print(json.load(open('$TEMPLATE_DIR/pins.json'))['runtime_ref'])" 2>/dev/null)"

if [ -z "$RUNTIME_REF" ]; then
  echo "Could not read runtime_ref"
  exit 1
fi

echo "runtime_ref=$RUNTIME_REF"

sync_runtime() {
  if [ ! -d "$RUNTIME_DIR/.git" ]; then
    rm -rf "$RUNTIME_DIR"
    git clone "$RUNTIME_URL" "$RUNTIME_DIR" || return 1
  fi

  git -C "$RUNTIME_DIR" fetch origin "$RUNTIME_REF" &&
  git -C "$RUNTIME_DIR" reset --hard FETCH_HEAD
}

ok=""
for attempt in 1 2 3 4 5; do
  if sync_runtime; then
    ok=1
    break
  fi

  echo "runtime sync attempt $attempt failed; retrying..."
  sleep $((attempt * 5))
done

if [ -z "$ok" ]; then
  if [ ! -d "$RUNTIME_DIR/.git" ]; then
    echo "Runtime unavailable."
    exit 1
  fi

  echo "Runtime sync failed; using existing checkout."
fi

echo "Starting AI VIDGEN runtime"
exec bash "$RUNTIME_DIR/src/start.sh" "$TEMPLATE_DIR"
