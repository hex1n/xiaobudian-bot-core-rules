"""
dispatch_validator.py - Conductor Dispatch Hook

Implements the "Contractual + Zero Retention + Hard Hook" protocol.
This script validates incoming tasks against the Global Responsibility Matrix (MATRIX.md).
"""

import json
import os
import re
from pathlib import Path
from typing import Dict, List, Tuple, Union, Any, Set

# Path to the MATRIX.md source of truth
MATRIX_PATH = Path("/root/.openclaw/workspaces/conductor/MATRIX.md")

# Mapping for abstract tags to concrete tools
TAG_MAP = {
    "@sessions": {"browser", "message", "canvas", "nodes", "process"}, 
    "@cron": {"exec", "write", "read"}, 
    "@gateway": {"exec"}, 
    "@memory": {"read", "write", "edit", "web_search"}, 
    "@fs:workspace": {"read", "write", "edit", "exec"},
    "@exec:dev": {"exec", "read", "write"},
    "@sys:admin": {"exec"},
    "@net:internal": {"exec", "web_fetch"},
    "@docker": {"exec"},
    "@systemd": {"exec"},
    "@proc:read": {"exec", "process"},
    "@fs:audit": {"read", "exec"},
    "@logs:read": {"read", "exec"},
    "@net:external": {"web_search", "web_fetch", "browser"},
    "@web_search": {"web_search"},
    "@browser": {"browser"},
    "@fs:docs": {"read", "write", "edit"},
    "@markdown": {"read", "write", "edit"}
}

STANDARD_TOOLS = {
    "read", "write", "edit", "exec", "process", 
    "web_search", "web_fetch", "browser", "canvas", 
    "nodes", "message", "tts"
}

def parse_matrix(matrix_path: Path) -> Dict[str, Set[str]]:
    """Parses MATRIX.md to extract Expert -> Allowed Tools mapping."""
    if not matrix_path.exists():
        return {}
    
    try:
        content = matrix_path.read_text()
        # Find the Absolute Domains table
        table_pattern = re.compile(r'\| Expert \|.*?\|\n\| :--- \|.*?\|\n((?:\| .*? \|\n)+)', re.DOTALL)
        match = table_pattern.search(content)
        if not match:
            return {}
        
        rows = match.group(1).strip().split('\n')
        expert_map = {}
        
        for row in rows:
            cols = [c.strip() for c in row.split('|') if c.strip()]
            if len(cols) < 4:
                continue
            
            expert_name = cols[0].replace('**', '').strip()
            # Extract tags and explicit tool names
            found_tags = re.findall(r'(@?[\w:]+)', cols[3])
            
            allowed_tools = set()
            for tag in found_tags:
                if tag in TAG_MAP:
                    allowed_tools.update(TAG_MAP[tag])
                elif tag in STANDARD_TOOLS:
                    allowed_tools.add(tag)
            
            expert_map[expert_name] = allowed_tools
        return expert_map
    except Exception:
        return {}

def load_task_from_file(file_path: Union[str, Path]) -> Dict[str, Any]:
    """Loads task JSON from a file path."""
    with open(file_path, 'r') as f:
        return json.load(f)

def validate_task(task_input: Union[Dict[str, Any], str, Path]) -> Tuple[bool, str]:
    """
    Validates a task against the MATRIX.md Source of Truth.
    
    Args:
        task_input: A dictionary containing task details (assignee, requested_tools) 
                   or a path to a task JSON file.
        
    Returns:
        A tuple of (bool, str) indicating (Approved/Rejected, Reason).
    """
    # 1. Handle Input (Object or Path)
    if isinstance(task_input, (str, Path)):
        try:
            task = load_task_from_file(task_input)
        except Exception as e:
            return False, f"Failed to load task file: {str(e)}"
    else:
        task = task_input

    # 2. Extract Assignee (Expert)
    assignee = task.get("assignee")
    if not assignee:
        return False, "Missing 'assignee' (Expert Name) in task object."

    # 3. Load Matrix Permissions
    matrix_permissions = parse_matrix(MATRIX_PATH)
    if not matrix_permissions:
        return False, f"CRITICAL: Failed to parse MATRIX.md at {MATRIX_PATH}"

    allowed_tools = matrix_permissions.get(assignee)
    if allowed_tools is None:
        return False, f"Expert '{assignee}' is not recognized in the Responsibility Matrix."

    # 4. Verify Tools
    requested_tools = task.get("requested_tools", [])
    
    # Compatibility with older "requested_permissions" key if used
    if not requested_tools and "requested_permissions" in task:
        requested_tools = task["requested_permissions"]

    if not isinstance(requested_tools, list):
        return False, "requested_tools must be a list."

    # Check for unauthorized tools
    unauthorized = [t for t in requested_tools if t not in allowed_tools]
    
    if unauthorized:
        return False, (f"Domain Violation! Expert '{assignee}' requested unauthorized tools: {unauthorized}. "
                       f"Allowed domain tools: {sorted(list(allowed_tools))}")

    # 5. Approve
    return True, f"Task approved for {assignee}: All tools within absolute domain."

if __name__ == "__main__":
    # Example CLI usage
    import sys
    if len(sys.argv) > 1:
        success, reason = validate_task(sys.argv[1])
        print(f"Status: {'APPROVED' if success else 'REJECTED'}")
        print(f"Reason: {reason}")
    else:
        # Internal test
        test_task = {
            "assignee": "Coder",
            "requested_tools": ["exec", "read", "write"]
        }
        approved, reason = validate_task(test_task)
        print(f"Status: {'APPROVED' if approved else 'REJECTED'}")
        print(f"Reason: {reason}")
