# vim:ft=tmux

# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

bind -n C-w switch-client -T navigator
bind -T navigator C-w send-keys C-w

bind -T navigator h if-shell "$is_vim" "send-keys C-w h" "select-pane -L"
bind -T navigator j if-shell "$is_vim" "send-keys C-w j" "select-pane -D"
bind -T navigator k if-shell "$is_vim" "send-keys C-w k" "select-pane -U"
bind -T navigator l if-shell "$is_vim" "send-keys C-w l" "select-pane -R"

# NOTE: echo {'!'..'}'}
bind -T navigator '!' send-keys C-w '!'
bind -T navigator '"' send-keys C-w '"'
bind -T navigator '#' send-keys C-w '#'
bind -T navigator '$' send-keys C-w '$'
bind -T navigator '%' send-keys C-w '%'
bind -T navigator '&' send-keys C-w '&'
bind -T navigator "'" send-keys C-w "'"
bind -T navigator '(' send-keys C-w '('
bind -T navigator ')' send-keys C-w ')'
bind -T navigator '*' send-keys C-w '*'
bind -T navigator '+' send-keys C-w '+'
bind -T navigator ',' send-keys C-w ','
bind -T navigator '-' send-keys C-w '-'
bind -T navigator '.' send-keys C-w '.'
bind -T navigator '/' send-keys C-w '/'
bind -T navigator '0' send-keys C-w '0'
bind -T navigator '1' send-keys C-w '1'
bind -T navigator '2' send-keys C-w '2'
bind -T navigator '3' send-keys C-w '3'
bind -T navigator '4' send-keys C-w '4'
bind -T navigator '5' send-keys C-w '5'
bind -T navigator '6' send-keys C-w '6'
bind -T navigator '7' send-keys C-w '7'
bind -T navigator '8' send-keys C-w '8'
bind -T navigator '9' send-keys C-w '9'
bind -T navigator ':' send-keys C-w ':'
bind -T navigator ';' send-keys C-w ';'
bind -T navigator '<' send-keys C-w '<'
bind -T navigator '=' send-keys C-w '='
bind -T navigator '>' send-keys C-w '>'
bind -T navigator '?' send-keys C-w '?'
bind -T navigator '@' send-keys C-w '@'
bind -T navigator A send-keys C-w A
bind -T navigator B send-keys C-w B
bind -T navigator C send-keys C-w C
bind -T navigator D send-keys C-w D
bind -T navigator E send-keys C-w E
bind -T navigator F send-keys C-w F
bind -T navigator G send-keys C-w G
bind -T navigator H send-keys C-w H
bind -T navigator I send-keys C-w I
bind -T navigator J send-keys C-w J
bind -T navigator K send-keys C-w K
bind -T navigator L send-keys C-w L
bind -T navigator M send-keys C-w M
bind -T navigator N send-keys C-w N
bind -T navigator O send-keys C-w O
bind -T navigator P send-keys C-w P
bind -T navigator Q send-keys C-w Q
bind -T navigator R send-keys C-w R
bind -T navigator S send-keys C-w S
bind -T navigator T send-keys C-w T
bind -T navigator U send-keys C-w U
bind -T navigator V send-keys C-w V
bind -T navigator W send-keys C-w W
bind -T navigator X send-keys C-w X
bind -T navigator Y send-keys C-w Y
bind -T navigator Z send-keys C-w Z
bind -T navigator '[' send-keys C-w '['
bind -T navigator '\' send-keys C-w '\'
bind -T navigator ']' send-keys C-w ']'
bind -T navigator '^' send-keys C-w '^'
bind -T navigator '_' send-keys C-w '_'
bind -T navigator '`' send-keys C-w '`'
bind -T navigator a send-keys C-w a
bind -T navigator b send-keys C-w b
bind -T navigator c send-keys C-w c
bind -T navigator d send-keys C-w d
bind -T navigator e send-keys C-w e
bind -T navigator f send-keys C-w f
bind -T navigator g send-keys C-w g
# bind -T navigator h send-keys C-w h
bind -T navigator i send-keys C-w i
# bind -T navigator j send-keys C-w j
# bind -T navigator k send-keys C-w k
# bind -T navigator l send-keys C-w l
bind -T navigator m send-keys C-w m
bind -T navigator n send-keys C-w n
bind -T navigator o send-keys C-w o
bind -T navigator p send-keys C-w p
bind -T navigator q send-keys C-w q
bind -T navigator r send-keys C-w r
bind -T navigator s send-keys C-w s
bind -T navigator t send-keys C-w t
bind -T navigator u send-keys C-w u
bind -T navigator v send-keys C-w v
bind -T navigator w send-keys C-w w
bind -T navigator x send-keys C-w x
bind -T navigator y send-keys C-w y
bind -T navigator z send-keys C-w z
bind -T navigator '{' send-keys C-w '{'
bind -T navigator '|' send-keys C-w '|'
bind -T navigator '}' send-keys C-w '}'

bind -T navigator C-a send-keys C-w C-a
bind -T navigator C-b send-keys C-w C-b
bind -T navigator C-c send-keys C-w C-c
bind -T navigator C-d send-keys C-w C-d
bind -T navigator C-e send-keys C-w C-e
bind -T navigator C-f send-keys C-w C-f
bind -T navigator C-g send-keys C-w C-g
bind -T navigator C-h send-keys C-w C-h
bind -T navigator C-i send-keys C-w C-i
bind -T navigator C-j send-keys C-w C-j
bind -T navigator C-k send-keys C-w C-k
bind -T navigator C-l send-keys C-w C-l
bind -T navigator C-m send-keys C-w C-m
bind -T navigator C-n send-keys C-w C-N
bind -T navigator C-o send-keys C-w C-o
bind -T navigator C-p send-keys C-w C-p
bind -T navigator C-q send-keys C-w C-q
bind -T navigator C-r send-keys C-w C-r
bind -T navigator C-s send-keys C-w C-s
bind -T navigator C-t send-keys C-w C-t
bind -T navigator C-u send-keys C-w C-u
bind -T navigator C-v send-keys C-w C-v
# bind -T navigator C-w send-keys C-w C-w
bind -T navigator C-x send-keys C-w C-x
bind -T navigator C-y send-keys C-w C-y
bind -T navigator C-z send-keys C-w C-z
