export def "nupm info" [ plugin_name: string = "*" ] {
  if $plugin_name == "*" {
    open $env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH
    | get packages
    | transpose name repo;

  } else {
    open $env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH
    | get packages
    | transpose name repo
    | where name =~ $plugin_name;

  };

};
