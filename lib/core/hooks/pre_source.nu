let GEN_DIR = (
  [
    $env.NU_CONFIG_DIR,
    "plugins",
    "scripts"
    "gen"
  ] | path join
);

mkdir $GEN_DIR;

let gen_scripts = [
  {
    name: "starship"
    script: {|| starship init nu }
  }
  {
    name: "zoxide"
    script: {|| zoxide init nushell }
  }
  # {
  #   name: "carapace" # cheak out ../../completion/carapace.nu
  #   script: {|| carapace _carapace nushell }
  # }
  # {
  #   name: "mise"
  #   script: {|| mise activate nu }
  # }
  # {
  #   name: "proto"
  #   script: {|| proto activate nu }
  # }
  # {
  #   name: "atuin"
  #   script: {||  atuin init nu }
  # }

]

for gen in $gen_scripts {
  use std-rfc/path;

  let script_path = (
    [
      $GEN_DIR
      ( $gen.name | path with-extension "nu" )
    ] | path join
  )

  if not ( $script_path | path exists ) {
    do $gen.script
    | save -f $script_path

  }

};
