# vim:ft=tmux

# status line
set  -g status-interval 1
set  -g status-position top
set  -g status-justify centre
set  -g status-style fg=colour246,bg=colour235

set  -g status-left-length 35
set  -g status-left "Session: #{session_name}"

set  -g status-right \
    "#[dim]#(cut -d' ' -f1 /proc/loadavg) [%m/%d(%a) %H:%M:%S]#[default]"

# window status
setw -g window-status-format "#{window_index}: #{window_name}"
setw -g window-status-current-format \
    "#[#{?client_prefix,reverse,}]#{window_index}: #{window_name}#[default]"
setw -g window-status-current-style bright
setw -g window-status-style dim
setw -g window-status-separator "|"

# message
set  -g message-style fg=colour235,bg=colour246
set  -g message-command-style fg=colour246,bg=colour235
set  -g mode-style fg=colour235,bg=colour246

# pane border
set  -g pane-border-style fg=colour239
set  -g pane-border-format \
    "#{pane_index}: #{pane_title} (#{pane_tty}) \
#[bright]#{?window_zoomed_flag,zoomed,}#[default]"
set  -g pane-border-status top
set  -g pane-active-border-style fg=colour246

# clock
set  -g display-panes-active-colour colour246
set  -g display-panes-colour colour239
setw -g clock-mode-colour colour246
