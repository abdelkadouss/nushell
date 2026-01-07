use ../shared/external *;

# env

## android sdk

$env.ANDROID_HOME = (
  external run mise where android-sdk --stdout-message true --default-output ""
);
$env.ANDROID_SDK_ROOT = ( $env.ANDROID_HOME  | path dirname );
$env.NDK_HOME = ( $env.ANDROID_HOME | path join "ndk" );
$env.ANDROID_AVD_HOME = ( $env.XDG_CONFIG_HOME | path join ".android/avd" );



## config

# path
overlay new path;
overlay use path;
use shared/fs *;

let nupm = [
  ($env.config.plugins.nupm.NUPM_HOME | path join "bin")
]

let android_versions = "36.0.0"
let android = [
  # NOTE: handled by mise
  # ($env.ANDROID_SDK_ROOT | path join "cmdline-tools/latest/bin"),
  # ($env.ANDROID_HOME | path join "platform-tools"),
  (
    fs exist
    ($env.ANDROID_HOME | path join "emulator")
    --action-type "stdout-message"
    --gen-cmd {|_: string|
      use shared/external *;
      use std/log;
      log info "make sure to run mise install before the android emulator install command"
      job spawn {
        external run sdkmanager "emulator"
      }
    }
    --return-path true
    | default "" 
  ),
  (
    fs exist
    ($env.ANDROID_HOME | path join $"build-tools/( $android_versions )")
    --action-type "stdout-message"
    --gen-cmd {|_: string|
      use shared/external *;
      use std/log;
      log info "make sure to run mise install before the android build-tools install command"
      job spawn {
        external run sdkmanager "build-tools;36.0.0"
      }
    }
    --return-path true
    | default ""
  )
];


let path_groups = [
  $android,
  $nupm
];

for path in ($path_groups | flatten) {
  if ($path | path exists) {
    $env.path = ($env.path | prepend $path);
  }
};


# drop unneeded imports from the global scope
overlay hide path --keep-env [ PATH ];


# tm
# launch the terminal multiplexer at terminal startup insha'Allah
use tm.nu;
tm;
hide "tm";

# jumps
use jumps.nu 'jump hooks';
jump hooks cleanup; # cleanup the jumps files
jump hooks init; # cleanup the jumps files
hide 'jump hooks';
