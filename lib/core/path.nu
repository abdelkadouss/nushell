# for isolation
overlay new path;
overlay use path;

let install = [
  ($env.HOME | path join ".nix-profile/bin"),
  '/run/current-system/sw/bin',
  ($env.HOME | path join ".local/bin"),
  '/nix/var/nix/profiles/default/bin',
  '/opt/homebrew/bin',
  (($env.HOME) | path join "bin")
  "/usr/local/bin"
];

let go = [
  $env.GOBIN
];

let deno = [
  ($env.HOME | path join ".deno/bin")
];

let bun = [
  ($env.BUN_INSTALL | path join "bin")
];

let llvm = [
  '/opt/homebrew/opt/llvm/bin'
];

let console_ninja = [
  ($env.HOME | path join ".console-ninja/.bin")
];

let cargo = [
  ($env.CARGO_HOME | path join "bin")
];

let nvim_mason = [
  ($env.HOME | path join ".local/share/nvim/mason/bin")
]

# proto
let proto = [
  ($env.PROTO_HOME | path join bin)
  # ($env.PROTO_HOME | path join shims) # this thing is slow down the tools and i don't useing proto as a tool manager in my project do i just useing it for global installion so i don't need this insha'Allah
];

let gui = [
  /usr/local/gui
]

let pkgs = [
  "/usr/local/pkg"
];

let brew = [
  "/opt/homebrew/opt/libarchive/bin"
];

let flutter = [
  ($env.XDG_DATA_HOME | path join "flutter/bin")
];

# passing to the path #######
let path_groups = [
  $install,
  $go,
  $deno,
  $bun,
  $cargo,
  $llvm,
  $console_ninja,
  $nvim_mason,
  $brew,
  $flutter,
  $proto,
  $gui
  $pkgs
];

for path in ($path_groups | flatten) {
  if ($path | path exists) {
    $env.path = ($env.path | prepend $path);
  }
}

overlay hide path --keep-env [ PATH ];
