# the scripts installer module
export def link_script [] {
  print $"\n(ansi blue)wiil this package look's like a script?, so i don't sure what file i should add, but i ganna make a tye any way...(ansi reset)"

  let file = $"($env.package_name).nu";

  if (
    ls
    | where type == "file"
    | get -i $file
    | is-not-empty
  ) {
    print $"(ansi green_bold)will i think i find the correct file!. '($env.package_name)'(ansi reset)"

    let dist_path = (
      $env.config.plugins.nupm.NUPM_DIST_PATH?
      | default
      ($env.config.plugins.nupm.NUPM_HOME
        | path join "plugins"
      )
    );

    let dist_script_path = (
      $dist_path
      | path join "scripts"
    );
    mkdir $dist_script_path | ignore;

    try {
      ln $file $dist_script_path;
      print $"(ansi green_bold)done thank's to Allah(ansi reset)";

    } catch {
      print -e $"(ansi red) ERROR some thing wont wrong!.(ansi reset)"

    };

  } else {
    print $"(ansi red_bold)failed(ansi reset). u have to add the file symlinks manually.\n (ansi green) help:\n$ cd \($env.config.plugins.nupm.NUPM_DATA_PATH? | default \($env.XDG_DATA_HOME | path join 'nupm/packages'))\n$ cd ($env.package_name)\n$ ls"

  };

}
