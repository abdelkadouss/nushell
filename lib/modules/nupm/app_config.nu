export def "config check" [] {
  let config_file = env exists --panic --return-value $.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH

  let plugins_declaration_file = env exists --panic --return-value $.config.plugins.nupm.NUPM_PLUGINS_DECLARATION_FILE_PATH

  let dist_path = env exists --panic --return-value $.config.plugins.nupm.NUPM_DIST_PATH

  let nupm_home = env exists --panic --return-value $.config.plugins.nupm.NUPM_HOME

  let tmp_dir = env exists --panic --return-value $.config.plugins.nupm.NUPM_TMP_DIR

  for file in [
    $config_file,
    $plugins_declaration_file
  ] {
    if not ( $file | path exists) {
      touch $file;
      
    };

  };

  for dir in [
    $dist_path,
    $nupm_home,
    $tmp_dir
  ] {
    if not ( $dir | path exists ) {
      mkdir $dir;

    };

  };

};
