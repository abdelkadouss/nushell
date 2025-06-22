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
  ...args
] {
  let command = ( which $bin );

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

          if ( $bin | is-not-empty ) {
            if $as_root {
              return ( sudo $bin ...$args );

            };

            return ( ^$bin ...$args );

          };

        },
        "custom" => {
          let bin = ( $command | get -i command | first );

          if ( $bin | is-not-empty ) {
            if $as_root {
              return ( sudo $bin ...$args );

            };

            return ( ^$bin ...$args );

          };

        },
        _ => {
          let bin = ( $command | get -i path );
          if ( $bin | is-not-empty ) {
            let bin = ( $bin | first );
            if $as_root {
              return ( sudo $bin ...$args );

            };

            return ( ^$bin ...$args );

          };

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
