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
    url: ( url from-default-repo catppuccin-mocha )
  }
  {
    name: "tokyonight_night"
    url: ( url from-default-repo tokyo-night )
  }
  {
    name: "rose_pine"
    url: ( url from-default-repo rose-pine )
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

# helpers insha'Allah

const DEFAULT_REPO = {
  "scheme": "https"
  "host": "www.github.com"
  "path": "nushell/nu_scripts/raw/refs/heads/main/themes/nu-themes"
};

def 'url from-default-repo' [ theme_name: string ] {
  use std-rfc/path;

  {
    "scheme": $DEFAULT_REPO.scheme,
    "host": $DEFAULT_REPO.host,
    "path": (
      [
        $DEFAULT_REPO.path
        ( $theme_name | path with-extension "nu" )
      ] | path join
    ),
    } | url join

}
