use "./data_path.nu" get_data_path;

use "./state_manager.nu" "state delete";

use ../../shared/external *;

alias run = external run;

export def apps [] {
  let data_path = (get_data_path);
  (
    open 
    (
      $data_path
      | path join "apps.toml"
    )
    | get apps
    | transpose apps stuff
    | get apps
  )
};

export def "self host stop" [
  app_name: string@apps ,
  --stop-machine(-m) = false
  ] {

  external exist --panic true [ "colima", "docker" ];

  let data_path = (get_data_path);

  let app_path = (
    open 
    (
      $data_path
      | path join "apps.toml"
    )
    | get apps
    | get -o $app_name
    | get path

  );

  let app_type = (
    open (
      $data_path
      | path join "apps.toml"
    )
    | get apps
    | get -o $app_name
    | get type

  );

  if ($app_path | is-empty) {
    error make {
      msg: $"the app '($app_name)' does not exist."
      label: {
        text: "this app does not exist"
        span: (metadata $app_name).span
      }
      help: $"go ahead and make the app in the ($data_path | path join 'apps.toml') file"
    }

  };

  if ($app_path | path exists) {
    cd $app_path;

    if ($app_type == "default") {
      run docker compose `-p` $app_name down;

    } else {
      export-env {
        nu (
          $data_path
          | path join ".self_host_custom_host_script"
          | path join $app_name
          | path join $"($app_name).nu"
        ) stop;
      };

    };

    if $stop_machine { run colima stop | ignore };

    state delete $app_name;

    print $"(ansi green_bold)done thank's to Allah, the app now should be down.(ansi reset)"
  };
};
