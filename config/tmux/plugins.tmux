# vim:ft=tmux

set -g @thumbs-position off_left
set -g @thumbs-contrast 1
set -g @thumbs-osc52 1

set-environment -g TMUX_THUMBS_PATH "$XDG_CACHE_HOME/tmux-thumbs"
if-shell -b '[ ! -d $TMUX_THUMBS_PATH ]' {
  run-shell "git clone --depth 1 https://github.com/fcsonline/tmux-thumbs $TMUX_THUMBS_PATH"
}
if-shell -b '[ -f $TMUX_THUMBS_PATH/tmux-thumbs.tmux ]' {
  run-shell "$TMUX_THUMBS_PATH/tmux-thumbs.tmux"
}
