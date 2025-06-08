def cmds [] { ["start", "stop"] };

export def main [
  cmd: string@cmds,
  --open(-o)
] {
  if ($cmd == "start") {
    colima start; docker-compose -p penpot -f $env.penpot_path up -d;
    if $open { ^$env.BROWSER --new-tab "http://localhost:9001" };
  } else if ($cmd == "stop") {
    docker-compose -p penpot -f $env.penpot_path down; colima stop;
  } else {
    error make {
      msg: "invalid command"
      label: {
        text: "fish right here"
        span: (metadata $cmd).span
      }
    }
  }

};
