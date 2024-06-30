#!/bin/bash

# Previous clipboard content
previous_clipboard=""
while true; do
  # Get the current clipboard content
  current_clipboard=$(wl-paste)

  # If the clipboard content has changed
  if [ "$current_clipboard" != "$previous_clipboard" ]; then
    processed_clipboard=$(echo -n "$current_clipboard" | clipboard_filter.py)

    if [ "$current_clipboard" != "$processed_clipboard" ]; then
	    # Set the processed text back to the clipboard
	    echo "$processed_clipboard" | wl-copy
	    notify-send "Clipboard was filtered"
    fi

    # Update the previous clipboard content
    previous_clipboard="$processed_clipboard"
  fi

  # Sleep for a short period to prevent high CPU usage
  sleep 0.5
done
