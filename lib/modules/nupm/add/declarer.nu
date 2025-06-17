export def write_declaration_file [ dist_bin_path: string ] {
  let bin_path = ($dist_bin_path | path join $env.package_name);

  let new_bins = (
    open $env.bin_declaration_file_path
    | get bins
    | upsert $env.package_name $bin_path
  );

  open $env.bin_declaration_file_path 
  | upsert bins $new_bins
  | save -f $env.bin_declaration_file_path

  let new_package = (
    open $env.package_declaration_file_path
    | get packages
    | upsert $env.package_name $env.repo
  );

  open $env.package_declaration_file_path
  | upsert packages $new_package
  | save -f $env.package_declaration_file_path

  print $"(ansi green_bold)done ✨🌼, thank's to Allah(ansi reset)."


}
