# md
def init_md [name: string] {
  echo '<div align="center"> بسم الله الرحمن الرحيم </div> ' | save $"($name).md"
}

# fzf
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

# web
def web_search [url: string, search: string] {
  let opts = ($search | split row " ");
  let bin = $env.BROWSER;
  let args = '';
  let full_url = $url + ($opts | str join "+");

  # Pass the command and arguments as a list
  ^$bin $args $full_url;
}

def youtube [search: string] {
  let url = "https://www.youtube.com/results?search_query=";
  web_search $url $search;
}
def ddg [search: string] {
  let url = "https://duckduckgo.com/?q=";
  web_search $url $search;
}
