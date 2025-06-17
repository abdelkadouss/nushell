export def --env declare_env [
  repo_url_or_cargo_crate_name: string # the repo url or the cargo crate name
  installtion_type: string = "git" # git or cargo
] {
  # pass the var to env to use it in multiple functions
  $env.data_path = (
    $env.config.plugins.nupm.NUPM_DATA_PATH?
    | default
    (
      $env.XDG_DATA_HOME
      | path join "nupm/packages"
    )
  );
  mkdir $env.data_path;

  $env.package_declaration_file_path = (
    $env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH?
    | default
    (
      $env.NU_CONFIG_DIR
      | path join "packages.toml"
    )
  );

  $env.bin_declaration_file_path = (
    $env.config.plugins.nupm.NUPM_BIN_DECLARATION_FILE_PATH?
    | default
    (
      $env.NU_CONFIG_DIR
      | path join "plugins.toml"
    )
  );
  if not ($env.bin_declaration_file_path | path exists) {
    "[bins]" | save -f $env.bin_declaration_file_path;
  };

  if $installtion_type == "cargo" {
    $env.package_name = $repo_url_or_cargo_crate_name;

  } else {
    let endpoint = ($repo_url_or_cargo_crate_name | path basename);
    $env.package_name = ( $endpoint
      | str ends-with ".git"
      | match $in {
        true => { $endpoint | path parse | get stem }
        false => {$endpoint}
      }
    );

  };

  if not (
    (
      $env.package_declaration_file_path
      | path exists
    )
  ) {
    error make {
      msg: $"The package declaration file '(
      $env.package_declaration_file_path
      | path exists
      | default $env.bin_declaration_file_path
    )' does not exist."

      label: {
        text: "this package declaration file is not valid"
        span: (
          metadata (
            $env.package_declaration_file_path
            | path exists
            | default $env.bin_declaration_file_path
          )
        ).span

      }

      help: $"go ahead and make the packages.toml file and the plugin.toml file in the ($env.package_declaration_file_path) or ($env.bin_declaration_file_path)"

    }
  };

}
