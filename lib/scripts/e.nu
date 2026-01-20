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
  "--height=10"
  "--layout=reverse"
  "--preview='if ( {} | path type ) == file { bat {} } else { lstr {} }'"
];

module error {
  # nu-lint-ignore: kebab_case_commands
  export def EDITOR-env-var-not-seted [ ]: nothing -> error {
    # nu-lint-ignore: add_label_to_error
    error make {
      msg: "the EDITOR env var is not seted"
      help: "go ahead and set it to your favorite editor"

    }

  }

}

module zoxide {
  export def --env go [ ...rest: string ]: any -> bool {
    overlay new zoxide_go;

    let path = match $rest {
      [ ] => { '~' }
      [ '-' ] => { '-' }
      [ $arg ] if (
        $arg
        | path expand
        | path type
      ) == 'dir' => { $arg }
      _ => {
        zoxide query `--exclude` $env.PWD `--` ...$rest
        | str trim -r --char (char nl)
      }

    }

    $env.ZOXIDE_GO_PATH = $path;

    cd $path

    overlay hide zoxide_go --keep-env [ PWD ZOXIDE_GO_PATH ];

    ($env.ZOXIDE_GO_PATH | is-not-empty)

  }

}

module editor {
  # run the editor set in the env var EDITOR
  export def --wrapped run [ ...input: string ]: nothing -> nothing {
    # test that is EDITOR env is seted and it's in the path
    let editor = (
      try {
        $env.EDITOR

      } catch {
        use error
        error EDITOR-env-var-not-seted;

      }
    );

    # nu-lint-ignore: spread_list_to_external
    external exist --panic true [ $editor ];

    let as_admin = ($env.dev?.as_admin? | default false);

    if $as_admin {
      if ($input | is-empty) {
        external run --dont-wait-return-value-to-exit true --as-root true $editor;

      } else {
        external run --dont-wait-return-value-to-exit true --as-root true $editor ...$input;

      }

    } else {
      if ($input | is-empty) {
        external run --dont-wait-return-value-to-exit true $editor;

      } else {
        external run --dont-wait-return-value-to-exit true $editor ...$input;

      }

    }

  }
}

# HACK: add this to the main cmd as complation like so if u wanna use it: ...files: string@history-edits
# def history-edits [ ]: any -> list<any> {
#   history
#   | last 100
#   | get command
#   | where { |it| $it | str starts-with 'e ' }
#   | str substring 1..
#   | str trim
#   | uniq
#   | prepend (
#     ls --all
#     | get name
#   )
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
@search-terms 'open' edit 'open file'
export def --wrapped main [
  # nu-lint-ignore: max_function_body_length
  --fzf (-f) # open with fzf
  --zoxide (-z) # open file/dir form zoxide history
  --new (-n) # make the file if not exists
  --as-admin (-a) # run as root
  ...files: string # files/dir query to open
]: nothing -> nothing {
  if $as_admin { $env.dev.as_admin = true };

  if ($files | is-empty) {
    use editor;
    editor run;

  } else if $fzf {
    # make sure fzf is in the path in Chaa'Allah
    external exist --panic true [ fzf ]; # nu-lint-ignore: spread_list_to_external

    use editor;

    (
      run-external fzf ...$FZF_DEFAULT_OPTS "--border-label='" "--query" ($files | str join "")
    ) | (
      if ($in | is-empty) {
        return;

      } else if ($in | path type) == dir {
        cd $in;
        "."

      } else {
        $in

      }
    )
    | editor run $in;

  } else if $zoxide {
    # make sure fzf and zoxide is in the path in Chaa'Allah
    external exist --panic true [ fzf zoxide ];

    use editor;

    (
      external run zoxide query `--interactive` `--` ...$files
      | str trim --right --char (char nl)
    )
    | (
      if ($in | is-empty) { return };

      cd $in; editor run;
    );

  } else if (
    $env.config.plugins.e?.alias? has $files.0
  ) {
    use editor;

    $env.config.plugins.e.alias
    | get --optional $files.0
    | path expand
    | (
      if ($in | path type) == dir {
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
    | any { |exising| $exising }
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

      editor run ...($files | path expand);

    } else {
      use zoxide;

      zoxide go ...$files
      | if $in {
        editor run;
        cd -;

      } else {
        mut path = "";
        mut to_handle = $files;
        mut not_handled = [ ];

        while ($to_handle | is-not-empty) {
          let zoxide_output = try {
            external run zoxide query `--` $path ...$to_handle
          } catch { null };

          if ($zoxide_output | is-not-empty) {
            $path = (
              [
                $zoxide_output
                $path
              ] | path join
            );

            $to_handle = $not_handled;

          } else {
            $not_handled = (
              $not_handled
              | append (
                $to_handle
                | try { last } catch { [ ] }
              ) | uniq
            );

            $to_handle = (
              $to_handle
              | take (
                ($to_handle | length) - 1
              )
            );

          }

        }

        if ($path | is-not-empty) {
          use editor;

          cd $path;

          external run fzf ...$FZF_DEFAULT_OPTS $"--border-label=(pwd)" `--query` ($not_handled | reverse | str join "")
          | str trim --right --char (char nl)
          | editor run $in;

        } else {
          print --stderr "path not found 📭";

        }

      }

    }

  }

}
