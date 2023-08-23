#!/usr/bin/env sh
#
# this script was taken from https://www.reddit.com/r/i3wm/comments/qzqjvy/script_launch_application_on_specific_workspace/
# however, it does not properly work

timeout=5

help() {
    echo "${0##*/} <[-e command]> [-c class] [-w workspace] [-t timeout] [-h]
    runs a program on specific workspace

-e  Command to execute
-c  Apply only to windows matching this class (optional)
-t  Terminate after this many seconds, (optional, default: $timeout)
-w  Workspace to run program in (optional, default: first word of 'command')
        [-w .]  will open on current workspace."
}

while getopts "e:c:t:w:h" opt; do
    case $opt in
    e) application=$OPTARG ;;
    c) class=$OPTARG ;;
    w) workspace=$OPTARG ;;
    t) timeout=$OPTARG ;;
    *) help; [ "$opt" = "h" ]; exit $(( $? * 13 )) ;;
    esac
done

[ -n "$application" ] || { help; exit 14; }
[ "$timeout" -gt 0  ] || { help; exit 15; }
: "${class:+and .container.window_properties.class=\"$class\"}"
: "${workspace:=${application%% *}}"
[ "$workspace" = . ] &&
    workspace=$(i3-msg -t get_workspaces | jq -r '.[]|select(.focused).name')

echo "$application"

i3-msg "exec $application"
timeout "$timeout" i3-msg -t subscribe -m '["window"]' |
    stdbuf -o0 jq -r "select(.change==\"new\" $class) |
    \"[con_id=\(.container.id)] move to workspace $workspace;\"" |
    xargs -I{} i3-msg {}
