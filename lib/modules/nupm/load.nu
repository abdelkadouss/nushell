use runtime.nu *;

# load the plugins
export def "nupm load" [] {
  runtime check;

  let plugins_declaration_file = ( runtime info | get plugins_declaration_file );

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
