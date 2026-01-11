use shared/environment.nu *;

use declare.nu 'plugin undeclare';
use config.nu 'config remove';

use app_config.nu *;

# remove a plugin
export def "nupm remove" [
  pkg_name: string
] {
  config check;

  let plugin_declaration = env exists --panic --return-value config.plugins.nupm.NUPM_PLUGINS_DECLARATION_FILE_PATH;

  open $plugin_declaration
  | transpose type pkgs
  | each {|pkgs_stuck|
    $pkgs_stuck.pkgs
    | get -o $pkg_name
    | (
      if ( $in | is-not-empty ) {
        rm -rfp $in;
        plugin undeclare $pkg_name $pkgs_stuck.type;
        config remove $pkg_name;
        print $"Done, thank's to Allah 🌻";
        return;

      };

    );

  };

  print $"(ansi rb) No plugin found for ( $pkg_name )(ansi reset)";

};
