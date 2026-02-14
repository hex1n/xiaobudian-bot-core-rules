#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

VALIDATOR="python3 core/scripts/dispatch_validator.py"

pass() { echo "[PASS] $1"; }
fail() { echo "[FAIL] $1"; exit 1; }

mktemp_task() {
  local path="$1"
  cat > "$path" <<JSON
$2
JSON
}

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

# 1) Coder should be able to use exec/read/write (fs+dev)
mktemp_task "$TMP_DIR/task_ok_coder.json" '{
  "assignee": "Coder",
  "requested_tools": ["exec", "read", "write"]
}'
OUT1="$($VALIDATOR "$TMP_DIR/task_ok_coder.json")" || fail "Coder task unexpectedly rejected"
echo "$OUT1" | grep -q "Status: APPROVED" || fail "Coder expected APPROVED"
pass "Coder exec/read/write approved"

# 2) Ops should NOT request browser/write
mktemp_task "$TMP_DIR/task_bad_ops.json" '{
  "assignee": "Ops",
  "requested_tools": ["exec", "browser", "write"]
}'
OUT2="$($VALIDATOR "$TMP_DIR/task_bad_ops.json")"
echo "$OUT2" | grep -q "Status: REJECTED" || fail "Ops expected REJECTED"
pass "Ops browser/write rejected"

# 3) Unknown assignee rejected
mktemp_task "$TMP_DIR/task_unknown.json" '{
  "assignee": "UnknownExpert",
  "requested_tools": ["read"]
}'
OUT3="$($VALIDATOR "$TMP_DIR/task_unknown.json")"
echo "$OUT3" | grep -q "Status: REJECTED" || fail "UnknownExpert expected REJECTED"
pass "UnknownExpert rejected"

echo "All dispatch validator checks passed."
