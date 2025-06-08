use lib/nupm/update.nu;
use lib/nupm/add.nu;
use lib/nupm/remove.nu;
use lib/nupm/list.nu;
use lib/nupm/help.nu;

export def main [
  cmd: string,
  --remote_provider(-p): string = "github",
  ...args: string
] {
  let cmds = [
    "update",
    "add",
    "remove",
    "list",
  ];

  match $cmd {
    "update" => { update }
    "add" => { add $args.0 -p $remote_provider }
    "remove" => { remove }
    "list" => { list }
    "install" => { add $args.0 }
    "help" => { help }
    _ => { error make {
      msg: $"Unknown command '($cmd)'."
      label: {
        text: "this command is not valid"
        span: (metadata $cmd).span
      }
      help: "Try 'help' for a list of available commands."
    }
    }
  }
}
