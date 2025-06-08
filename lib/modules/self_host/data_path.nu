export def get_data_path [] {
  return (
    $env.config.plugins.self_host.data_path?
    | default (
      $env.XDG_DATA_HOME
      | path join "self_host"
    )
  );

};
