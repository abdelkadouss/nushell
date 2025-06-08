use "./data_path.nu" get_data_path;

export use "./start.nu" *;
export use "./stop.nu" *;

export def "self host" [
  path: string,
  app_name: string,
  --custom-host-script(-c): string = "default",
] {
  if not ($path | path exists) {
    error make {
      msg: $"the path '($path)' does not exist."
      label: {
        text: "this path does not exist"
        span: (metadata $path).span
      }
      help: $"give me a real path please."
    }
  };

  let data_path = (get_data_path);

  mkdir $data_path | ignore;
  mkdir ($data_path | path join ".self_host_custom_host_script");

  if ($path | path type | $in == file) {
    mkdir ($data_path | path join $app_name);
  };
  cp -r -p $path ($data_path | path join $app_name);

  let path = ($data_path | path join $app_name);

  if ($custom_host_script == "default") {
    if ($env.config.plugins.self_host.use_colima? | is-not-empty) { colima start | ignore };
    cd ($data_path | path join $app_name);
    docker-compose -p $app_name up -d;
  } else {
    print $"(ansi green_bold)done thank's to Allah, now copping the custom host script.(ansi reset)"
    mkdir ($data_path | path join ".self_host_custom_host_script" | path join $app_name);
    cp -r -p $custom_host_script ($data_path | path join ".self_host_custom_host_script" | path join $app_name);
    cd ($data_path | path join $app_name);
    export-env {
      nu (
        [
          $data_path,
          ".self_host_custom_host_script",
          $app_name,
          $"($app_name).nu"
        ] | path join
      ) start
    };
    print $"(ansi green_bold)done thank's to Allah, the app now should be up and running.(ansi reset)"
  };

  let apps = (
    open ($data_path | path join "apps.toml")
    | get apps
    | upsert $app_name {
      name: $app_name
      path: $path
      type: (
        match $custom_host_script {
          "default" => { "default" }
          _ => { "custom" }
        }
      )
    }
  );

  open ($data_path | path join "apps.toml")
  | upsert apps $apps
  | save -f ($data_path | path join "apps.toml");
  print $"(ansi green_bold)done ✨🌼, thank's to Allah(ansi reset)."

};
