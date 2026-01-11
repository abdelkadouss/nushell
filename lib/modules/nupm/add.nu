use shared/environment.nu *;

use installer.nu *;
use declare.nu 'plugin declare';
use config.nu 'config write';

use app_config.nu *;

# install a plugin
export def 'nupm add' [
  pkg_repo: string,
  installation_type: string
] {
  config check;

  let dist_paht = env exists --panic --return-value $.config.plugins.nupm.NUPM_DIST_PATH;

  match $installation_type {
    'cargo-git' => {|| install cargo_git $pkg_repo },
    'crate' => {|| install crate $pkg_repo },
    'git-module' => {|| install git_script_or_module $pkg_repo "module" },
    'git-script' => {|| install git_script_or_module $pkg_repo "script" },
    _ => { panic $"Unknown installation type: ( $installation_type )" }

  }
  | do $in
  | (
    {
      ...$in
      type: $installation_type
    }
  )
  | (
    let pkg_type = ( $in.pkg_type );
    let dist_paht = ( $dist_paht | path join $pkg_type );
    mkdir $dist_paht;
    mv $in.path $dist_paht;

    let new_path = (
      [
        $dist_paht,
        (
          $in
          | get path
          | path basename
        )
      ] | path join
      | path expand
    );

    let pkg_name = ( $in.name );

    plugin declare $pkg_name $new_path $in.pkg_type;
    config write ( $in | reject path pkg_type );

    print $"(ansi gb)Package (ansi bu)( $in.repo | ansi link --text $pkg_name )(ansi reset)(ansi gb) added in Chaa'Allah, thank's to Allah 🌻(ansi reset)";

  );



};
