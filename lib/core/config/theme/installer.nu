let THEME_DIR = (
  [
    $env.NU_DATA_DIR
    "themes"
  ] | path join
)

mkdir $THEME_DIR;

let themes = [
  {
    name: "catppuccin_mocha"
    url: "https://raw.githubusercontent.com/nushell/nu_scripts/refs/heads/main/themes/nu-themes/catppuccin-mocha.nu"
  }

]

for theme in $themes {
  use std-rfc/path;

  let theme_path = (
    [
      $THEME_DIR
      ( $theme.name | path with-extension "nu" )
    ] | path join
  );

  if not ( $theme_path | path exists ) {
    if ( $theme.fetcher? | is-not-empty ) {
      do $theme.fetcher $theme.url
      | save -f $theme_path;

    } else {
      http get $theme.url
      | save -f $theme_path;

    }

  }

}
