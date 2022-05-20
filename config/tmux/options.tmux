# vim:ft=tmux

set -g default-shell "$SHELL"

# color
set -g  default-terminal "tmux-256color"
set -ga terminal-overrides ",$TERM:Tc"

# reduce delay
set  -sg escape-time 1
set  -g  repeat-time 500
set  -g  display-time 500
set  -g  display-panes-time 500

setw -g  monitor-activity on
set  -g  history-limit 5000
set  -wg automatic-rename on
set  -wg automatic-rename-format "#{pane_title}"
set  -g  renumber-windows on
set  -g  base-index 1
set  -g  pane-base-index 1
set  -g  focus-events on
set  -g  status-keys emacs
set  -sg set-clipboard on

# hooks
# set-hook -g cilent-resized 'select-layout tiled'
# set-hook -g pane-exited 'select-layout tiled'

