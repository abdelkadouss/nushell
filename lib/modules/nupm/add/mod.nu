use env.nu declare_env;
use install/git.nu install_via_git;
use link/script.nu link_script;
use link/bin.nu link_bin;

# install new package, module, script or plugin
export def "nupm add" [
  repo: string # the repo url
  --cargo(-c) # install the package with cargo (default is install via git)

] {
  declare_env $repo (
    if $cargo { "cargo" } else { "git" }
  );

  match $cargo {
    "cargo" => { install_via_cargo $repo },
    "git" => { install_via_git $repo },
    _ => {
      error make {
        msg: $"Unknown package type '($cargo)'."
        label: {
          text: "this package type is not supported or not valid"
          span: (metadata $cargo).span
        }

        help: "the valid package types are 'cargo' and 'git'"

      };
    }

  };

  print $"add the plugin to load...";
  match $env.packgae_type {
    "script" => { link_script }
    "custom" => { link_bin }
    "module" => { module_add }
    _ => {
      error make {
        msg: $"Unknown package type '($env.packgae_type)'."
        label: {
          text: "this package type is not supported or not valid"
          span: (metadata $env.packgae_type).span
        }

        help: "the valid package types are 'script', 'custom' and 'module'"

      }

    }

  }

};
