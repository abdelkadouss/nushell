export def "nupm update" [] {
  let data_path = (
    $env.config.plugins.nupm.NUPM_DATA_PATH?
    | default
    (
      $env.XDG_DATA_HOME
      |
      path join "nupm/packages"
    )
  );

  for package in (
    ls --full-paths $data_path
    | where type == "dir"
    | get name
  ) {
    let app_name = ($package | path basename);

    cd $package;
    if (
      ls
      | where type == "dir"
      | where name =~ ".git"
      | is-not-empty
    ) { git pull };

    if (
      ls
      | where type == "file"
      | where name =~ "Cargo.toml"
      | is-not-empty
    ) {
      try {
        cargo build --release;

        print $"(ansi green_bold)($app_name) build done ✨🌼, thank's to Allah(ansi reset)"

        bin_add $app_name;

      } catch {
        print $"(ansi red_bold)failed in building the package '($package)'(ansi reset)"

      };


    } else {
      print $"(ansi blue_bold)Will ($package) is not a rust project, skip build(ansi reset)"

    };

  };

};

def bin_add [package_name: string] {
  let dist_path = (
    $env.config.plugins.nupm.NUPM_DIST_PATH?
    | default
    (
      $env.config.plugins.nupm.NUPM_HOME
      | path join "plugins"
    )
  );
  let dist_bin_path = (
    $dist_path
    | path join "bin"
  );
  mkdir $dist_bin_path | ignore;

  cargo build --release;

  if (
    ($dist_bin_path | path join $package_name)
    | path exists
  ) {
    unlink ($dist_bin_path | path join $package_name);

  };

  ln ("./target/release/" | path join $package_name) $dist_bin_path;

  print $"done thank's to Allah, 'custom' is added to '($dist_bin_path)'"
  print $"add the plugin to load..."

  let bin_path = ($dist_bin_path | path join $package_name);

  print $"(ansi green_bold)done ✨🌼, thank's to Allah(ansi reset)."
}
