# a util to quickly change themes
export def main [
  --overwrite-theme(-o): string # overwrite the configred theme in the config file
  --overwrite-palette(-p): string # overwrite the configred palette in the config file
  --dont-run-install-hooks(-d) # dont run the themes install hooks
] {
  let theme_install_hooks: oneof<table,nothing> = $env.config.plugins.theme.install_hooks?;

  if not $dont_run_install_hooks {
    for hook in $theme_install_hooks {
      if ( $hook.run? | is-not-empty ) {
        try {
          do $hook.run;
        } catch {|e|
          if not ( $hook.ignore-error? | default true ) {
            panic $'( $e )';

          }

        }

        continue;

      }

      if ( $hook.mkdir? | default false ) {
        mkdir ( ( $hook.to | path expand ) | path dirname );
      }

      mut source = '';

      if ( $hook.from | str starts-with 'http' ) {
        $source = ( http get --raw $hook.from );

      } else {
        $source = ( open --raw ( $hook.from | path expand ) );

      }

      if ( $hook.overwrite? | default false ) {
        $source | save --force ( $hook.to | path expand );

      } else {
        $source | save ( $hook.to | path expand );

      }

    }

  }


  let theme_name: string = (
    $overwrite_theme
    | default $env.config.plugins.theme.name | str snake-case
  );
  let theme_palette: oneof<string, nothing> = (
    $overwrite_palette
    | default $env.config.plugins.theme.palette?
    | default null
  );
  let theme_defs: list<closure> = $env.config.plugins.theme.definitions;

  use shared/fmt code;

  for one in ( $theme_defs | enumerate ) {
    let index = $one.index;
    let def = $one.item;

    if not ( $def.active? | default true ) {
      print $"(ansi yb)Operation:(ansi b) ( $index )(ansi y) are disabled... skip(ansi reset)";
      print $"(ansi yb)Desc:(ansi black_underline) ( $def.desc | str title-case )(ansi reset)";

      continue

    };

    print $"(ansi gb)Operation:(ansi b) ( $index )(ansi reset)";
    print $"(ansi gb)Desc:(ansi black_underline) ( $def.desc | str title-case )(ansi reset)";

    mut name = $theme_name;
    if ( $theme_palette | is-not-empty ) and ( $def.palette? | default true ) {
      $name = $'($name)_($theme_palette)';
    }

    do $def.cmd ( nu -c $" '( $name )' | str ( $def.case )-case " )
    | collect   
    | (
      if ( $in | is-not-empty ) {
        match $in.type {
          'add-to-file' => { print $'(ansi bb)make sure to add this code to the file:(ansi black_underline)(char nl)// ($in.file):(ansi reset)'; }
          'run' => { print $'(ansi bb)make sure to run this(ansi reset)'; }
        }

        code $in.code | print;

      }
    )

  }

}
