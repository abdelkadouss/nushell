# env

# path

let nupm = [
  ($env.config.plugins.nupm.NUPM_HOME | path join "scripts")
];

for path in ($path_groups | flatten) {
  if ($path | path exists) {
    $env.path = ($env.path | prepend $path)
  }
};

