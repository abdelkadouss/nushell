export def web_search [url: string, search: string] {
  let opts = ($search | split row " ");
  let bin = $env.BROWSER;
  let args = '';
  let full_url = $url + ($opts | str join "+");

  # Pass the command and arguments as a list
  ^$bin $args $full_url;
}

export def youtube [search: string] {
  let url = "https://www.youtube.com/results?search_query=";
  web_search $url $search;
}
export def ddg [search: string] {
  let url = "https://duckduckgo.com/?q=";
  web_search $url $search;
}
