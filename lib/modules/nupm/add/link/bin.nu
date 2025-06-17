use ../declarer.nu write_declaration_file;

# add the bin to the plugins/bin dir
export def link_bin [] {
  let dist_path = (
    $env.config.plugins.nupm.NUPM_DIST_PATH?
    | default
    (
      $env.config.plugins.nupm.NUPM_HOME
      | path join "plugins"
    )
  );

  let dist_bin_path = ($dist_path | path join "bin");
  mkdir $dist_bin_path | ignore;

  cargo build --release;

  if (
    (
      $dist_bin_path
      | path join $env.package_name
    )
    | path exists
  ) {
    unlink ($dist_bin_path | path join $env.package_name);

  };

  ln ("./target/release/" | path join $env.package_name) $dist_bin_path;

  print $"done thank's to Allah, 'custom' is added to '($dist_bin_path)'"
}
