overlay new completion;
overlay use completion;

use fish.nu;
use carapace.nu;
use zoxide.nu;

# This completer will use carapace by default
let external_completer = {|spans|
  let expanded_alias = scope aliases
  | where name == $spans.0
  | get -o 0.expansion

  let spans = if $expanded_alias != null {
    $spans
    | skip 1
    | prepend ($expanded_alias | split row ' ' | take 1)

  } else {
      $spans

  }

  match $spans.0 {
    # and doesn't have completions for mise
    mise => {|spans| fish $spans }
    # and doesn't have completions for lnk
    lnk => {|spans| fish $spans }
    colima => {|spans| fish $spans }
    we => {|spans| carapace "watchexec" }
    lz => {|spans| carapace "lazygit" }
    m => {|spans| carapace "zellij" }
    y => {|spans| carapace "yazi" }
    mprocs => {|spans| carapace "mprocs" }
    gh-dash => {|spans| carapace "gh-dash" }
    # use zoxide completions for zoxide commands
    # __zoxide_z | __zoxide_zi | cd => {|spans| zoxide $spans }
    _ => {|spans| carapace $spans }
  } | do $in $spans
}

$env.config.completions = {
  case_sensitive: false # set to true to enable case-sensitive completions
  quick: true    # set this to false to prevent auto-selecting completions when only one remains
  partial: true    # set this to false to prevent partial filling of the prompt
  algorithm: "prefix"    # prefix or fuzzy
  sort: "smart" # "smart" (alphabetical for prefix matching, fuzzy score for fuzzy matching) or "alphabetical"
  external: {
    enable: true # set to false to prevent nushell looking into $env.PATH to find more suggestions, `false` recommended for WSL users as this look up may be very slow
    max_results: 100 # setting it lower can improve completion performance at the cost of omitting some options
    completer: $external_completer
  }
}

overlay hide completion --keep-env [ config ];

# source the stuff u wanna keep in the scope like the extern cmds
source ./hx.nu;
source ./pkg.nu;
source ./asdf.nu;
