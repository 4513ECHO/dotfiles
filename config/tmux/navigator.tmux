# vim:ft=tmux

# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
%hidden is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"

bind -n M-h if-shell "$is_vim" { send-keys M-h } { select-pane -L }
bind -n M-j if-shell "$is_vim" { send-keys M-j } { select-pane -D }
bind -n M-k if-shell "$is_vim" { send-keys M-k } { select-pane -U }
bind -n M-l if-shell "$is_vim" { send-keys M-l } { select-pane -R }
