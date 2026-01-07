use jumps.nu 'jump cleanup';
use std/log error;

export def main [] {
  $env.config.plugins.clean.commands
  | each {|cleanup_command|
    print $"(ansi gb)$(ansi reset) (ansi black)( view source $cleanup_command )(ansi reset)";

    try {
      do $cleanup_command
      | print $"(ansi gb)stdout:(ansi reset)(char nl)( $in )(char nl)"

    } catch { error 'fiald to cleanup'  };

  } | ignore;

}
