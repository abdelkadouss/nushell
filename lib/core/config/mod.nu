source plugin.nu;
source hooks.nu;
source prompt.nu;
source menus.nu;
source theme.nu;

def "read file" [
  path
  --raw(-r)
] {
  (
    [
      (
        $nu.config-path
        | path dirname
      ),
      $path
    ] | path join
  ) | (
    if $raw {
      open --raw $in

    } else {
      open $in

    }

  )
}

# ls colors
$env.LS_COLORS = (
  ( read file --raw lib/assets/ls-colors )
  | str trim
)

$env.config = {
  ...( read file "lib/core/config/shell.nuon" ),

  keybindings: ( read file "lib/core/config/keymapping.nuon" ),

}

