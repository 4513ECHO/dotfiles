# vim:ft=tmux

set -g @thumbs-position off_left
set -g @thumbs-contrast 1
set -g @thumbs-osc52 1

%hidden TMUX_THUMBS_PATH="$XDG_CACHE_HOME/tmux-thumbs"
if-shell -b "[ -x $TMUX_THUMBS_PATH/tmux-thumbs.tmux ]" {
  run-shell -b "$TMUX_THUMBS_PATH/tmux-thumbs.tmux"
} {
  run-shell -b "git clone --filter=blob:none https://github.com/fcsonline/tmux-thumbs $TMUX_THUMBS_PATH"
}
