def paths [] { [ls . | get name] };
export def main [path: string@paths = "."] {
  if ( ($path == ".") and (( pwd | path parse | get stem ) | ( $in == $env.HOME ) or ($in == (whoami)) ) ) {
    print $"u don't wanna to do that trust me!";
  };
};
