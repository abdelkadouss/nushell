export def main [ spans ] {
  fish --command $"complete '--do-complete=($spans | str join ' ')'"
  | from tsv --flexible --noheaders --no-infer
  | rename value description
  | update value {
    if ($in | path exists) {$'"($in | str replace "\"" "\\\"" )"'} else {$in}
  }
}

