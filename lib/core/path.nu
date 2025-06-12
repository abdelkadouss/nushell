let android = [
   ($env.ANDROID_SDK_ROOT | path join "cmdline-tools/latest/bin"),
   ($env.ANDROID_HOME | path join "platform-tools"),
   ($env.ANDROID_HOME | path join "emulator"),
   ($env.ANDROID_HOME | path join "build-tools/34.0.0")
];

let install = [
  ($env.HOME | path join ".nix-profile/bin"),
  '/run/current-system/sw/bin',
  ($env.HOME | path join ".local/bin"),
  '/nix/var/nix/profiles/default/bin',
  '/opt/homebrew/bin',
  (($env.HOME) | path join "bin")
];

let go = [
  ($env.HOME | path join ".go/bin")
];

let deno = [
  ($env.HOME | path join ".deno/bin")
];

let bun = [
  ($env.HOME | path join ".bun/bin")
];

let llvm = [
  '/opt/homebrew/opt/llvm/bin'
];

let console_ninja = [
  ($env.HOME | path join ".console-ninja/.bin")
];

let zen_macos = [
  "/Applications/Zen.app/Contents/MacOS"
];

let qview_macos = [
  "/Applications/qView.app/Contents/MacOS"
];

let obsidian_macos = [
  "/Applications/Obsidian.app/Contents/MacOS"
];

let cargo = [
  ($env.CARGO_HOME | path join "bin")
];

let mojo = [
  ($env.MOJO_HOME)
];

let nvim_mason = [
  ($env.HOME | path join ".local/share/nvim/mason/bin")
]

# proto
let proto = [
  ($env.PROTO_HOME | path join bin)
  ($env.PROTO_HOME | path join shims)
];

# passing to the path #######
let path_groups = [
  $android,
  $install,
  $go,
  $deno,
  $bun,
  $cargo,
  $llvm,
  $console_ninja,
  $zen_macos,
  $qview_macos,
  $obsidian_macos,
  $nvim_mason,
  $proto
];

for path in ($path_groups | flatten) {
  if ($path | path exists) {
    $env.path = ($env.path | prepend $path)
  }
};
