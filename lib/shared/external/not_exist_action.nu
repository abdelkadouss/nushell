# a external command module that decides what to do if the bin is not in the path, retrun treu if it do an action
export def "bin not exist" [
  bin: string,
  panic: bool = false
  stdout_message: bool = false,
  action_level: string = "warning",
  stdlib: bool = false
]: nothing -> bool {
  if $panic {
    error make {
      msg: $"the bin '($bin)' is not in the path"
      label: {
        text: ""
        span: (metadata $bin).span
      }

      help: "maybe you have to install it first or add it to the path"

    };

  };

  if $stdout_message {
    let message = if not $stdlib {
      $"the bin (ansi blue_underline)'($bin)'(ansi reset) is not in the path and it's used in your shell scripts in (ansi blue_underline)($nu.env-path)(ansi reset).\n- this maybe break some of the functionalities of your shell of make unexpected things in Chaa'Allah."
    } else {
      $"the bin '($bin)' is not in the path and it's used in your shell scripts in ($nu.env-path).\n- this maybe break some of the functionalities of your shell of make unexpected things in Chaa'Allah."
    };

    let help_message = $"make sure to install it or add it to the path.";

    if $stdlib {
      match $action_level {
        "error" => {
          use std/log error;
          error $message;
        }
        "warning" => {
          use std/log warning;
          warning $message;
        }
        "info" => {
          use std/log info;
          info $message;
        }

      };

    } else {
      match $action_level {
        "error" => {
          use ../log "log error";
          log error $message $help_message;
        }
        "warning" => {
          use ../log "log warning";
          log warning $message $help_message;
        }
        "info" => {
          use ../log "log info";
          log info $message $help_message;
        }

      }

    };

    return true;

  };

  return false;

};
