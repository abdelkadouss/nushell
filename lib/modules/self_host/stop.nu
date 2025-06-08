use "./data_path.nu" get_data_path;

export def apps [] { let data_path = (get_data_path); (open ($data_path | path join "apps.toml") | get apps | transpose apps stuff | get apps) };

export def "self host stop" [
  app_name: string@apps ,
  --stop-colima(-c) = false,
] {

  let data_path = (get_data_path);

  let app_path = (open ($data_path | path join "apps.toml") | get apps | get -i $app_name | get path);
  let app_type = (open ($data_path | path join "apps.toml") | get apps | get -i $app_name | get type);
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
      docker-compose -p $app_name down;
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
    if $stop_colima { colima stop | ignore; if ($env.config.plugins.self_host.use_colima? | is-empty) {print $"(ansi black)info: u wanna me to stop colima and u don't set use_colima to 'true' fild in config(ansi reset)"} };
    print $"(ansi green_bold)done thank's to Allah, the app now should be down.(ansi reset)"
  };
};
