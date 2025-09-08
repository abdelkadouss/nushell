# print a nu code in a pretty way
export def main [ code: string ] {
  mut msg = "";
  $msg += $"(ansi pb)```nu(char nl)(ansi reset)";
  $msg += ( ( $code | nu-highlight ) + (char nl) );
  $msg += $"(ansi pb)```(ansi reset)";
  return $msg;
}
