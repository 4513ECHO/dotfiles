# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'Morantron/tmux-fingers'

# plugin settings
set -g @fingers-main-action 'cb'
set -g @fingers-compact-hints 1
set -g @fingers-hint-format '#[fg=colour159,bold]%s'
set -g @fingers-highlight-format '#[fg=colour159,nobold,underscore]%s'
set -g @fingers-hint-position-nocompact 'left'
set -g @fingers-hint-format-nocompact '#[fg=colour159,bold][%s]'
set -g @fingers-highlight-format-nocompact '#[fg=colour159,nobold,underscore]%s'

set-environment -g TMUX_PLUGIN_MANAGER_PATH "$XDG_CACHE_HOME/tmux"

if '[ ! -d $TMUX_PLUGIN_MANAGER_PATH/tpm ]' \
  'run-shell "git clone --depth 1 https://github.com/tmux-plugins/tpm $TMUX_PLUGIN_MANAGER_PATH/tpm"'
if '[ -f $TMUX_PLUGIN_MANAGER_PATH/tpm/tpm ]' \
  'run-shell "$TMUX_PLUGIN_MANAGER_PATH/tpm/tpm"'

