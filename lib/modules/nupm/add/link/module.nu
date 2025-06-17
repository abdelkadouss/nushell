export def link_module [] {
  let package = do {
    ls .
    | where type == "dir"
    | each { |dir|
      ls ($dir | get name)
      | where name =~ "mod.nu"
      | is-not-empty
      | match $in {
        true => { $dir }
        false => { continue }
      }
    } 
  };

  let package_name = ($package | get name | first); # FIXME:

  mkdir ~/.config/nushell/plugins/modules;
  ln $package_name $"($env.home)/.config/nushell/plugins/modules";


};
