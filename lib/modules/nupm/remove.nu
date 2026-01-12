use declare.nu 'plugin undeclare';
use config.nu 'config remove';

use runtime.nu *;

# remove a plugin
export def "nupm remove" [
  pkg_name: string
] {
  runtime check;

  let plugin_declaration = ( runtime info | get plugins_declaration_file );

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
