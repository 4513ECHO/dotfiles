#!/bin/sh

defaults write -g AppleAccentColor -int 1
defaults write -g AppleHighlightColor -string '1.000000 0.874510 0.701961 Orange'
defaults write -g AppleInterfaceStyle -string 'Dark'
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.universalaccess stickyKey -bool true
defaults write com.apple.LaunchServices LSQuarantine -bool false

defaults write com.apple.screencapture location -string ~/Pictures

defaults write com.googlecode.iterm2 AllowClipboardAccess -bool true

defaults write jp.sourceforge.inputmethod.aquaskk direct_clients -array 'com.googlecode.iterm2'
defaults write jp.sourceforge.inputmethod.aquaskk max_count_of_inline_candidates -int 2
defaults write jp.sourceforge.inputmethod.aquaskk candidate_window_font_size -int 14
defaults write jp.sourceforge.inputmethod.aquaskk user_dictionary_path -string ~/.local/share/skk/SKK-JISYO.user

printf 'StickyKey\t\t;' >> ~/Library/Application\ Support/AquaSKK/keymap.conf
# NOTE: rule file must be EUC-JP
touch ~/Library/Application\ Support/AquaSKK/punctuation.rule

DictionarySet=~/Library/Application\ Support/AquaSKK/DictionarySet.plist
plutil -replace 0.location -string 'SKK-JISYO.L' "$DictionarySet"
plutil -replace 0.type -integer 1 "$DictionarySet"
plutil -replace 1.location -string ~/.local/share/skk/SKK-JISYO.4513echo "$DictionarySet"
plutil -replace 1.type -integer 5 "$DictionarySet"
