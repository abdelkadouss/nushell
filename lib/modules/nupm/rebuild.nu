use ../../shared/environment.nu *;

use declare.nu 'plugin undeclare';
use add.nu 'nupm add';

use app_config.nu *;

export def "nupm rebuild" [] {
  config check;

  let input_file = env exists --panic --return-value $.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH;

  let plugins_declaration_file = env exists --panic --return-value $.config.plugins.nupm.NUPM_PLUGINS_DECLARATION_FILE_PATH;

  let plugins_declaration = (
    open $plugins_declaration_file
    | get -o packages
  )

  for plugin in (
    open $input_file
    | get -o packages
    | transpose name info
  ) {
    print $"(ansi bb) ($plugin.name): (ansi reset)";

    print $"\t🗑️:";
    try {
      rm -rfp $plugins_declaration
      | get $plugin.info.pkg_type
      | get $plugin.name
      | rm -rfp $in.path;

      plugin undeclare $plugin.name $plugin.info.pkg_type;

    }

    print $"\t🚚📦:";
    try {
      nupm add $plugin.info.repo $plugin.info.type;
      print $"Done, thank's to Allah 🌻";

    }

  };

  print $"(ansi gb) It's all done, thank's to Allah 🌻(ansi reset)";

};
