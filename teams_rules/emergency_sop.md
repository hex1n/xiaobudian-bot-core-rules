# Offline Emergency SOP - Xiaobudian Team

## 1. Objective
To establish a fail-safe protocol allowing Ops Experts to take limited, pre-authorized autonomous actions when the Central Dispatcher is unresponsive, ensuring service continuity while maintaining security boundaries.

## 2. "Dispatcher Unresponsive" Criteria
The Dispatcher is considered **OFFLINE** if **ANY** of the following scenarios occur:

### Scenario A: Total System Failure (ALL conditions met)
1.  **No Heartbeat**: No valid heartbeat or task assignment received for **15 minutes**.
2.  **API Failure**: Direct API calls to the Dispatcher endpoint return 5xx errors or time out for **3 consecutive attempts** (1-minute intervals).
3.  **Process Check**: If running on the same host, the Dispatcher process is confirmed dead or zombie via `ps`/`systemctl`.

### Scenario B: Model Rate Limiting
1.  **Rate Limit Exceeded**: If Dispatcher reports "429 Too Many Requests" or "Rate Limit Exceeded" and remains restricted for more than **3 minutes**, it is considered OFFLINE/UNRESPONSIVE.

## 3. Communication Backchannel
Upon confirming the Dispatcher is offline, the Ops Expert must immediately notify **0x01** via the following backchannels in order of priority:
1.  **Discord (Direct Message)**: Send a high-priority alert to user `0x01`.
    *   *Template*: `🚨 CRITICAL: Dispatcher Unresponsive. Initiating Emergency SOP. Host: [Hostname]. Reason: [Error/Timeout].`
2.  **Signal (If available)**: Send an encrypted message to the verified safety number.
3.  **Local Log**: Write a marker entry to `/var/log/openclaw/emergency.log` with a timestamp and the trigger condition.

## 4. Authorized Emergency Actions
During an offline state, Ops Experts are authorized to perform **ONLY** the following actions without Dispatcher mediation. All actions must be logged locally.

### ✅ Allowed (Green Light)
*   **Service Restarts**: Restarting critical services (e.g., Nginx, Docker containers, Database services) if they are down or degraded.
*   **Log Rotation/Cleanup**: Clearing or rotating logs if disk usage exceeds **90%** to prevent system lockup.
*   **Security Patching**: applying critical security updates (CVSS > 9.0) if an active exploit is detected.
*   **Resource Monitoring**: Killing runaway processes consuming >80% CPU/RAM for >5 minutes (excluding allowlisted system processes).

### ❌ Prohibited (Red Light)
*   **Code Deployment**: No new application code deployments.
*   **Configuration Changes**: No changes to core application logic or business rules.
*   **Data Deletion**: No deletion of application data or backups.
*   **Privilege Escalation**: No creating new users or changing root credentials.

## 5. Recovery & Re-sync
Once the Dispatcher connection is restored:
1.  **Stop Independent Actions**: Immediately cease all autonomous operations.
2.  **Report**: Upload the emergency activity log (including all actions taken) to the Dispatcher.
3.  **Verify**: Request a system integrity check from the Dispatcher.

## 6. Test Plan
To verify this SOP, the following drill will be conducted quarterly:
1.  **Simulation**: Manually stop the Dispatcher service during a maintenance window.
2.  **Trigger Verification**: Confirm Ops Expert detects the "Offline" state within 15 minutes.
3.  **Action Test**: Simulate a "Disk Full" or "Service Down" event and verify the Ops Expert takes the correct authorized action.
4.  **Notification Test**: Verify the alert reaches 0x01 via the backchannel.
5.  **Restoration**: Restart the Dispatcher and verify the Ops Expert re-syncs and uploads logs.

---
*Last Updated: 2026-02-11*
*Status: DRAFT*
