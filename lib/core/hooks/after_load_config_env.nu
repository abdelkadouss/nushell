use ../shared/bin_utils.nu soft_run_bin_if_in_path;

# env

## config
if not ( $env.config.plugins.new.templates_dir? | path exists ) {
  mkdir $env.config.plugins.new.templates_dir?;
}

## podman
$env.DOCKER_HOST = (
  (
    (
      soft_run_bin_if_in_path 
      '{
      ConnectionInfo: {
      PodmanSocket: {
      path: ["no-podman-machine-,-help:-run-podman-machine-init"]
      }
      }
      }'
      podman machine inspect podman-machine-default
      | from json
      | get -i ConnectionInfo
      | get -i PodmanSocket
      | get -i Path
      | first
    )
    | {
      scheme: "unix",
      host: $in
    } | url join 
  ) | default 'no-podman-machine-,-help:-run-podman-machine-init'
);

$env.CONTAINER_HOST = $env.DOCKER_HOST;

# $env.PROTO_VERSION = (
#   soft_run_bin_if_in_path 0
#   proto --version
#   | split row " "
#   | get 1
# );

# path

let nupm = [
  ($env.config.plugins.nupm.NUPM_HOME | path join "scripts")
];

let path_groups = [
  $nupm
];

for path in ($path_groups | flatten) {
  if ($path | path exists) {
    $env.path = ($env.path | prepend $path);
  }
};


# drop unneeded imports from the global scope
hide soft_run_bin_if_in_path;
