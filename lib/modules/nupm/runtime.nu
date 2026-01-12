use shared/environment.nu *;

export const DEFAULT_LOCAL_MODULE_CONFIG_FILE_RELATIVE_PATH = './nupm.nuon';
const DEFAULT_LOCAL_MODULE_CONFIG: record = {
  tmp_dir: ./target/tmp
  plugins_declaration_file: ./target/plugins.toml
  dist_path: ./target/deps
  nupm_home: ./target/nupm
}

export def "runtime check" [] {
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

export def 'runtime type' [ ] {
  if (
    $DEFAULT_LOCAL_MODULE_CONFIG_FILE_RELATIVE_PATH
    | path exists
  ) { "MODULE" } else { "GLOBAL" }

}

export def "runtime info" [
  --override-type(-t): string # override the runtime type [GLOBAL|MODULE]
]: nothing -> record {
  let runtime_type: string = $override_type | default { runtime type };

  match $runtime_type {
    "GLOBAL" => {
      return {
        packages_declaration_file: ( env exists --panic --return-value $.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH ),
        tmp_dir: ( env exists --panic --return-value $.config.plugins.nupm.NUPM_TMP_DIR ),
        plugins_declaration_file: ( env exists --panic --return-value $.config.plugins.nupm.NUPM_PLUGINS_DECLARATION_FILE_PATH ),
        dist_path: ( env exists --panic --return-value $.config.plugins.nupm.NUPM_DIST_PATH ),
        nupm_home: ( env exists --panic --return-value $.config.plugins.nupm.NUPM_HOME ),
      }
      print $"🌻 Global runtime type detected 🌻"

    },
    "MODULE" => {
      let local_module_config_file_content = (
        open $DEFAULT_LOCAL_MODULE_CONFIG_FILE_RELATIVE_PATH
      );

      let config = {
        packages_declaration_file: $DEFAULT_LOCAL_MODULE_CONFIG_FILE_RELATIVE_PATH,
        tmp_dir: ( $DEFAULT_LOCAL_MODULE_CONFIG.tmp_dir ),
        plugins_declaration_file: ( $DEFAULT_LOCAL_MODULE_CONFIG.plugins_declaration_file ),
        dist_path: ( $DEFAULT_LOCAL_MODULE_CONFIG.dist_path ),
        nupm_home: ( $DEFAULT_LOCAL_MODULE_CONFIG.nupm_home ),
      }

      mkdir $config.tmp_dir;
      mkdir $config.dist_path;
      mkdir $config.nupm_home;

      if not (
        $config.plugins_declaration_file
        | path exists
      ) { touch $config.plugins_declaration_file };

      return $config;

    }

    _ => { panic $"Unknown runtime type: ( $runtime_type )" }

  }

}
