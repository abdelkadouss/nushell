let GEN_DIR = (
  [
    $env.NU_DATA_DIR,
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
  {
    name: proto_completions
    script: {|| proto completions --shell nu --yes }
  }
  {
    name: proto_activation
    script: {|| proto activate --yes nu }
  }
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
