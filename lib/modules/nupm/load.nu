# source this file in your config.nu
for bin in (
  open $env.config.plugins.nupm.NUPM_BIN_DECLARATION_FILE_PATH
  | get bins
  | transpose name path
  ) {
  (
    plugin add $bin.path
  ) | ignore ;
}
# manual plugin
# use ("~/.local/share/nupm/modules" | path join "nupm")
