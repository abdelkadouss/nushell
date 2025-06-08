# quick edit
export def main [
  name: string='',
  files: string=''
  --new(-n)
] {
  if ($name == "") {
    ^$"($env.EDITOR)";
    return;
  };
  mut paths = {
    "nu": $"($env.HOME)/.config/nushell/config.nu"
    "shell": $"($env.HOME)/.config/nushell/config.nu"
    "env": $"($env.HOME)/.config/nushell/env.nu"
  };
  for file in ["nu", "shell", "env"] {
    if ($name == $file) {
      ^$"($env.EDITOR)" ( $paths | get $file );
      return;
    };
  };
  for file in ["~/.nix", "~/.config/nvim", "~/.config/wezterm"] {
    if ($file | str contains $name) {
      cd ($file);
      ^$"($env.EDITOR)";
      cd -;
      return;
    }
  }

  # fzf search
  if ($name == 'fzf') {
    ^$"($env.EDITOR)" (fzf --query $files);
    return;
  } else if ($name == 'cdi') {
    (cdi);
    ^$"($env.EDITOR)";
    return;
  }

  if ((zoxide query $name | path exists)) {
    cd $name;
    ^$"($env.EDITOR)";
    cd -;
    return;
  } else if (
    ($name | path exists)
    and 
    (( $name | path type) == file )
    or (($name | path type) == symlink)) {
    ^$"($env.EDITOR)" ($name | str replace "~" ($env.HOME));
    return;
  } else if ($name | path type) == dir {
    cd ($name | str replace "~" ($env.HOME));
    ^$"($env.EDITOR)";
    return;
  };

  if $new {
    mkdir ($name | path dirname);
    ^$env.EDITOR $name;
  }

  print "🪹";
  return;
}
