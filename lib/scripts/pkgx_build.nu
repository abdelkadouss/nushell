export def "pkgx --build" [] {
  let config_file = (
    [
      $env.XDG_CONFIG_HOME
      "pkgx/tools.yml"
    ] | path join
  )

  if ( $config_file | path exists ) {
    open $config_file
    | get tools
    | each {|tool|
      try {
        if ( $tool | describe ) == "string" {
          run-external pkgx $"+($tool)"
          run-external pkgx pkgm shim $tool

        } else {
          let pkg = ( $tool | transpose exec_name project | first );
          run-external pkgx $"+($pkg.project)" $"+($pkg.exec_name)"
          run-external pkgx pkgm shim $pkg.exec_name

        }

        print $"(ansi gb)($tool | into string), thanks to Allah(ansi reset)"

      } catch {|err|
        print $"(ansi rb)failed to install(ansi reset) (ansi bu)($tool)(ansi reset)"
        print $err.rendered

      }

    }

    print $"(ansi gb)Done, thanks to Allah(ansi reset)"

  } else {
    print $"(ansi rb)No config file, ($config_file) is not exist(ansi reset)"

  }


}
