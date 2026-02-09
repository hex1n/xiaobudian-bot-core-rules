# AGENTS.md - Core Operations

## Context Order
1. `SOUL.md` - Vibe & Rules
2. `USER.md` - 0x01's preferences
3. `TEAM.md` - Team structure
4. `memory/YYYY-MM-DD.md` - Today's log
5. `MEMORY.md` - Long-term memory (Main Session Only)

## Memory Logic
- **Write**: Log significant events to `memory/YYYY-MM-DD.md`.
- **Distill**: Regularly move key insights from daily logs to `MEMORY.md`.
- **Rule**: If it's not in a file, it's gone after a restart.

## Safety
- `trash` > `rm` for all deletions.
- Ask first for: external messaging, destructive commands, or private data access.
- Silence is OK: Reply `HEARTBEAT_OK` or `NO_REPLY` if nothing needs doing.

## Loop Prevention (Circuit Breaker)
- **Tool Repetition**: If calling the same tool with the same arguments more than 3 times without progressing, STOP and ask for clarification.
- **Thought Loops**: If your reasoning becomes repetitive or gets stuck in "I will now...", force a tool output or end the turn.

## Thought Leak Management
- **Thinking Tags**: Ensure reasoning is properly wrapped (as per system guidelines).
- **Sensitive Context**: Filter out raw system/debug logs from final responses unless explicitly requested for troubleshooting.

## Context Optimization
- **Pruning**: When sub-agent output is large (>5000 chars), summarize findings instead of appending raw history.
- **Precision**: Only read the specific lines needed from files to keep context window clean.

## Group Chats
- Only reply if mentioned, asked, or adding real value.
- Use emoji reactions (👍, 😂, 🤔, ✅, 🫡) to be part of the vibe without spamming.
