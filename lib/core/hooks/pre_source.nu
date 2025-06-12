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

# mise
if not (
  (
    [
      $env.NU_CONFIG_DIR,
      "plugins",
      "scripts"
      ".mise.nu"
    ] | path join
  ) | path exists
) {
  mise activate nu
  | save -f (
    [
      $env.NU_CONFIG_DIR,
      "plugins",
      "scripts",
      ".mise.nu"
    ] | path join
  );

};

if not (
  [
    $env.NU_CONFIG_DIR,
    "plugins",
    "scripts",
    "proto.nu"
  ] | path join
  | path exists
) {
  proto activate nu
  | save -f (
    [
      $env.NU_CONFIG_DIR,
      "plugins",
      "scripts",
      ".proto.nu"
    ] | path join
  );

};

# atuin
# if not ("~/.local/share/atuin/init.nu" | path exists) {
#   mkdir ~/.local/share/atuin/;
#   atuin init nu | save ~/.local/share/atuin/init.nu;
# };
