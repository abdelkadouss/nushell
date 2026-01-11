### README:

# * this script depends on external utilities, make sure to copy from ../shared/external/ ; look as the use line bellow
# * this script depends on some external utilities, which are  [ "fzf", "zoxide" ] make sure to install theme before use
# for usage info run: help e
# the script uses the env var EDITOR as the editor to use, make sure to set it before use. tested with: nvim, vim, hx
# the script accepts config options can be seted in $env.config.plugins.e env var, which is next:
# ** alias: a word reference to path. type: record<string, string>. example: alias: { "shell": "~/.config/nushell/config.nu" }

###

use ../shared/external *;

const FZF_DEFAULT_OPTS = [
  "--height=10",
  "--layout=reverse",
  "--preview='if ( {} | path type ) == file { bat {} } else { lstr {} }'"
];

module error {
  export def EDITOR_env_var_not_seted [] {
    error make {
      msg: "the EDITOR env var is not seted"
      help: "go ahead and set it to your favorite editor"

    }

  }

  export def editor_not_in_path [] {
    error make {
      msg: $"the editor $($env.EDITOR?) is not in the path"
      help: "go ahead and add install it or it to the path"

    }

  }

  export def alias_file_not_exists [] {
    error make {
      msg: "the alias file is not exists"
      help: "create the alias file"

    }

  }
  export def alias_file_not_readable [] {
    error make {
      msg: "the alias file is not readable"
      label: {
        text: $"not readable $($env.config.plugins.e.alias_file)"
        span: (metadata $env.config.plugins.e.alias_file).span
      }
      help: "use: {alais: value}"

    }

  }

}

module zoxide {
  export def --env go [ ...rest:string ] {
    overlay new zoxide_go;

    let path = match $rest {
      [] => { '~' },
      [ '-' ] => { '-' },
      [ $arg ] if (
        $arg
        | path expand
        | path type
      ) == 'dir' => { $arg }
      _ => {
        zoxide query `--exclude` $env.PWD `--` ...$rest
        | str trim -r -c (char nl)
      }

    }

    $env.ZOXIDE_GO_PATH = $path;

    cd $path

    overlay hide zoxide_go --keep-env [ PWD, ZOXIDE_GO_PATH ];

    ( $env.ZOXIDE_GO_PATH | is-not-empty )

  }

}

module editor {
  export def --wrapped run [ ...input: string ] {
    # test that is EDITOR env is seted and it's in the path
    let editor = (
      try {
        $env.EDITOR

      } catch {
        use error
        error EDITOR_env_var_not_seted;

      }
    );

    external exist --panic true [ $editor ];

    let as_admin = ( $env.dev?.as_admin? | default false );

    if $as_admin {
      if ( $input | is-empty ) {
        external run --dont-wait-return-value-to-exit true --as-root true $editor;

      } else {
        external run --dont-wait-return-value-to-exit true --as-root true $editor ...$input;

      }

    } else {
      if ( $input | is-empty ) {
        external run --dont-wait-return-value-to-exit true $editor;

      } else {
        external run --dont-wait-return-value-to-exit true $editor ...$input;

      }

    }

  }
}

# HACK: add this to the main cmd as complation like so if u wanna use it: ...files: string@history-edits
# def history-edits [] {
#   history  | get command | where {|cmd| $cmd | str starts-with 'e ' } | str substring 1.. | str trim | uniq
# }

# this script gonna insha'Allah jumps to dirs or files and open the editor in base on a query u pass. It try to read the current dir contiants + the dirs u visetd in the past (using zoxide) and fuzzy finding via fzf. So it's gonna insha'Allah jump directly to project/file u wannat in smart way insha'Allah.
@example 'open a project u visetd in the past via zoxide' {
  cd ~/.config/nushell/;
  cd;
  e nushell;
}
@example 'open specific file a project u visetd in the past via zoxide' {
  cd ~/.config/nushell/;
  cd;
  e nushell lib scripts e.nu;
}
@example 'open a file in the current dir via fzf' {
  e --fzf some_file;
}
@example 'open project from ur zoxide history' {
  e --zoxide; # or
  e --zoxide some_project;
}
@example 'open a file ur alais' {
  $env.config.plugins.e.alias.shell = "~/.config/nushell/config.nu";
  mkdir shell;
  cd shell;
  cd -;
  e shell; # it's should open ~/.config/nushell/config.nu insha'Allah.
}
@search-terms 'open' 'edit' 'open file'
export def --wrapped main [
  --fzf(-f) # open with fzf
  --zoxide(-z) # open file/dir form zoxide history
  --new(-n) # make the file if not exists
  --as-admin(-a) # run as root
  ...files: string # files/dir query to open
] {
  if $as_admin { $env.dev.as_admin = true };

  if ( $files | is-empty ) {
    use editor;
    editor run;

  } else if $fzf {
    # make sure fzf is in the path in Chaa'Allah
    external exist --panic true [ "fzf" ];

    use editor;

    (
      run-external fzf ...$FZF_DEFAULT_OPTS "--border-label='" "--query" ( $files | str join "" )
    ) | (
      if ( $in | is-empty ) {
        return;

      } else if ( $in | path type ) == 'dir' {
        cd $in;
        "."

      } else {
        $in

      } 
    )
    | editor run $in;

  } else if $zoxide {
    # make sure fzf and zoxide is in the path in Chaa'Allah
    external exist --panic true [ "fzf", "zoxide" ];

    use editor;

    (
      external run zoxide query `--interactive` `--` ...$files
      | str trim -r -c (char nl)
    )
    | (
      if ( $in | is-empty ) { return };

      cd $in;
      editor run;

    );

  } else if (
    $env.config.plugins.e?.alias?
    | get -o $files.0
    | is-not-empty
  ) {
    use editor;

    $env.config.plugins.e.alias
    | get -o $files.0
    | path expand
    | (
      if ( $in | path type ) == 'dir' {
        cd $in;
        editor run;

      } else {
        editor run $in;

      }
    )

  } else {
    use editor;

    # check if the given path exists
    $files
    | path exists
    | any {|exising| $exising }
    | if $in or $new {
      for file in $files {
        $file
        | path dirname
        | path expand
        | path exists
        | if not $in {
          mkdir ($file | path dirname);

        }
      }

      editor run ...( $files | path expand );

    } else {
      use zoxide;

      zoxide go ...$files
      | if $in {
        editor run;
        cd -;

      } else {
        mut path = "";
        mut to_handle = $files;
        mut not_handled = [];

        while ( $to_handle | is-not-empty ) {
          let zoxide_output = try {
            external run zoxide query `--` $path ...$to_handle
          } catch { null };

          if ( $zoxide_output | is-not-empty ) {
            $path = (
              [
                $zoxide_output,
                $path
              ] | path join
            );

            $to_handle = $not_handled;

          } else {
            $not_handled = (
              $not_handled
              | append (
                $to_handle
                | last
              ) | uniq
            );

            $to_handle = (
              $to_handle
              | take (
                ( $to_handle | length ) - 1
              )
            );

          }

        }

        if ( $path | is-not-empty ) {
          use editor;

          cd $path;

          external run fzf ...$FZF_DEFAULT_OPTS $"--border-label=(pwd)" `--query` ( $not_handled | reverse | str join "" )
          | str trim -r -c (char nl)
          | editor run $in;

        } else {
          print -e "path not found 📭";

        }

      }

    }

  }

}
