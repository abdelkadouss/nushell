export def --env make_sure_bin_in_the_path [ bins: list ] {
  for bin in $bins {
    if ( which $bin | is-empty ) {
      error make {
        msg: $"the bin '($bin)' is not in the path"
        label: {
          text: ""
          span: (metadata $bin).span
        }

        help: "maybe you have to install it first or add it to the path"

      };

    };

  };

};

export def --wrapped run_bin_if_in_path_and_do_action_if_not [
  bin: string,
  fail_action: closure,
  --as-root(-r) = false,
  ...args
] {
  mut bins = [];

  let command_type = ( which $bin | get -i type );

  if  ( $command_type | is-empty ) {
    return ( do $fail_action );

  } else if ( $command_type | first ) == "internal" {
    $bins = [ $bin ];

  } else if ( $command_type | first ) == "alias" {
    $bins = (
      scope aliases
      | where name == $bin
      | get expansion
      | first
      | which $in
      | get -i path
    );

  } else if ( $command_type | first ) == "custom" {
    $bins = ( which $bin | get -i command ); # BUG: this is not working, try: soft_run_bin_if_in_path "" __zoxide_z nushell

  } else {
    $bins = ( which $bin | get -i path );

  }

  if ( $bins | is-not-empty ) {
    let bin = ( $bins | first );

    if ( $bin | is-not-empty ) {
      if $as_root {
        return ( sudo $bin ...$args );

      };

      return ( ^$bin ...$args );

    };

  };

  do $fail_action;

};

export def --wrapped soft_run_bin_if_in_path [
  default_output: any,
  bin: string,
  --as-root(-r) = false,
  ...args
] {
  run_bin_if_in_path_and_do_action_if_not $bin {
    print $"\n(ansi yellow_bold)WORNING:(ansi reset) the bin (ansi blue_underline)'($bin)'(ansi reset) is not in the path and it's used in your shell scripts in (ansi blue_underline)($nu.env-path)(ansi reset).\n- this maybe break some of the functionalities of your shell of make unexpected things in Chaa'Allah.\n(ansi green_bold)help:(ansi reset) make sure to install it or add it to the path.\n"

    $default_output;

  } ...$args;

};

export def --wrapped run_bin_if_in_path [
  bin: string,
  --as-root(-r) = false,
  ...args
] {
  run_bin_if_in_path_and_do_action_if_not $bin {
    error make {
      msg: $"the bin '($bin)' is not in the path"
      label: {
        text: $"can't find '($bin)' in the path"
        span: (metadata $bin).span
      }

      help: "maybe you have to install it first or add it to the path"

    };

  } ...$args;

};
