# starship
let starship_path = (
  [
    $env.NU_CONFIG_DIR,
    "plugins",
    "scripts"
    ".starship.nu"
  ] | path join
);
if not ( $starship_path | path exists ) {
  mkdir ( $starship_path | path dirname );
  starship init nu | save -f $starship_path;
}

# zoxide
if not ("~/.config/nushell/plugins/.zoxide.nu" | path exists) {
  zoxide init nushell | save -f ~/.config/nushell/plugins/scripts/.zoxide.nu;
};

# carapace
let carapace_path = (
  [
    $env.NU_CONFIG_DIR,
    "plugins",
    "scripts"
    ".carapace.nu"
  ] | path join
);
if not ( $carapace_path | path exists ) {
  mkdir ( $carapace_path | path dirname );
  carapace _carapace nushell | save --force $carapace_path;
};

# mise
let mise_path = (
  [
    $env.NU_CONFIG_DIR,
    "plugins",
    "scripts"
    ".mise.nu"
  ] | path join
);
if not ( $mise_path | path exists ) {
  mise activate nu
  | save -f $mise_path;
};

let proto_path = (
  [
    $env.NU_CONFIG_DIR,
    "plugins",
    "scripts",
    "proto.nu"
  ] | path join
);
if not ( $proto_path | path exists ) {
  proto activate nu
  | save -f $proto_path;

};

# atuin
# if not ("~/.local/share/atuin/init.nu" | path exists) {
#   mkdir ~/.local/share/atuin/;
#   atuin init nu | save ~/.local/share/atuin/init.nu;
# };
