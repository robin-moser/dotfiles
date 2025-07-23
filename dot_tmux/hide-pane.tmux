# vi: ft=tmux

# Hide current pane by moving it to a new session _hidden_panes
bind-key Enter run-shell '
    hidden_session_name="hidden-panes"

    # if hidden session exists, restore the last pane with its original dimensions and position
    if tmux has-session -t "$hidden_session_name" 2>/dev/null; then
        last_window=$(tmux list-windows -t "$hidden_session_name" -F "##{window_name}" | tail -n 1)
        last_pane=$(tmux list-panes -t "$hidden_session_name" -F "##{window_index}.##{pane_id}" | tail -n 1)

        # Parse window name format: hidden-WIDTHxHEIGHT-POSITION
        if echo "$last_window" | grep -q "hidden-[0-9]*x[0-9]*-[01]*m\?\$"; then

            read -r width height position marked \
                <<< "$(echo "$last_window" | sed -E "s/hidden-([0-9]+)x([0-9]+)-([01]*)(m?)\$/\1 \2 \3 \4/")"

            case "$position" in
                # full width/height
                11?1) # top, full width
                tmux join-pane -s "$hidden_session_name:$last_pane" \
                    -t "#{session_name}:#{window_index}.#{pane_id}" -v -f -l "$height" -b ;;
                ?111) # bottom, full width
                tmux join-pane -s "$hidden_session_name:$last_pane" \
                    -t "#{session_name}:#{window_index}.#{pane_id}" -v -f -l "$height" ;;

                1?11) # left, full height
                tmux join-pane -s "$hidden_session_name:$last_pane" \
                    -t "#{session_name}:#{window_index}.#{pane_id}" -h -f -l "$width" -b ;;
                111?) # right, full height
                tmux join-pane -s "$hidden_session_name:$last_pane" \
                    -t "#{session_name}:#{window_index}.#{pane_id}" -h -f -l "$width" ;;

                # corners
                11??) # top right
                pane=$(tmux list-panes -t "#{session_name}:#{window_index}" -F "##{pane_id},##{<:pane_width,pane_height},##{pane_at_top}##{pane_at_right}##{pane_at_bottom}##{pane_at_left}" | grep ",11.." | head -n 1)
                id=$(echo "$pane" | cut -d, -f1)
                orientation=$(echo "$pane" | cut -d, -f2)
                tmux join-pane -s "$hidden_session_name:$last_pane" \
                    -t "#{session_name}:#{window_index}.$id" -v -l "$height" -b ;;

                ?11?) # bottom right
                pane=$(tmux list-panes -t "#{session_name}:#{window_index}" -F "##{pane_id},##{<:pane_width,pane_height},##{pane_at_top}##{pane_at_right}##{pane_at_bottom}##{pane_at_left}" | grep ",.11." | head -n 1)
                id=$(echo "$pane" | cut -d, -f1)
                orientation=$(echo "$pane" | cut -d, -f2)
                tmux join-pane -s "$hidden_session_name:$last_pane" \
                    -t "#{session_name}:#{window_index}.$id" -v -l "$height" ;;


                ??11) # bottom left
                pane=$(tmux list-panes -t "#{session_name}:#{window_index}" -F "##{pane_id},##{<:pane_width,pane_height},##{pane_at_top}##{pane_at_right}##{pane_at_bottom}##{pane_at_left}" | grep ",..11" | head -n 1)
                id=$(echo "$pane" | cut -d, -f1)
                orientation=$(echo "$pane" | cut -d, -f2)
                tmux join-pane -s "$hidden_session_name:$last_pane" \
                    -t "#{session_name}:#{window_index}.$id" -v -l "$height" ;;

                1??1) # top left
                pane=$(tmux list-panes -t "#{session_name}:#{window_index}" -F "##{pane_id},##{<:pane_width,pane_height},##{pane_at_top}##{pane_at_right}##{pane_at_bottom}##{pane_at_left}" | grep ",1..1" | head -n 1)
                id=$(echo "$pane" | cut -d, -f1)
                orientation=$(echo "$pane" | cut -d, -f2)
                tmux join-pane -s "$hidden_session_name:$last_pane" \
                    -t "#{session_name}:#{window_index}.$id" -v -l "$height" -b ;;

                *) tmux join-pane -s "$hidden_session_name:$last_pane" -t "#{session_name}:#{window_index}" -d ;;
            esac

            # if the last pane was marked, mark the current pane
            if [ "$marked" = "m" ]; then
                tmux select-pane -m -t "#{session_name}:#{window_index}.${last_pane/*.}"
            fi
        fi

    else
        # if one pane is marked, use it as source
        if [ "#{pane_marked_set}" -eq 1 ]; then

            echo "marked pane found, using it as source" >> ~/tmux.log
            marked_pane=$(tmux list-panes -f "##{?##{pane_marked},1,0}" \
                -F "##{pane_id},##{pane_width},##{pane_height},##{pane_at_top}##{pane_at_right}##{pane_at_bottom}##{pane_at_left}" \
                -t "#{session_name}:#{window_index}")
            pane_id=$(echo "$marked_pane" | cut -d, -f1)
            pane_width=$(echo "$marked_pane" | cut -d, -f2)
            pane_height=$(echo "$marked_pane" | cut -d, -f3)
            pane_pos=$(echo "$marked_pane" | cut -d, -f4)
            window_name="hidden-${pane_width}x${pane_height}-${pane_pos}m"
        #  else, use the current pane
        else
            pane_id="#{session_name}:#{window_index}.#{pane_id}"
            window_name="hidden-#{pane_width}x#{pane_height}-#{pane_at_top}#{pane_at_right}#{pane_at_bottom}#{pane_at_left}"
        fi
        # Save current pane with its dimensions and position encoded in window name
        tmux new-session -d -s "$hidden_session_name" sleep .2
        tmux break-pane -d -a -s "$pane_id" -t "$hidden_session_name:0" -n "$window_name"
    fi
'
