#!/usr/bin/env python3
import sys
import json

def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        data = {}

    if not isinstance(data, dict):
        data = {}

    confirmation_pending = bool(data.get("tool_confirmation_pending"))
    agent_state = str(data.get("agent_state") or "idle")

    model_obj = data.get("model")
    model_name = ""
    if isinstance(model_obj, dict):
        model_name = str(model_obj.get("display_name") or "")
    elif isinstance(model_obj, str):
        model_name = model_obj

    # Use \uFE0F variation selector so color emojis render properly with double-width cells
    title = ""
    bell = ""
    if confirmation_pending:
        title = "🔔\uFE0F Needs Input"
        bell = "\a"
    elif agent_state in ("thinking", "working", "tool_use", "initializing"):
        title = "⏳\uFE0F Agent Running"
    else:
        title = "✅\uFE0F Agent Idle"
        bell = "\a"

    try:
        with open("/dev/tty", "w") as tty:
            tty.write(f"\033]2;{title}\007{bell}")
            tty.flush()
    except Exception:
        pass

    # Print statusline text for Jetski CLI footer
    status_text = f" {model_name} | {agent_state}" if model_name else f" {agent_state}"
    if confirmation_pending:
        status_text += " | 🔔 NEEDS INPUT"
    print(status_text)

if __name__ == "__main__":
    main()
