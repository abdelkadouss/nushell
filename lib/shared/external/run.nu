def levels [] { ["error", "warning", "info"] };

# run the bin if it's in the path or make decisions in Chaa'Allah
export def "external run" [
  bin: string,
  --panic(-p) = false,
  --stdout-message(-m) = false,
  --action-level(-l): string@levels = "warning",
  --stdlib(-s) = false,
  --default-output(-d): any = null
  --as-root(-r) = false,
  --dont-wait-return-value-to-exit(-w) = false,
  ...args
] {
  let command = ( which $bin );

  def run_bin [ bin:string, ...args ] {
    if ( $bin | is-not-empty ) {
      if $as_root {
        if $dont_wait_return_value_to_exit {
          sudo $bin ...$args;
          return;

        } else {
          return ( sudo $bin ...$args )

        }

      };

      if $dont_wait_return_value_to_exit {
        ^$bin ...$args;
        return;

      } else {
        return ( ^$bin ...$args )

      }

    };

  }

  if ( $command | is-not-empty ) {
    let command_type = ( $command | get -i type );

    if ( $command_type | is-not-empty ) {
      match $command_type {
        "alias" => {
          let bins = (
            scope aliases
            | where name == $bin
            | get expansion
            | first
            | which $in
            | get -i path
          );

          return ( run_bin $bins ...$args );

        },
        "custom" => {
          let bin = ( $command | get -i command | first );

          return ( run_bin $bin ...$args );

        },
        _ => {
          let bin = ( $command | get -i path | first );

          return ( run_bin $bin ...$args );

        }

      };

    };

  };

  use not_exist_action.nu "bin not exist";
  bin not exist $bin $panic $stdout_message $action_level $stdlib;

  if $default_output != null {
    return $default_output;

  };

};
