use "./data_path.nu" get_data_path;

use "./state_manager.nu" "state add";

use ../../shared/external *;

alias run = external run;

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
  external exist --panic true [ "colima", "docker-compose" ];

  let data_path = (get_data_path);

  let app_path = (
    open (
      $data_path
      | path join "apps.toml"
    )
    | get apps
    | get -o $app_name
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
    try {
      run colima start `--vm-type` qemu | ignore;
    } catch { ignore };
    run docker-compose `-p` $app_name up `-d`;

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

