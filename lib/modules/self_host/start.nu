use "./data_path.nu" get_data_path;

use "./state_manager.nu" "state add";

use ../../shared/bin_utils.nu [run_bin_if_in_path, make_sure_bin_in_the_path];

alias run = run_bin_if_in_path;

export def apps [] {
  let data_path = (get_data_path);
  (
    open ($data_path | path join "apps.toml")
    | get apps
    | transpose apps stuff
    | get apps
  )
};

export def "self host start" [app_name: string@apps] {
  make_sure_bin_in_the_path [ "podman", "podman-compose" ];

  let data_path = (get_data_path);

  let app_path = (
    open (
      $data_path
      | path join "apps.toml"
    )
    | get apps
    | get -i $app_name
    | get path
  );

  if ($app_path | path exists) and not ($app_path | is-empty) {
    cd $app_path;

  } else {
    error make {
      msg: $"the app '($app_name)' does not exist."
      label: {
        text: "this app does not exist"
        span: (metadata $app_name).span
      }
      help: $"go ahead and make the app in the ($data_path | path join 'apps.toml') file"
    }

  };

  let app_type = (
    open (
      $data_path
      | path join "apps.toml"
    )
    | get apps
    | get $app_name
    | get type
  );

  if ($app_type == "default") {
    run podman machine start | ignore;
    run podman-compose -p $app_name up -d;

  } else {
    export-env {
      nu (
        [
          $data_path,
          ".self_host_custom_host_script",
          $app_name ,
          $"($app_name).nu"
        ] | path join
      ) start
    };

  };

  state add $app_name;

  print $"(ansi green_bold)done thank's to Allah, the app now should be up.(ansi reset)"
}

