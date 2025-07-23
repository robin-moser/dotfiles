# vi: ft=tmux

# Open Opencode on floating popup
bind o run-shell '
    current_path="#{pane_current_path}"
    # create session name based on current path
    oc_session_name="opencode-$(echo "#{pane_current_path}" | sed "s|.*/\([^/]*\)/\([^/]*\)$|\1-\2|")"
    # replace all special chars in oc_session_name with underscore
    oc_session_name=$(echo "$oc_session_name" | sed "s|[^a-zA-Z0-9_-]|_|g")

    # if currently in popup session, detach it again
    if [ "#{session_name}" = "$oc_session_name" ]; then
        tmux detach-client
    else

        # if opencode is in current session running, break it into extra session
        oc_pane_id=$(tmux list-panes -s -f "##{m:##{pane_start_command},opencode}" -F "##{pane_id}")
        if [ -n "$oc_pane_id" ]; then
            tmux new-session -d -s "$oc_session_name" -c "$current_path" sleep .2
            tmux break-pane -s "$oc_pane_id" -t "$oc_session_name" -n oc
            tmux display-popup \
                -E -w 40% -h 90% "tmux new-session -c \"$current_path\" -A -s \"$oc_session_name\" opencode"

        # no opencode available yet, create session and attach it to popup
        else
            tmux new-session -d -s "$oc_session_name" -c "$current_path" \
                -e "EDITOR=vim" -n oc opencode
            tmux display-popup -E -w 40% -h 90% "tmux new-session -c \"$current_path\" -A -s \"$oc_session_name\" opencode"

        fi
    fi
'

# Open Opencode in right split
bind p run-shell '
    current_path="#{pane_current_path}"
    # create session name based on current path
    oc_session_name="opencode-$(echo "#{pane_current_path}" | sed "s|.*/\([^/]*\)/\([^/]*\)$|\1-\2|")"
    # replace all special chars in oc_session_name with underscore
    oc_session_name=$(echo "$oc_session_name" | sed "s|[^a-zA-Z0-9_-]|_|g")

    # if currently in popup session, do nothing
    if [ "#{session_name}" = "$oc_session_name" ]; then
        tmux detach-client
    else

        # if opencode is extra session running, join it to current window as right split
        if tmux has-session -t "$oc_session_name" 2>/dev/null; then
            tmux join-pane -s "$oc_session_name:oc.1" -h -f -l 75

        else

            # if opencode is in current session running, break it into extra session
            oc_pane_id=$(tmux list-panes -s -f "##{m:##{pane_start_command},opencode}" -F "##{pane_id}")
            if [ -n "$oc_pane_id" ]; then
                tmux new-session -d -s "$oc_session_name" -c "$current_path" sleep .2
                tmux break-pane -s "$oc_pane_id" -t "$oc_session_name" -n oc

            # Create new opencode session and join its pane to current window as right split
            else
                tmux new-session -d -s "$oc_session_name" -c "$current_path" \
                    -e "EDITOR=vim" -n oc opencode
                # echo 1: $?, $oc_session_name, $current_path
                tmux join-pane -s "$oc_session_name:oc.1" -t "#{session_name}:#{window_index}" -h -f -l 75

            fi
        fi
    fi
'
