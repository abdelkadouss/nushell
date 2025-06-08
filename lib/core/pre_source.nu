# config
if not ( ($env.HOME | path join ".templates") | path exists ) {
  mkdir ($env.HOME | path join ".templates");
}

# starship
if not ("~/.cache/starship/init.nu" | path exists) {
  mkdir ~/.cache/starship;
  starship init nu | save -f ~/.cache/starship/init.nu;
}

# zoxide
if not ("~/.config/nushell/plugins/.zoxide.nu" | path exists) {
  zoxide init nushell | save -f ~/.config/nushell/plugins/scripts/.zoxide.nu;
};

# carapace
if not ("~/.cache/carapace/init.nu" | path exists) {
  mkdir ~/.cache/carapace;
  carapace _carapace nushell | save --force ~/.cache/carapace/init.nu;
};


# atuin
# if not ("~/.local/share/atuin/init.nu" | path exists) {
#   mkdir ~/.local/share/atuin/;
#   atuin init nu | save ~/.local/share/atuin/init.nu;
# };
