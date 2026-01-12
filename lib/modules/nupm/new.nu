use runtime.nu DEFAULT_LOCAL_MODULE_CONFIG_FILE_RELATIVE_PATH;

export def "nupm new" [] {
  let DEFAULT_EMPTY_CONFIG: string = $"
{
  name: ( pwd | path basename )
  description: 'nushell plugin'
  version: ( version | get version )
  type: module
  license: unknown

  packages: { }
}
"

  try {
    $DEFAULT_EMPTY_CONFIG
    | save $DEFAULT_LOCAL_MODULE_CONFIG_FILE_RELATIVE_PATH;
    print $"(ansi gb)🌻 New nupm config file made 🌻, thank's to Allah 🌻(ansi reset)";

  } catch {
    print $"(ansi rb)❌ Nupm config file already exists ❌, thank's to Allah 🌻(ansi reset)";

  }

}
