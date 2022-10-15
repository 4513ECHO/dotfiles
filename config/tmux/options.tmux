# vim:ft=tmux
set -g default-shell "$SHELL"

set -s  default-terminal 'tmux-256color'
set -sa terminal-features 'xterm*:RGB'
set -sa terminal-features 'xterm*:usstyle'
set -s  focus-events on
set -s  set-clipboard on
if-shell -b 'command -v xsel && [ -n "$DISPLAY" ]' {
  set -s copy-command 'xsel -b'
  bind ] run-shell 'tmux set-buffer -- "$(xsel -b)"; tmux paste-buffer'
}

set  -s escape-time 1
set  -g repeat-time 1000
set  -g display-time 2000
set  -g display-panes-time 2000

set  -g history-limit 10000
setw -g monitor-activity on
set  -g history-limit 5000
setw -g automatic-rename on
setw -g automatic-rename-format '#{pane_title}'
set  -g renumber-windows on
set  -g base-index 1
set  -g pane-base-index 1
set  -g status-keys emacs
set  -g mouse on

# hooks
# set-hook -g cilent-resized 'select-layout tiled'
# set-hook -g pane-exited 'select-layout tiled'
# set-hook -wg pane-set-clipborad {
#   display-message '#[bold]Copied!#[default]'
# }
