module {
  name: "4513echo/ripgrep",
  version: "0.1.0"
};

# based on https://github.com/thinca/config/blob/eb27ff47/dotfiles/dot.vim/vimrc#L598
def parse:
  select(.type == "match")
  | .data as $data
  | $data.submatches[]
  | "\($data.path.text):\($data.line_number):\(.start + 1):\(.end + 1):\($data.lines.text // "" | sub("\n$"; ""))";
