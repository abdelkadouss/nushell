export def main [ spans ] {
  $spans
  | skip 1
  | zoxide query -l ...$in
  | lines
  | where {|x|
    $x != $env.PWD

  }

}

