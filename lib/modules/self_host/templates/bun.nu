const tmp_dir = "/tmp/self_host";

def "<#> start" [] {
  job spawn { bun run --bun dev };

  sleep 2sec;
  let $pid = (
    job list
    | first
    | get pids
    | first
  );

  mkdir $tmp_dir;
  $pid | into string | save -f ( $tmp_dir | path join | "<#>.pid" );
};

def --env "<#> stop" [] {
  let pid = (
    open ( $tmp_dir | path join | "<#>.pid" )
    | into int
  );

  pkill -TERM -P $pid;
  pkill -KILL -P $pid;

  rm -rf ( $tmp_dir | path join | "<#>.pid" );
};

export def main [cmd: string] {
  if $cmd == "start" {
    export-env { <#> start };
  } else if $cmd == "stop" {
    <#> stop;
  } else {
    print -e "Usage: <#> [start|stop]";
  }
};
