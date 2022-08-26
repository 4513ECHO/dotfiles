BEGIN {
    total_vim = 0
    total_nvim = 0
}

{
    switch ($1) {
    case "vim.toml":
        total_vim += $2
        break
    case "neovim.toml":
        total_nvim += $2
        break
    case "unused.toml":
        break
    default:
        total_vim += $2
        total_nvim += $2
    }
}

END {
    print "------------------------"
    printf "%-20s %3d\n", "total(vim)", total_vim
    printf "%-20s %3d\n", "total(neovim)", total_nvim
}
