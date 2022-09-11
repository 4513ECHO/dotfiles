# vim:ft=tmux

# prefix key
set -g prefix C-q
unbind C-b
unbind q
bind C-q send-prefix

bind c new-window -c '#{pane_current_path}'
bind v split-window -h -c '#{pane_current_path}'
bind s split-window -v -c '#{pane_current_path}'
bind o select-pane -t :.+
bind h select-pane -L
bind j select-pane -D
bind k select-pane -U
bind l select-pane -R
bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5
bind x kill-pane
bind X confirm-before -p "kill-window #{window_name}? (y/n)" kill-window
bind r source-file ~/.config/tmux/tmux.conf \
    \; refresh-client \
    \; display-message "Reloaded tmux.conf"
bind w choose-tree -Z
bind '=' select-layout tiled
bind y setw synchronize-panes
bind i run-shell -b '~/dotfiles/bin/tmux-input'
# bind i run-shell '~/dotfiles/bin/tovim_tmux'

# copy mode
bind C-v copy-mode
setw -g mode-keys vi
bind -T copy-mode-vi v send-keys -X begin-selection

# aliases
# from https://github.com/tmux/tmux/issues/3088
# set -s command-alias[99] 'load-buffer=load-buffer -w'
