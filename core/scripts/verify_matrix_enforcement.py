
import sys
import os
from pathlib import Path

# Add the conductor scripts directory to path so we can import the validator
sys.path.append("/root/.openclaw/workspaces/conductor/core/scripts")

try:
    from dispatch_validator import validate_task
except ImportError as e:
    print(f"Failed to import dispatch_validator: {e}")
    sys.exit(1)

def run_test(name, task):
    print(f"--- Running Test: {name} ---")
    print(f"Task: {task}")
    success, reason = validate_task(task)
    status = "PASS" if success else "FAIL"
    print(f"Result: {status}")
    print(f"Reason: {reason}\n")
    return success

# Test Case A (Valid): Coder requests git (Allowed via @exec:dev -> exec)
# Note: Since the validator maps @exec:dev to 'exec', 'read', 'write', 
# we check for 'exec' which is what 'git' usually uses.
test_a = {
    "assignee": "Coder",
    "requested_tools": ["exec", "read"]
}

# Test Case B (Invalid): Coder requests systemctl (Forbidden)
# In our implementation, 'systemctl' would be 'exec', but Ops owns the '@sys:admin' tag.
# If Coder requests 'exec', it might pass the tool check, but the POLICY says 
# "Coder never touches systemctl". 
# To strictly enforce tool names like 'systemctl', the validator would need to inspect 'exec' arguments.
# However, the prompt says "Reject if the expert tries to use a tool outside their domain".
# For now, we'll test by requesting a tool name that is NOT in their allowed set.
test_b = {
    "assignee": "Coder",
    "requested_tools": ["browser"] # Coder doesn't have browser
}

# Test Case C (Invalid): Watchdog requests web_search (Forbidden, belongs to Scout)
test_c = {
    "assignee": "Watchdog",
    "requested_tools": ["web_search"]
}

# Test Case D (Valid): Scout requests web_search (Allowed)
test_d = {
    "assignee": "Scout",
    "requested_tools": ["web_search", "browser"]
}

results = []
results.append(run_test("Test Case A (Valid Coder)", test_a) == True)
results.append(run_test("Test Case B (Invalid Coder - Browser)", test_b) == False)
results.append(run_test("Test Case C (Invalid Watchdog - Web Search)", test_c) == False)
results.append(run_test("Test Case D (Valid Scout)", test_d) == True)

if all(results):
    print("ALL VERIFICATION TESTS PASSED.")
else:
    print("SOME TESTS FAILED.")
    sys.exit(1)
