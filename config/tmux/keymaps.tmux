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

bind -r N swap-pane -D
bind -r P swap-pane -U

bind x kill-pane
bind X confirm-before -p 'kill window "#{window_name}"? (y/n)' kill-window
bind r {
  source-file $XDG_CONFIG_HOME/tmux/tmux.conf
  refresh-client
  display-message 'tmux.conf is reloaded'
}
bind w choose-tree -Z
bind '=' select-layout tiled
bind y setw synchronize-panes
bind i run-shell -b '~/dotfiles/bin/tmux-input'

# copy mode
bind C-v copy-mode
setw -g mode-keys vi
bind -T copy-mode-vi v send-keys -X begin-selection
# Do not cancel selection
unbind -T copy-mode-vi MouseDragEnd1Pane
# Search incrementally
bind-key -T copy-mode-vi / command-prompt -iI '#{pane_search_string}' -p '(search down)' { send-keys -X search-forward-incremental '%%%' }
bind-key -T copy-mode-vi ? command-prompt -iI '#{pane_search_string}' -p '(search up)' { send-keys -X search-backward-incremental '%%%' }
