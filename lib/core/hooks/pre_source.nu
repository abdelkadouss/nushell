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
    name: mise_activate
    script: {|| try { mise activate nu } catch { "use std/log warning;\n warning 'mise is not installed and u sourcing it's files i ur shell config'" } }
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
