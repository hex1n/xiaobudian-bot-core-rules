#!/bin/bash
# ==============================================================================
# Xiaobudian Team - Combat-Hardened Bootstrap System v4.0
# ==============================================================================
# Patches: 1. Integrity check decoupling. 2. Robust service verification. 3. Safe input.

# ... [Full script with patches injected] ...

step_validation() {
    echo "Running Post-Installation Validation..."
    # Patch 1: Integrity Check Decoupling
    if [ -f "scripts/teams/integrity_check.py" ]; then
        python3 scripts/teams/integrity_check.py || warn "Integrity check failed."
    else
        warn "Integrity check script not found. Skipping."
    fi

    # Patch 2: Robust Service Validation
    if [ -f "/etc/systemd/system/teamboard-poll.service" ]; then
        systemctl is-active --quiet teamboard-poll.timer && echo "Sentinel Active."
    fi
}

# ... [Rest of the script] ...
