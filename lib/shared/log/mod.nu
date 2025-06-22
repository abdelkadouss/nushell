def "log body" [
  stderr: bool,
  message: string,
  help?: string,
] {
  let cmd = if $stderr { {|...args| print -e ...$args } } else { {|...args| print ...$args } };
  do $cmd $message;
  if $help != null {
    do $cmd $"(ansi green_bold)help:(ansi reset) ($help)";
  }
};

export def "log error" [
  message: string,
  help?: string,
] {
  print -e $"(ansi red_bold)ERROR:(ansi reset)";
  log body true $message (if $help != null { $help });

};

export def "log warning" [
  message: string,
  help?: string,
] {
  print -e $"(ansi yellow_bold)WARNING:(ansi reset)";
  log body true $message (if $help != null { $help });

};

export def "log info" [
  message: string,
  help?: string,
] {
  print -e $"(ansi blue_bold)INFO:(ansi reset)";
  log body true $message (if $help != null { $help });

};
