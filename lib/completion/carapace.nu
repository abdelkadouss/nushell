# u can generate this file with `carapace _carapace nushell`
def path_hook [] {
  $env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend ($env.home | path join ".config/carapace/bin" )
  )
}

def --env get-env [name] { $env | get $name }
def --env set-env [name, value] { load-env { $name: $value } }
def --env unset-env [name] { hide-env $name }

export def main [ spans ] {
  path_hook;

  # if the current command is an alias, get it's expansion
  let expanded_alias = (scope aliases | where name == $spans.0 | get -o 0 | get -o expansion)

  # overwrite
  let spans = (if $expanded_alias != null  {
    # put the first word of the expanded alias first in the span
    $spans | skip 1 | prepend ($expanded_alias | split row " " | take 1)
  } else {
    $spans | skip 1 | prepend ($spans.0)
  })

  carapace $spans.0 nushell ...$spans
  | from json
}
