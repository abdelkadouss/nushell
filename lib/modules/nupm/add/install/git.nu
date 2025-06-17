use ../link/script.nu link_script;
use ../link/bin.nu link_bin;

# the git installer module
export def install_via_git [ repo: string ] {
  cd $env.data_path;
  git clone $repo;
  cd ("./" | path join $env.package_name);

  mut packgae_type = "script";
  if ( ls | where name =~ "nupm.nuon" | is-not-empty ) {
    if (
      open nupm.nuon
      | get -i type
      | is-not-empty
    ) {
      $packgae_type = (open nupm.nuon | get -i type);

    };

  } else {
    if (
      ls
      | where name =~ "Cargo.toml"
      | is-not-empty
    ) {
      $packgae_type = "custom";

    };

  };

  if ($env.config.plugins.nupm.NUPM_DIST_PATH? | is-empty) {
    print $"(ansi yellow_bold)warning(ansi reset). you have not set the 'NUPM_DIST_PATH' config fild. the packages will be installed to the default path '($env.config.plugins.nupm.NUPM_HOME | path join 'plugins')' make sure to add this path to $env.NU_LIB_DIRS list to easy use or set the var and reinstall the plugin"

  };

  match $packgae_type {
    "script" => { script_add }
    "custom" => { bin_add $repo }
    "module" => { module_add }
    _ => {
      error make {
        msg: $"Unknown package type '($packgae_type)'."
        label: {
          text: "this package type is not supported or not valid"
          span: (metadata $packgae_type).span
        }

        help: "the valid package types are 'script', 'custom' and 'module'"

      }

    }

  };

}
