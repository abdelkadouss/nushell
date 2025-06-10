use add.nu "nupm add";

export def "nupm rebuild" [] {
  if ( $env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH? | is-empty ) {
    error make {
      msg: $"NUPM_PACKAGE_DECLARATION_FILE_PATH env var is not set"
      label: {
        text: "env var not set"
        span: (metadata $env.config.plugins).span
      }

      help: "declare the NUPM_PACKAGE_DECLARATION_FILE_PATH env var first under the config.plugins.nupm record.\n that should point to package.toml file that contain {'package_name': 'package_repo'}"

    }

  }

  if not ( $env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH | path exists ) {
    error make {
      msg: $"NUPM_PACKAGE_DECLARATION_FILE_PATH env var is pointing to a non existing file '($env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH)'"
      label: {
        text: "file not found"
        span: (metadata $env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH).span
      }

      help: "make sure the NUPM_PACKAGE_DECLARATION_FILE_PATH points to a valid package.toml file that contain {'package_name': 'package_repo'}"

    }

  }

  let data_dir = (
    [
      $env.XDG_DATA_HOME,
      "nupm",
      "packages"
    ]
    | path join
  );
  mkdir $data_dir;

  for package in (
    open $env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH
    | get packages
    | transpose name repo
  ) {
    rm -rf ( [ $data_dir, $package.name ] | path join );
    nupm add $package.repo;

  };

};
