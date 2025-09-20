use ../../shared/environment.nu *;

const PKG_TYPES = [
  'bin'
  'module'
  'script'
];

export module install {
  export def cargo_git [
    pkg_repo: string
  ] {
    let tmp_dir = env exists --panic --return-value $.config.plugins.nupm.NUPM_TMP_DIR;
    let tmp_dir = ( mktemp --directory --tmpdir-path $tmp_dir );

    cargo install --git $pkg_repo --root $tmp_dir;

    let pkg_path = (
      ls -f (
        [
          $tmp_dir
          bin
        ] | path join
      )
      | get name
      | first
    );

    return {
      name: (
        $pkg_repo
        | url parse
        | get path
        | path basename
        | path parse
        | get stem
      )
      repo: $pkg_repo
      path: $pkg_path
      pkg_type: $PKG_TYPES.0

    }

  }

  export def crate [
    pkg_name: string
  ] {
    let dist_paht = env exists --panic --return-value $.config.plugins.nupm.NUPM_DIST_PATH;

    let tmp_dir = env exists --panic --return-value $.config.plugins.nupm.NUPM_TMP_DIR;
    let tmp_dir = ( mktemp --directory --tmpdir-path $tmp_dir );

    cargo install $pkg_name --root $tmp_dir;

    let pkg_path = (
      ls -f (
        [
          $tmp_dir
          bin
        ] | path join
      )
      | get name
      | first
    );

    return {
      name: $pkg_name
      repo: $pkg_name
      path: $pkg_path
      pkg_type: $PKG_TYPES.0
    }

  }

  export def git_script_or_module [
    pkg_repo: string
    pkg_type: string
  ] {
    if not ( $pkg_type in $PKG_TYPES ) {
      panic $"Invalid pkg type ( $pkg_type )"

    };

    let tmp_dir = env exists --panic --return-value $.config.plugins.nupm.NUPM_TMP_DIR;
    let tmp_dir = ( mktemp --directory --tmpdir-path $tmp_dir );

    let pkg_parse = ( $pkg_repo | split row "*" );
    let pkg_repo = (
      $pkg_parse
      | get 0
    );
    mut pkg_name = (
      $pkg_parse
      | get 1
    );
    let pkg_rename = (
      $pkg_parse
      | get -o 2
      | default null
    )

    git clone $pkg_repo $tmp_dir

    mut pkg_path = (
      [
        $tmp_dir
        $pkg_name
      ] | path join
    );

    if not ( $pkg_path | path exists ) {
      panic $"No script found with name ( $pkg_name ) in ( $pkg_repo )"

    }

    if ( $pkg_rename | is-not-empty ) {
      let new_pkg_name = (
        [
          $tmp_dir
          $pkg_rename
        ] | path join
      )

      if ( $new_pkg_name | path exists ) {
        rm -rfp $new_pkg_name;

      }

      mv $pkg_path $new_pkg_name;

      $pkg_path = $new_pkg_name;

      $pkg_name = $pkg_rename;

    }

    let use_cmd_string = (
      $"use ( $pkg_name );" | nu-highlight
    );
    print $"(ansi gb)add this to ur config:(ansi reset)\n(ansi p)```nu(ansi reset)\n($use_cmd_string)\n(ansi p)```(ansi reset)";

    return {
      name: $pkg_name
      repo: ( [ $pkg_repo $pkg_name ] | str join "*" )
      path: $pkg_path
      pkg_type: $pkg_type
    }

  }

}
