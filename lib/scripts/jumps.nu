def append_nl_to_file [
  line: string
  file: string
] {
  $"( $line )( char nl )"
  | save --append --force $file;
}

def join_with_pid [
]: string -> string {
  (
    [
      $in
      '.'
      ( $nu.pid | into string )
    ]
    | str join
  )
}

export module 'jump hooks' {
  export def --env jump [
    before
    after
  ] {
    let forward_file = ( $env.config.plugins.jumps.forward_file | join_with_pid );
    let backward_file = ( $env.config.plugins.jumps.backward_file | join_with_pid );

    if ( $env.tmp?.plugin?.jumps?.is_jumped? | default false ) {
      $env.tmp.plugin.jumps.is_jumped = false;

      if ( $env.tmp.plugin.jumps.jump_type == 'backward' ) {
        append_nl_to_file $before $forward_file;

        return;

      }

      append_nl_to_file $before $backward_file;

      return;
    }

    try {
      append_nl_to_file $before $backward_file;
    }

  }

  # cleanup the jumps tmp files
  export def cleanup [] {
    rm -rfp ( $env.config.plugins.jumps.backward_file | join_with_pid );
    rm -rfp ( $env.config.plugins.jumps.forward_file | join_with_pid );

  }

  export def init [] {
    mkdir ( $env.config.plugins.jumps.backward_file | path dirname );
    mkdir ( $env.config.plugins.jumps.forward_file | path dirname );
  }
}

def --env 'jump' [
  jumps_file: string
] {
  let jumps = (
    try {
      open --raw $jumps_file
    } catch { return }
    | lines
  );

  let jumps_len = ( $jumps | length );

  if $jumps_len > 0 {
    cd ( $jumps | last );

    $jumps
    | first ( $jumps_len - 1 )
    | save --force $jumps_file;

  }

  $env.tmp.plugin.jumps.is_jumped = true;

}

export def --env 'jump backward' [] {
  jump ( $env.config.plugins.jumps.backward_file | join_with_pid );

  $env.tmp.plugin.jumps.jump_type = 'backward';

}

export def --env 'jump forward' [] {
  jump ( $env.config.plugins.jumps.forward_file | join_with_pid );

  $env.tmp.plugin.jumps.jump_type = 'forward';

}

export def 'jump cleanup' [] {
  ( glob $"( $env.config.plugins.jumps.backward_file ).*" )
  | append (
    glob $"( $env.config.plugins.jumps.forward_file ).*"
  )
  | each {|file|
    rm -rfp $file;

  }

}

export def 'jump list' [] {
  try {
    print $'(ansi gb)backward:(ansi reset)';
    open --raw ( $env.config.plugins.jumps.backward_file | join_with_pid )
    | lines
  } | print $in

  try {
    print $'(ansi gb)forward:(ansi reset)';
    open --raw ( $env.config.plugins.jumps.forward_file | join_with_pid )
    | lines
  } | print $in

}
