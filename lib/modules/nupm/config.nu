use shared/environment.nu *;

use app_config.nu *;

export def "config read" [] {
  let input_file = env exists --panic --return-value $.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH;

  return ( open $input_file | get -o packages );

}

export def "config write" [
  pkg: record<
        name: string,
        repo: string,
        type: string
  >
] {
  config check;

  let target_file = env exists --panic --return-value $.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH;

  open $target_file
  | get -o packages
  | default {}
  | upsert $pkg.name {
    repo: $pkg.repo,
    type: $pkg.type

  }
  | { packages: $in }
  | save -f $target_file;

}

export def "config remove" [
  pkg_name: string
] {
  config check;

  let target_file = env exists --panic --return-value $.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH;

  open $target_file
  | get -o packages
  | default {}
  | reject $pkg_name
  | { packages: $in }
  | save -f $target_file;

}
