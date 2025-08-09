use ../shared/external *;

# env

## config
if not ( $env.config.plugins.new.templates_dir? | path exists ) {
  mkdir $env.config.plugins.new.templates_dir?;
}

# path

let path_groups = [ ];

for path in ($path_groups | flatten) {
  if ($path | path exists) {
    $env.path = ($env.path | prepend $path);
  }
};


# drop unneeded imports from the global scope
hide soft_run_bin_if_in_path;
