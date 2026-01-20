use ../../shared/external *;

use data_path.nu get_data_path;
use start.nu apps;

export def "self host update" [ app_name: string@apps ] {
  external exist --panic true [ colima docker ];

  let data_path = (get_data_path);

  let app = (
    open (
      $data_path
      | path join "apps.toml"
    )
    | get apps
    | get -o $app_name
  );

  if ($app.path | is-empty) or not ($app.path | path exists) {
    error make {
      msg: $"the app '($app_name)' does not exist."
      label: {
        text: "this app does not exist"
        span: (metadata $app_name).span
      }
      help: $"go ahead and make the app in the ($data_path | path join 'apps.toml') file"
    }

  }

  cd $app.path;

  match $app.type {
    "default" => {
      try {
        run colima start `--vm-type` qemu | ignore;
      } catch { ignore };
      external run --panic true docker compose pull;

    }
    "custom" => {
      nu (
        [
          $data_path
          ".self_host_custom_host_script"
          $app_name
          $"($app_name).nu"
        ] | path join
      ) update
    }
  }

  print $"(ansi gb)done thank's to Allah, the app now should be up to date.(ansi reset)"

}
