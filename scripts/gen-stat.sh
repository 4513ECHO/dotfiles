#!/bin/sh
set -ue

abort() { echo "error: $*" >&2; exit 1; }

src="${1:-README.md}"

insert_command() {
  ts="<!--$1-start-->"
  te="<!--$1-end-->"
  shift
  ext=".orig"
  tmp="$(mktemp)"
  if ! grep -Fxq "$ts" "$src" && grep -Fxq "$te" "$src"; then
    abort "You don't have $ts or $te in your file"
  fi
  # http://fahdshariff.blogspot.ru/2012/12/sed-mutli-line-replacement-between-two.html
  # clear old result
  sed -i"$ext" "/$ts/,/$te/{//!d;}" "$src"
  # create result file
  {
    echo '```'
    "$@"
    echo '```'
  } | tee -a "$tmp"
  # insert result file
  sed -i "/$ts/r $tmp" "$src"
  rm -f "$tmp" "$src$ext"
}

# shellcheck disable=SC2046
insert_command 'tokei' tokei --hidden -- $(git ls-files)
insert_command 'hyperfine' hyperfine 'vim --not-a-term +quit' 'nvim --headless +quit'

# shellcheck disable=SC2016
updated_at=$(printf 'Statistics are updated at [`%s`](%s/commit/%s).' \
  "$(git rev-parse --short HEAD)" "$(git remote get-url origin)" "$(git rev-parse HEAD)")
echo "$updated_at"
sed -i "s@^Statistics are updated at .*\$@$updated_at@" "$src"
