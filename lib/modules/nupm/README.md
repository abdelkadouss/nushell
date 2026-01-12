                             بسم الله الرحمن الرحيم

# Nupm - unofficial version of the nushell package manager

## What is this?

this is a write from scratc it's not a fork of nushell-package-manager

## Demo

[![video](https://api.github.com/repos/abdelkadouss/nushell/contents/lib/modules/nupm/examples/res/global.webm?ref=main)]

[![video](https://api.github.com/repos/abdelkadouss/nushell/contents/lib/modules/nupm/examples/res/module.webm?ref=main)]

## Why? - Features

The official one still not really usable for me, plus this has a few cool features:

- 📡 It can insha'Allah install from multiple sources: git repos (rust or nushell plugins), create.io.
- 📦 Supports scripts, rust plugins, and modules.
- 📝 Save the installed plugins in a file, so you can install them again later insha'Allah via one command using just one file.
- 🕹️ Install, update and remove support.

## Setup

first make sure u running the latest version of nushell.

### Install

set the `TARGET_DIR` variable to where you want to install the package manager (this module) and `DEPENDENCIES_TARGET_DIR` variable to wher to store the dependencies of the module and this two lines in the bottom:

```nu
...
    ( <DEPENDENCIES_TARGET_DIR value u wrote above> | path expand --no-symlink ), # <- this one
    ( <TARGET_DIR value u wrote above> | path expand --no-symlink ) # <- and this one
...
```

in the following script and then run it:

```nu
const TARGET_DIR = '<set-where-to-install>/nupm'
let target_dir = ( $TARGET_DIR | path expand --no-symlink );

mkdir $target_dir;

http get https://api.github.com/repos/abdelkadouss/nushell/contents/lib/modules/nupm
| get name url
| each {|file|
  http get $file.url
  | save (
    [
      $target_dir
      $file.name
    ] | path join
  )
}

### then install the dependencies
const DEPENDENCIES_TARGET_DIR = '<set-where-to-install-dependencies>'
let target_dir = ( $DEPENDENCIES_TARGET_DIR | path expand --no-symlink );

mkdir ($target_dir)/shared;

http get 'https://api.github.com/repos/abdelkadouss/nushell/contents/lib/shared/environment.nu'
| get name url
| (
    http get $in.url
    | save (
        [
            $target_dir
            shared # it's should be in dir called shared
            $in.name
        ] | path join
    )
)

### then u have to add the dependencies to ur libs

### add the following to ur nushell config:
$env.NU_LIB_DIRS ++= [
    ( <DEPENDENCIES_TARGET_DIR value u wrote above> | path expand --no-symlink ),
    ( <TARGET_DIR value u wrote above> | path expand --no-symlink )
];
```

### Config

this is an config example:

```nu
$env.NU_CONFIG_DIR = $nu.default-config-dir;

$env.config.plugins.nupm: {
    NUPM_PACKAGE_DECLARATION_FILE_PATH: ( # the file to where to save the installed packages info so u can intall theme again insha'Allah
        $env.NU_CONFIG_DIR
        | path join "packages.toml"
    ),
    NUPM_TMP_DIR: "/var/tmp/nupm", # the tmp dir to where to download the packages..
    NUPM_PLUGINS_DECLARATION_FILE_PATH: ( # this file should be added to .gitignore, which is a file contains info about the current setup info like where the plugins paths...
        $env.NU_CONFIG_DIR
        | path join "plugins.toml"
    ),
    NUPM_DIST_PATH: ($env.NU_DATA_DIR | path join "nupm"), # the path to where to install the packages insha'Allah
    NUPM_HOME: ($env.NU_DATA_DIR | path join "nupm"), # the path to where to install the packages insha'Allah (i forget why i have two?!)
},

# it's recommended to add the nupm-dist-path/bin to NU_PLUGIN_DIRS so nu can insha'Allah search for plugin binaries when calling register insha'Allah
$env.NU_PLUGIN_DIRS ++= (
    [ $env.config.plugins.nupm.NUPM_DIST_PATH | path expand --no-symlink ]
);

```

then make sure to load this config (if u add it to ur config files not if u runn it directly in ur shell):

```nu
source $nu.env-path;
source $nu.config-path;
# or more better just make a new session (make new terminal window)
```

## Usage

1. try install a plugin:

```nu
nupm add https://github.com/abdelkadouss/nushell.git*lib/scripts/salat.nu git-script
# then take a look:
open $env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH | get packages
ls ($env.config.plugins.nupm.NUPM_DIST_PATH)/script
```

2. try useing it insha'Allah:

```nu
use nupm/script/salat.nu;
salat;
```

3. try update it:

```nu
nupm rebuild [lib/scripts/salat.nu]
# u can update all pkgs like so: nupm rebuild
```

4. try remove it (don't forget to reinstall it again):

```nu
nupm remove [lib/scripts/salat.nu]
open $env.config.plugins.nupm.NUPM_PACKAGE_DECLARATION_FILE_PATH | get packages
ls ($env.config.plugins.nupm.NUPM_DIST_PATH)/script
nupm add https://github.com/abdelkadouss/nushell.git*lib/scripts/salat.nu git-script # don't forget this one..! hahaha
```

5. try install rust base one:

```nu
# first make sure u running the latest version of nushell because the plugin can't run on any version
nupm add https://github.com/FMotalleb/nu_plugin_clipboard.git cargo-git
nupm load # to load the plugin, it's run `plugin add` command for each plugin automatically
plugin list
# then u can use it like so:
plugin use clipboard # don't worry u just have to run this command once
'some text' | clipboard copy
clipboard paste
```

## Installtion explanation

the use is:

```nu
nupm add <pkg repo> <installation type>
```

installation type refers to the method that used in the installation insha'Allah, this program currently support 4 types:

- cargo-git // via cargo from git repo (cargo install --git)
- crate // via cargo from crates.io (cargo install)
- git-module // via git clone (all the repo)
- git-script // via git clone (a specific file from a repo)

if useing the git-script or git-module, u can specify the file to install via the syntax:

```nu
nupm add <pkg repo>*<path/to/file/to/store> <installation type>
```

for example:

```nu
nupm add https://github.com/abdelkadouss/nushell.git*lib/scripts/salat.nu git-script
```

u can also rename the file after install via the syntax:

```nu
nupm add <pkg repo>*<path/to/file/to/store>*<new file name> <installation type>
```

for example:

```nu
nupm add https://github.com/abdelkadouss/nushell.git*lib/scripts/salat.nu*salat-list.nu git-script
```

this will install the file `salat.nu` from the repo `https://github.com/abdelkadouss/nushell.git` from the `lib/scripts` dir in the nushell repo and rename it to `salat-list.nu`

## How to add a new installation type

add it in `installer.nu` file, the repo is open to PRs BTW.

## License

read the [LICENSE](https://github.com/abdelkadouss/nushell/blob/main/LICENSE) file.
