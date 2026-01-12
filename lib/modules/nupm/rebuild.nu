use declare.nu 'plugin undeclare';
use add.nu 'nupm add';
use runtime.nu *;

# install the plugins based on the declaration file
export def "nupm rebuild" [
  packages?: list
  --global(-g) # rebuild the packages from the global config
  --if-not-exists(-i) # dont rebuild the package if already installed
] {
  runtime check;

  if $global {
    $env.OVERRIDE_RUNTIME_TYPE_GLOBAL = true;
  }

  let input_file = ( runtime info | get packages_declaration_file );

  print $" (ansi gb)Using: (ansi bu)( $input_file )(ansi reset)";

  let plugins = (
    open $input_file
    | get -o packages
    | transpose name info
    | (
      let all_packages = $in.name;
      $in
      | where {|pkg| $pkg.name in ( $packages | default $all_packages) }
    )
  );

  for plugin in $plugins {
    let plugin_info = (
      find path-and-type $plugin.name
    );

    if (
      $plugin_info.path?
      | is-not-empty
    ) and (
      $plugin_info.path
      | path exists
    ) and ( $if_not_exists ) { continue };

    print $"(ansi bb) ($plugin.name): (ansi reset)";

    try {
      rm -rfp $plugin_info.path;

      print $"\t🗑️:";
      print $"(ansi rb)\t- ($plugin.name)(ansi reset)";

      plugin undeclare $plugin.name $plugin_info.type;

    }

    print $"\t🚚📦:";
    try {
      nupm add $plugin.info.repo $plugin.info.type;
      print $"(ansi gb) Done, thank's to Allah 🌻(ansi reset)";

    } catch {|err|
      print $err.rendered;
      
    }

  };

  print $"(ansi gb) It's all done, thank's to Allah 🌻(ansi reset)";

};

def 'find path-and-type' [
  pkg_name: string
] {
  let plugins_declaration_file = (
    runtime info | get plugins_declaration_file
  );

  for type in [ 'bin' 'module' 'script' ] {
    open $plugins_declaration_file
    | get -o $type
    | default [ ]
    | transpose name path
    | where name == $pkg_name
    | (
      if ( $in | is-not-empty ) {
        return {
          type: $type
          path: ( $in | first | get path )
        }
        break;
      }
    )
  }
}
