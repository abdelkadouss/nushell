### README:

# * to use this script we recommend to make key bindings for, for example, ctrl+o and ctrl+i.
# take a look at (https://github.com/abdelkadouss/nushell/blob/main/lib/core/config/keymapping.nuon) lines: 188 and 200 to an example.
# * before using the key bindings u have first to add the script to ur scope: use jumps.nu [ 'jump backward' 'jump forward' 'jump cleanup' 'jump list' ];
# * this scripts has a known issue which is it's make tmp files for each session and the issue is it's don't cleanup this files auto so u have to clean it up via the jump cleanup command so run it from time to time insha'Allah. but the good news is the tmps files are is the /tmp dir so the os gonna clean it up auto after reboot thanks to Allah.

###

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

# jump back to the last visited dir before the current dir.
@search-terms 'jump' 'cd'
@example 'jump to dir again' {
  pwd; # some/path
  cd there; # some/path/there
  cd some/where; # some/path/there/some/where
  jump backward; # some/path/there
  jump backward; # some/path
  # HINT: try help: jump forward
}
export def --env 'jump backward' [] {
  jump ( $env.config.plugins.jumps.backward_file | join_with_pid );

  $env.tmp.plugin.jumps.jump_type = 'backward';

}

# jump forward to the last dir i was jumped back from.
@search-terms 'jump' 'cd'
@example 'jump to dir again' {
  pwd; # some/path
  cd there; # some/path/there
  jump backward; # some/path
  jump forward; # some/path/there
}
export def --env 'jump forward' [] {
  jump ( $env.config.plugins.jumps.forward_file | join_with_pid );

  $env.tmp.plugin.jumps.jump_type = 'forward';

}

# cleanup the jumps tmp files
export def 'jump cleanup' [] {
  ( glob $"( $env.config.plugins.jumps.backward_file ).*" )
  | append (
    glob $"( $env.config.plugins.jumps.forward_file ).*"
  )
  | each {|file|
    rm -rfp $file;

  }

}

# list the jumps (forward and backward)
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
