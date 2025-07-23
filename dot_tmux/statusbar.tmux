# vi: ft=tmux

# Tooggle status bar visibility
bind u if-shell 'tmux show-options -g | grep -q "status 2"' \
    'set -g status off' \
    'set -g status 2'

set -g status-interval 1
set -g status-left-length 120
set -g status-right-length 120
set -g status-justify absolute-centre
set -g status-position bottom

# check if status-set is not already set
if -F '#{?@@status-set,0,1}' {
    set -g status 2
    set -Fg 'status-format[1]' '#{status-format[0]}'
    set -g 'status-format[0]' ''
    # set global variable to indicate that status is set
    set -g @@status-set 1
}

# left side in status bar
set -g status-left "#(~/.tmux/scripts/get-timetagger-status.sh \
    '#{barcolor}' '#{accentcolor}' \
    '#{primarycolor}' '#{primarycolortext}' \
    '#{secondarycolor}' '#{secondarycolortext}' \
  )"

# right side in status bar
set -g status-right \
"#[fg=$secondarycolor]#[bg=$secondarycolor] #[fg=$primarycolortext]%d %b %Y #[fg=$primarycolor]\
#[fg=$primarycolortext,bg=$primarycolor] %H:%M:%S #[bg=$barcolor,fg=$primarycolor]  "

set -g window-status-current-format \
"#[bg=$barcolor]#[fg=$accentcolor] #[bg=$accentcolor]#[fg=$accentcolortext]  \
#W (#{s,.*/,,:pane_current_path})  #[fg=$accentcolor]#[bg=$barcolor] "

set -g window-status-format \
"#[bg=$barcolor]#[fg=$primarycolor] \
#{?window_bell_flag,#[fg=#fcc000],#{?window_activity_flag,#[fg=#bbbbbb],#[fg=$primarycolortext]}}\
#[bg=$primarycolor]  #W (#{s,.*/,,:pane_current_path})  #[bg=$barcolor]#[fg=$primarycolor] "
