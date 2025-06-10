export def "nupm add" [ repo: string ] {
  let data_path = (
    $env.config.plugins.nupm.NUPM_DATA_PATH?
    | default
    (
      $env.XDG_DATA_HOME
      | path join "nupm/packages"
    )
  );
  mkdir $data_path;

  let endpoint = ($repo | path basename);
  let package_name = ( $endpoint
    | str ends-with ".git"
    | match $in {
      true => { $endpoint | path parse | get stem }
      false => {$endpoint}
    }
  );

  let package_declaration_file_path = (
    $env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH?
    | default
    (
      $env.NU_CONFIG_DIR
      | path join "packages.toml"
    )
  );

  let bin_declaration_file_path = (
    $env.config.plugins.nupm.NUPM_BIN_DECLARATION_FILE_PATH?
    | default
    (
      $env.NU_CONFIG_DIR
      | path join "plugins.toml"
    )
  );

  if not (
    (
      $package_declaration_file_path
      | path exists
    )
    or
    (
      $bin_declaration_file_path
      | path exists
    )
  ) {
    error make {
      msg: $"The package declaration file '(
      $package_declaration_file_path
      | path exists
      | default $bin_declaration_file_path
    )' does not exist."

      label: {
        text: "this package declaration file is not valid"
        span: (
          metadata (
            $package_declaration_file_path
            | path exists
            | default $bin_declaration_file_path
          )
        ).span

      }

      help: $"go ahead and make the packages.toml file and the plugin.toml file in the ($package_declaration_file_path) or ($bin_declaration_file_path)"

    }
  };

  cd $data_path;
  git clone $repo;
  cd ("./" | path join $package_name);

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
    "script" => {script_add $package_name}
    "custom" => {bin_add $package_name $bin_declaration_file_path $package_declaration_file_path $repo}
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

};

def script_add [ package_name: string ] {
  print $"\n(ansi blue)wiil this package look's like a script?, so i don't sure what file i should add, but i ganna make a tye any way...(ansi reset)"

  let file = $"($package_name).nu";

  if (
    ls
    | where type == "file"
    | get -i $file
    | is-not-empty
  ) {
    print $"(ansi green_bold)will i think i find the correct file!. '($package_name)'(ansi reset)"

    let dist_path = (
      $env.config.plugins.nupm.NUPM_DIST_PATH?
      | default
      ($env.config.plugins.nupm.NUPM_HOME
        | path join "plugins"
      )
    );

    let dist_script_path = (
      $dist_path
      | path join "scripts"
    );
    mkdir $dist_script_path | ignore;

    try {
      ln $file $dist_script_path;
      print $"(ansi green_bold)done thank's to Allah(ansi reset)";

    } catch {
      print -e $"(ansi red) ERROR some thing wont wrong!.(ansi reset)"

    };

  } else {
    print $"(ansi red_bold)failed(ansi reset). u have to add the file symlinks manually.\n (ansi green) help:\n$ cd \($env.config.plugins.nupm.NUPM_DATA_PATH? | default \($env.XDG_DATA_HOME | path join 'nupm/packages'))\n$ cd ($package_name)\n$ ls"

  };

}

def bin_add [
  package_name: string,
  bin_declaration_file_path: string,
  package_declaration_file_path: string,
  repo_url: string
] {
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
      | path join $package_name
    )
    | path exists
  ) {
    unlink ($dist_bin_path | path join $package_name);

  };

  ln ("./target/release/" | path join $package_name) $dist_bin_path;

  print $"done thank's to Allah, 'custom' is added to '($dist_bin_path)'"
  print $"add the plugin to load..."

  let bin_path = ($dist_bin_path | path join $package_name);

  let new_bins = (
    open $bin_declaration_file_path
    | get bins
    | upsert $package_name $bin_path
  );

  open $bin_declaration_file_path 
  | upsert bins $new_bins
  | save -f $bin_declaration_file_path

  let new_package = (
    open $package_declaration_file_path
    | get packages
    | upsert $package_name $repo_url
  );

  open $package_declaration_file_path
  | upsert packages $new_package
  | save -f $package_declaration_file_path

  print $"(ansi green_bold)done ✨🌼, thank's to Allah(ansi reset)."

}

def module_add [] {

  let package = do {
    ls .
    | where type == "dir"
    | each { |dir|
      ls ($dir | get name)
      | where name =~ "mod.nu"
      | is-not-empty
      | match $in {
        true => { $dir }
        false => { continue }
      }
    } 
  };

  let package_name = ($package | get name | first);

  mkdir ~/.config/nushell/plugins/modules;
  ln $package_name $"($env.home)/.config/nushell/plugins/modules";

}
