def ff [] {$in | each {|i| $i | to json --raw} | str join "\n" | fzf --preview="echo {} | from json"  | from json}

def f [$path: string = "."] {
  let newPath = (l $path | where type == dir | get name | str join "\n" | fzf --preview="lsd --tree {} --color=always --icon=always | head -200");
  cd $"./($path | path join | $newPath)";
  f;
  if ($newPath | path exists) {
    cd $newPath;
  }
  return;
}
