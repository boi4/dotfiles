#!/usr/bin/env python3
import sys
import re

def filter_vim_trailing_tilde(text):
    """
    Filter out trailing tildes that come from vim.
    """
    vim_tilde_pattern = re.compile(r'^\~\s*$\n?', re.MULTILINE)
    return vim_tilde_pattern.sub('', text)

def is_tmux_output(lines):
    """
    Check if lines are part of tmux padding output
    """
    tmux_padding_pattern = re.compile(r'│·+$')
    tmux_endline_pattern = re.compile(r'─┘·+$')
    tmux_bottomline_pattern = re.compile(r'^·*$')
    lineno = 0
    while lineno < len(lines) - 1: # ignore last line
        line = lines[lineno]
        if tmux_endline_pattern.search(line):
            lineno += 1
            break
        if not tmux_padding_pattern.search(line):
            return False
        lineno += 1
    while lineno < len(lines) - 1:
        line = lines[lineno]
        if not tmux_bottomline_pattern.search(line):
            return False
        lineno += 1
    return True

def filter_tmux_padding(text):
    lines = text.split('\n')
    if is_tmux_output(lines):
        # Strip " *│·+" from each line and remove endline and bottomlines
        cleaned_lines = []
        for line in lines:
            # Skip endline pattern and bottomlines
            if re.search(r'─┘·+$', line) or re.fullmatch(r'·*', line):
                continue
            # Strip padding from the line
            cleaned_lines.append(re.sub(r' *│·+$', '', line))
        return '\n'.join(cleaned_lines)
    return text

def filter_zsh_unhappy(text):
    """
    Trim trailing spaces from each line.
    """
    return re.sub(r' +:\($', '', text, flags=re.MULTILINE)


def trim_trailing_spaces(text):
    """
    Trim trailing spaces from each line with actual content, except the last line.
    """
    lines = text.split('\n')
    if len(lines) <= 1:
        return text
    
    cleaned_lines = [re.sub(r'(?<=\S) +$', '', line) for line in lines[:-1]]
    cleaned_lines.append(lines[-1])  # Append the last line without modification
    
    return '\n'.join(cleaned_lines)


if __name__ == "__main__":
    # Read input from stdin
    input_text = sys.stdin.read()
    if len(input_text) < 4*1024: # don't filter text > 4kb
        # Apply each filter to the input text
        cleaned_text = filter_vim_trailing_tilde(input_text)
        if input_text != cleaned_text:
            print("filtered vim trailing", file=sys.stderr)

        input_text = cleaned_text
        cleaned_text = filter_tmux_padding(input_text)
        if input_text != cleaned_text:
            print("filtered tmux padding", file=sys.stderr)

        input_text = cleaned_text
        cleaned_text = trim_trailing_spaces(input_text)
        if input_text != cleaned_text:
            print("filtered trailing_spaces", file=sys.stderr)

        input_text = cleaned_text
        cleaned_text = filter_zsh_unhappy(input_text)
        if input_text != cleaned_text:
            print("filtered zsh unhappy", file=sys.stderr)

        # Print the cleaned text to stdout
        sys.stdout.write(cleaned_text)
