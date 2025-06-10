export def "nupm list" [] {
  if ( $env.config.plugins.nupm.NUPM_BIN_DECLARATION_FILE_PATH? | is-empty ) {
    print "no thing there yet 📭";

  };
  
  open $env.config.plugins.nupm.NUPM_BIN_DECLARATION_FILE_PATH
  | get plugins
  | transpose name path

};
