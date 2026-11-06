#!/usr/bin/env python3
"""Generic Kitty/tmux pane title updater and AI CLI statusline formatter."""

import json
import os
import re
import sys
import time
import unicodedata

# ANSI Colors
NC = "\033[0m"
BOLD = "\033[1m"
DIM = "\033[2m"
RED = "\033[31m"
B_RED = "\033[1;31m"
GREEN = "\033[32m"
B_GREEN = "\033[1;32m"
YELLOW = "\033[33m"
B_YELLOW = "\033[1;33m"
BLUE = "\033[34m"
B_BLUE = "\033[1;34m"
MAGENTA = "\033[35m"
B_MAGENTA = "\033[1;35m"
CYAN = "\033[36m"
B_CYAN = "\033[1;36m"
GRAY = "\033[90m"
DIV = f" {GRAY}│{NC} "

_ANSI_RE = re.compile(r"\x1b\[[0-9;]*m")
_CTRL_RE = re.compile(r"[\x00-\x1f\x7f]+")
_USER_REQ_RE = re.compile(r"<USER_REQUEST>\s*(.*?)\s*</USER_REQUEST>", re.DOTALL)
_BRACKET_TAG_RE = re.compile(r"^\[([^\[\]\n]{2,40})\]")


def strip_ansi(s: str) -> str:
    return _ANSI_RE.sub("", s)


def _char_width(ch: str) -> int:
    cp = ord(ch)
    if cp < 32 or (0x7F <= cp < 0xA0):
        return 0
    if 0xFE00 <= cp <= 0xFE0F or 0xE0100 <= cp <= 0xE01EF or unicodedata.combining(ch):
        return 0
    if unicodedata.east_asian_width(ch) in ("W", "F") or 0x1F300 <= cp <= 0x1FAFF:
        return 2
    return 1


def visual_len(s: str) -> int:
    return sum(_char_width(ch) for ch in strip_ansi(s))


def format_tokens(n: int) -> str:
    if n >= 1_000_000:
        val = n / 1_000_000
        return f"{val:.1f}M".replace(".0M", "M")
    elif n >= 1_000:
        val = n / 1_000
        return f"{val:.1f}k".replace(".0k", "k")
    return str(n)


def clean_one_line(s: str) -> str:
    return " ".join(_CTRL_RE.sub(" ", s).split())


def shorten_label(text: str, max_len: int = 25) -> str:
    text = clean_one_line(text)
    if len(text) <= max_len:
        return text
    limit = max(1, max_len - 1)
    chunk = text[:limit]
    last_space = chunk.rfind(" ")
    if last_space >= max_len // 2:
        chunk = chunk[:last_space]
    return chunk.rstrip(" -–—,:;.") + "…"


def _runtime_base_dir(uid: int) -> str:
    rt_base = os.environ.get("XDG_RUNTIME_DIR") or ""
    if rt_base and os.path.isdir(rt_base) and os.access(rt_base, os.W_OK):
        return rt_base
    if sys.platform.startswith("linux"):
        linux_rt = f"/run/user/{uid}"
        if os.path.isdir(linux_rt) and os.access(linux_rt, os.W_OK):
            return linux_rt
    tmpdir = os.environ.get("TMPDIR") or "/tmp"
    return os.path.join(tmpdir.rstrip("/"), f"cli-statusline-{uid}")


def _cache_file_path(conv_id: str) -> str:
    uid = os.getuid()
    rt_base = _runtime_base_dir(uid)
    cache_dir = os.path.join(rt_base, "pane-title")
    os.makedirs(cache_dir, mode=0o700, exist_ok=True)

    tmux_pane = os.environ.get("TMUX_PANE", "").strip()
    if tmux_pane:
        key = f"pane_{re.sub(r'[^A-Za-z0-9_-]', '', tmux_pane)}"
    else:
        try:
            rdev = os.stat("/dev/tty").st_rdev
            key = f"tty_{rdev}"
        except Exception:
            safe_conv = re.sub(r"[^A-Za-z0-9_-]", "", conv_id or "default")[:48]
            key = f"conv_{safe_conv}"
    return os.path.join(cache_dir, f"{key}.json")


def _load_cache(path: str) -> dict:
    try:
        with open(path, "r", encoding="utf-8") as f:
            obj = json.load(f)
            return obj if isinstance(obj, dict) else {}
    except Exception:
        return {}


def _save_cache(path: str, cache: dict):
    tmp_path = f"{path}.tmp.{os.getpid()}"
    try:
        with open(tmp_path, "w", encoding="utf-8") as f:
            json.dump(cache, f, separators=(",", ":"))
        os.replace(tmp_path, path)
    except Exception:
        try:
            os.unlink(tmp_path)
        except Exception:
            pass


def _lookup_db_title(conv_id: str, transcript_path: str) -> str:
    """Reads the auto-generated conversation title from conversation_summaries.db if present."""
    if not conv_id or not transcript_path or "/brain/" not in transcript_path:
        return ""
    app_dir = transcript_path.split("/brain/", 1)[0]
    db_path = os.path.join(app_dir, "conversation_summaries.db")
    if not os.path.isfile(db_path):
        return ""
    try:
        import sqlite3

        conn = sqlite3.connect(f"file:{db_path}?mode=ro", uri=True, timeout=0.05)
        try:
            row = conn.execute(
                "SELECT title FROM conversation_summaries WHERE conversation_id = ? LIMIT 1",
                (conv_id,),
            ).fetchone()
        finally:
            conn.close()
        if row and row[0]:
            return shorten_label(str(row[0]), max_len=25)
    except Exception:
        pass
    return ""


def _extract_first_prompt_label(transcript_path: str) -> str:
    """Extracts a concise topic label from the first USER_INPUT step in transcript.jsonl."""
    if not transcript_path or not os.path.isfile(transcript_path):
        return ""
    try:
        with open(transcript_path, "r", encoding="utf-8", errors="replace") as f:
            for _ in range(15):
                line = f.readline(16384)
                if not line:
                    break
                if '"USER_INPUT"' not in line and '"USER_EXPLICIT"' not in line:
                    continue
                step = json.loads(line)
                if step.get("type") != "USER_INPUT":
                    continue
                content = str(step.get("content") or "")
                m = _USER_REQ_RE.search(content)
                text = m.group(1) if m else content
                text = text.strip()
                if not text:
                    continue
                tag_match = _BRACKET_TAG_RE.match(text)
                if tag_match:
                    return shorten_label(tag_match.group(1), max_len=28)
                first_line = next(
                    (ln.lstrip("#*>- ").strip() for ln in text.splitlines() if ln.strip()),
                    "",
                )
                if first_line:
                    return shorten_label(first_line, max_len=24)
    except Exception:
        pass
    return ""


def _extract_vcs_label(vcs: dict, cwd: str) -> str:
    vcs_type = str(vcs.get("type") or "")
    label = str(vcs.get("branch") or vcs.get("client") or "")
    if not label and cwd and vcs_type in ("", "git"):
        curr = cwd
        while curr and curr != "/":
            git_entry = os.path.join(curr, ".git")
            head_file = os.path.join(git_entry, "HEAD")
            if os.path.isfile(git_entry):
                try:
                    with open(git_entry, "r", encoding="utf-8") as gf:
                        line = gf.read().strip()
                    if line.startswith("gitdir:"):
                        gitdir = line.split(":", 1)[1].strip()
                        if not os.path.isabs(gitdir):
                            gitdir = os.path.normpath(os.path.join(curr, gitdir))
                        head_file = os.path.join(gitdir, "HEAD")
                except Exception:
                    pass
            if os.path.isfile(head_file):
                try:
                    with open(head_file, "r", encoding="utf-8") as f:
                        head_val = f.read().strip()
                    if head_val.startswith("ref: refs/heads/"):
                        b = head_val[len("ref: refs/heads/") :]
                        if b != ".invalid":
                            label = b
                except Exception:
                    pass
                break
            parent = os.path.dirname(curr)
            if parent == curr:
                break
            curr = parent
    return label


def _workspace_fallback_label(data: dict) -> str:
    cwd = str(data.get("cwd") or (data.get("workspace") or {}).get("current_dir") or "")
    if cwd:
        home = os.path.expanduser("~")
        if cwd == home:
            return "~"
        base = os.path.basename(cwd.rstrip("/"))
        if base:
            return shorten_label(base, max_len=25)
    return ""


def resolve_session_name(data: dict, cache: dict, now: float) -> str:
    explicit = clean_one_line(str(data.get("conversation_title") or ""))
    if explicit:
        return shorten_label(explicit, max_len=32)

    conv_id = str(data.get("conversation_id") or data.get("session_id") or "").strip()
    transcript_path = str(data.get("transcript_path") or "").strip()
    if conv_id:
        if cache.get("conv_id") != conv_id:
            cache["conv_id"] = conv_id
            cache.pop("auto_title", None)
            cache.pop("auto_source", None)
            cache.pop("db_checked_at", None)

        if cache.get("auto_source") == "db" and cache.get("auto_title"):
            return str(cache["auto_title"])

        last_db_check = float(cache.get("db_checked_at") or 0.0)
        if now - last_db_check >= 2.0:
            cache["db_checked_at"] = now
            db_title = _lookup_db_title(conv_id, transcript_path)
            if db_title:
                cache["auto_title"] = db_title
                cache["auto_source"] = "db"
                return db_title

        if cache.get("auto_title"):
            return str(cache["auto_title"])

        prompt_label = _extract_first_prompt_label(transcript_path)
        if prompt_label:
            cache["auto_title"] = prompt_label
            cache["auto_source"] = "transcript"
            return prompt_label

    return _workspace_fallback_label(data)


def classify_state(data: dict) -> tuple[str, str, str]:
    """Returns (state_bucket, emoji, fallback_text) for terminal/tmux title."""
    confirmation_pending = bool(data.get("tool_confirmation_pending"))
    agent_state = str(data.get("agent_state") or "idle").lower()
    task_count = int(data.get("task_count") or 0)
    subagents = data.get("subagents") or []
    running_subagents = sum(
        1 for sa in subagents if isinstance(sa, dict) and sa.get("status") == "running"
    )

    if confirmation_pending or agent_state in ("tool_use", "authenticating"):
        return ("needs_input", "🔔\uFE0F", "Needs Input")
    if agent_state == "error":
        return ("error", "❌\uFE0F", "Error")
    if (
        agent_state in ("thinking", "working", "initializing")
        or task_count > 0
        or running_subagents > 0
    ):
        return ("running", "⏳\uFE0F", "Agent Running")
    return ("idle", "✅\uFE0F", "Agent Idle")


def update_tab_title(data: dict):
    """Updates Kitty / tmux pane title via OSC 2 with edge-triggered bells & deduped writes."""
    conv_id = str(data.get("conversation_id") or data.get("session_id") or "").strip()
    now = time.time()

    cache_path = ""
    cache: dict = {}
    try:
        cache_path = _cache_file_path(conv_id)
        cache = _load_cache(cache_path)
    except Exception:
        cache = {}
    orig_snapshot = dict(cache)

    bucket, emoji, fallback = classify_state(data)
    session_name = resolve_session_name(data, cache, now)
    title = f"{emoji} {session_name or fallback}"

    prev_bucket = cache.get("bucket")
    if bucket == "needs_input":
        bell = "\a" if prev_bucket != "needs_input" else ""
    elif bucket in ("idle", "error"):
        bell = "\a" if prev_bucket == "running" else ""
    else:
        bell = ""

    prev_title = cache.get("pane_title")
    last_tty_write = float(cache.get("tty_written_at") or 0.0)
    if bell or title != prev_title or (now - last_tty_write) > 30.0:
        try:
            with open("/dev/tty", "w") as tty:
                tty.write(f"\033]2;{title}\007{bell}")
                tty.flush()
            cache["pane_title"] = title
            cache["tty_written_at"] = now
        except Exception:
            pass

    cache["bucket"] = bucket
    if cache_path and cache != orig_snapshot:
        _save_cache(cache_path, cache)


def _format_display_cwd(cwd: str, home: str) -> str:
    if not cwd:
        return ""
    if cwd == home:
        return "~"
    if cwd.startswith(home + "/"):
        return "~/" + cwd[len(home) + 1 :]
    return cwd


def format_statusline(data: dict) -> str:
    agent_state = str(data.get("agent_state") or "idle").lower()
    confirmation_pending = bool(data.get("tool_confirmation_pending"))
    task_count = int(data.get("task_count") or 0)
    subagents = data.get("subagents") or []
    running_subagents = [
        sa for sa in subagents if isinstance(sa, dict) and sa.get("status") == "running"
    ]
    running_subagent_count = len(running_subagents)
    pending_input_count = int(data.get("pending_input_count") or 0)
    artifact_count = int(data.get("artifact_count") or 0)
    cols = int(data.get("terminal_width") or 80)

    if confirmation_pending or agent_state == "tool_use":
        state_fmt = f"{B_RED}🔔 NEEDS INPUT{NC}"
    elif agent_state == "authenticating":
        state_fmt = f"{B_RED}🔑 AUTH{NC}"
    elif agent_state in ("idle", "reviewing"):
        if task_count > 0 or running_subagent_count > 0:
            state_fmt = f"{B_YELLOW}● WAITING{NC}"
        else:
            state_fmt = f"{B_GREEN}● READY{NC}"
    elif agent_state == "thinking":
        state_fmt = f"{B_YELLOW}◆ THINKING{NC}"
    elif agent_state == "working":
        state_fmt = f"{B_CYAN}⚙ WORKING{NC}"
    elif agent_state == "initializing":
        state_fmt = f"{B_BLUE}⏳ INIT{NC}"
    elif agent_state == "error":
        state_fmt = f"{B_RED}❌ ERROR{NC}"
    else:
        state_fmt = f"{B_BLUE}⏳ {agent_state.upper()}{NC}"

    model_obj = data.get("model")
    model_name = ""
    model_id = ""
    effort = ""
    if isinstance(model_obj, dict):
        model_name = str(model_obj.get("display_name") or model_obj.get("id") or "")
        model_id = str(model_obj.get("id") or "")
        effort = str(model_obj.get("effort") or "")
    elif isinstance(model_obj, str):
        model_name = model_obj

    if effort and effort.lower() not in model_name.lower():
        model_name = f"{model_name} · {effort}"

    quota_obj = data.get("quota") or {}
    quota_fmt = ""
    if isinstance(quota_obj, dict) and quota_obj:
        matched_quota = None
        if model_id and model_id in quota_obj:
            matched_quota = quota_obj[model_id]
        else:
            for k, v in quota_obj.items():
                if k and model_id and (k in model_id or model_id in k):
                    matched_quota = v
                    break
        if isinstance(matched_quota, dict):
            rem_frac = matched_quota.get("remaining_fraction")
            if rem_frac is not None:
                try:
                    pct = int(float(rem_frac) * 100)
                    quota_fmt = f" ({pct}%)"
                except Exception:
                    pass

    model_fmt = f"{MAGENTA}{model_name}{quota_fmt}{NC}" if model_name else ""

    ctx = data.get("context_window") or {}
    used_pct = ctx.get("used_percentage")
    total_in = (
        ctx.get("total_input_tokens")
        or (ctx.get("current_usage") or {}).get("input_tokens")
        or 0
    )
    ctx_size = ctx.get("context_window_size") or 0
    cached_in = (ctx.get("current_usage") or {}).get("cache_read_input_tokens") or 0

    ctx_fmt = ""
    if used_pct is not None or total_in > 0:
        try:
            pct_val = float(
                used_pct
                if used_pct is not None
                else (total_in / ctx_size * 100 if ctx_size else 0)
            )
        except Exception:
            pct_val = 0.0

        if pct_val < 50:
            pct_color = GREEN
        elif pct_val < 75:
            pct_color = YELLOW
        else:
            pct_color = RED

        tokens_str = ""
        if total_in > 0 and ctx_size > 0:
            tokens_str = f" ({format_tokens(total_in)}/{format_tokens(ctx_size)})"
        elif total_in > 0:
            tokens_str = f" ({format_tokens(total_in)})"

        cache_str = ""
        if cached_in > 0:
            cache_str = f" {GRAY}⚡{format_tokens(cached_in)}{NC}"

        ctx_fmt = f"🪟 {pct_color}{pct_val:.1f}%{NC}{tokens_str}{cache_str}"

    cwd = str(data.get("cwd") or (data.get("workspace") or {}).get("current_dir") or "")
    vcs = data.get("vcs") if isinstance(data.get("vcs"), dict) else {}
    vcs_label = _extract_vcs_label(vcs, cwd)
    dirty = "*" if vcs.get("dirty") else ""

    home = os.path.expanduser("~")
    dir_fmt = ""
    if cwd:
        disp_cwd = _format_display_cwd(cwd, home)
        if vcs_label:
            dir_fmt = f"📁 {CYAN}{disp_cwd}{NC} ({BLUE}{vcs_label}{dirty}{NC})"
        else:
            dir_fmt = f"📁 {CYAN}{disp_cwd}{dirty}{NC}"

    extras = []
    if task_count > 0:
        extras.append(f"⏳ {BLUE}Tasks: {task_count}{NC}")
    if running_subagent_count > 0:
        names = ", ".join(sa.get("name") for sa in running_subagents if sa.get("name"))
        sa_label = f" ({names})" if names else ""
        extras.append(f"👥 {BLUE}Agents: {running_subagent_count}{sa_label}{NC}")
    if pending_input_count > 0:
        extras.append(f"📨 {YELLOW}Queued: {pending_input_count}{NC}")
    if artifact_count > 0:
        extras.append(f"📄 {MAGENTA}Artifacts: {artifact_count}{NC}")

    badges = []
    vim = data.get("vim") or {}
    if isinstance(vim, dict) and vim.get("mode"):
        badges.append(f"{B_YELLOW}[{vim['mode']}]{NC}")
    exec_mode = str(data.get("cycle_mode") or data.get("execution_mode") or "")
    if exec_mode and exec_mode.lower() not in ("default", "normal"):
        badges.append(f"{B_CYAN}[{exec_mode.upper()}]{NC}")
    sandbox = data.get("sandbox") or {}
    if isinstance(sandbox, dict) and sandbox.get("enabled"):
        badges.append(f"{B_GREEN}[SANDBOX]{NC}")

    parts = [state_fmt]
    if badges:
        parts.extend(badges)
    if model_fmt:
        parts.append(model_fmt)
    if ctx_fmt:
        parts.append(ctx_fmt)
    if extras:
        parts.extend(extras)
    if dir_fmt:
        parts.append(dir_fmt)

    single_line = " " + DIV.join(parts)
    telemetry_reserve = 16 if data.get("telemetry") else 0
    if visual_len(single_line) <= max(40, cols - telemetry_reserve):
        return single_line

    top_parts = [state_fmt] + badges
    if model_fmt:
        top_parts.append(model_fmt)
    if ctx_fmt:
        top_parts.append(ctx_fmt)

    bottom_parts = []
    if extras:
        bottom_parts.extend(extras)
    if dir_fmt:
        bottom_parts.append(dir_fmt)

    top_line = f"{GRAY}╭─{NC} " + DIV.join(top_parts)
    bottom_line = f"{GRAY}╰─{NC} " + DIV.join(bottom_parts) if bottom_parts else ""

    if bottom_line:
        return f"{top_line}\n{bottom_line}"
    return top_line


def main():
    try:
        data = json.load(sys.stdin)
    except Exception:
        data = {}

    if not isinstance(data, dict):
        data = {}

    update_tab_title(data)

    try:
        print(format_statusline(data))
    except Exception:
        state = str(data.get("agent_state") or "idle")
        print(f" {state}")


if __name__ == "__main__":
    main()
