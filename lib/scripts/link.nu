export def --env main [bin: string] {
  let new_path = ( which $bin | get path | first | readlink $in | path dirname );

  $env.path = ( $env.path | prepend $new_path );

  print $"(ansi b)+ (ansi gb)($new_path)(ansi reset)."

}
