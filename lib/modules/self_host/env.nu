use "../../shared/bin_utils.nu" soft_run_bin_if_in_path;

export def --env "inject self host env" [] {
  $env.CONTAINER_HOST = (
    (
      soft_run_bin_if_in_path 
      '{
      ConnectionInfo: {
      PodmanSocket: {
      path: ["no-podman-machine-,-help:-run-podman-machine-init"]
      }
      }
      }'
      podman machine inspect $env.config.plugins.self_host.podman_machine
      | from json
      | get -i ConnectionInfo
      | get -i PodmanSocket
      | get -i path
      | first
      | {
        scheme: "unix",
        host: $in
      } | url join 
    ) | default 'no-podman-machine-,-help:-run-podman-machine-init'
  );

  $env.DOCKER_HOST = $env.CONTAINER_HOST;

};
