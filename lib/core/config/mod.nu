source plugin.nu;
source hooks.nu;
source prompt.nu;
source menus.nu;
source theme/mod.nu;

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

$env.config = {
  ...( read file "lib/core/config/shell.nuon" ),

  keybindings: ( read file "lib/core/config/keymapping.nuon" ),

}

