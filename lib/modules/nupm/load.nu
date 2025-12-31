use ../../shared/environment.nu *;

use app_config.nu *;

# load the plugins
export def "nupm load" [] {
  config check;

  let plugins_declaration_file = env exists --panic --return-value $.config.plugins.nupm.NUPM_PLUGINS_DECLARATION_FILE_PATH;

  let plugins_bin = (
    open $plugins_declaration_file
    | get bin
  );

  for bin in ( $plugins_bin | transpose name path ) {
    print $bin.path;
    try {
      plugin add ( $bin | get path );

      print $"🔌 ($bin.name)"

    } catch { print $"❌ (ansi rb)($bin.name)(ansi reset)" };


  };

  print $"(ansi gb) Done thank's to Allah 🌻(ansi reset)";

};
