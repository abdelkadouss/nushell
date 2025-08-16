# Nushell Environment Config File
#
# version = "0.99.1"

# config dir
$env.XDG_CONFIG_HOME = ($env.HOME | path join ".config");
# data dir
$env.XDG_DATA_HOME = ($env.HOME | path join ".local/share");
# cache dir
$env.XDG_CACHE_HOME = ($env.HOME | path join ".cache");
# nu
$env.NU_CONFIG_DIR = ($env.XDG_CONFIG_HOME | path join "nushell");
$env.NU_DATA_DIR = ($env.XDG_DATA_HOME | path join "nushell");

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
  ( $env.NU_CONFIG_DIR | path join 'lib/scripts' ) # add <nushell-config-dir>/scripts
  ( $env.NU_CONFIG_DIR | path join 'lib/modules' ) # add <nushell-config-dir>/scripts
  ( $env.XDG_DATA_HOME | path join 'completions' ) # default home for nushell completions
  # nu data dir
  $env.NU_DATA_DIR
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($env.NU_CONFIG_DIR | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
#path add ($env.HOME | path join ".nix-profile/bin")
$env.CARGO_HOME = $"($env.XDG_DATA_HOME)/cargo";
#path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# nu
$env.EDITOR = 'nvim';
$env.config.filesize.unit = 'metric'

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

# carapace
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional

# fzf

# --- setup fzf theme ---

$env.FZF_DEFAULT_OPTS = $"--border=rounded --color=fg:#cdd6f4,hl:#94e2d5,fg+:#cdd6f4,bg+:#313244,hl+:#94e2d5,info:#f5c2e7,prompt:#f5e0dc,pointer:#f5e0dc,marker:#f5e0dc,spinner:#f5e0dc,header:#f5e0dc --preview 'bat --color=always {}'";

# bat
$env.BAT_THEME = "Catppuccin Mocha";

# android sdk

 $env.ANDROID_SDK_ROOT = $"($env.HOME)/.android/sdk";
 $env.ANDROID_HOME = $"($env.HOME)/.android/sdk";
 $env.NDK_HOME = $"($env.HOME)/.android/sdk/ndk/27.2.12479018"

 $env.ANDROID_AVD_HOME = $"($env.HOME)/.android/avd"

# yazi
 $env.EDITOR = 'nvim'


# bun
$env.BUN_INSTALL = ( $env.XDG_DATA_HOME | path join "bun" );
$env.BUN_HOME = $env.BUN_INSTALL;

# mac clis
$env.xcodebuild = "/nix/store/amdympl4rz7kj93j82cva60v8007n4nv-apple-sdk-11.3";
$env.DEVELOPER_DIR = "/nix/store/amdympl4rz7kj93j82cva60v8007n4nv-apple-sdk-11.3"
$env.PATH = ($env.path | prepend ($env.xcodebuild | path join "usr"));
$env.PATH = ($env.path | prepend ($env.xcodebuild | path join "SDKs"));
$env.PATH = ($env.path | prepend ($env.xcodebuild | path join "Library"));

# mac stuff
# $env.MACOSX_DEPLOYMENT_TARGET = "11.0";

# llvm
$env.CC = "gcc";
$env.CXX = "g++";
$env.LD = "ld64.lld";
# $env.LDFLAGS = "-L/opt/homebrew/opt/llvm/lib/unwind -lunwind";
# $env.LDFLAGS = "-L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib/unwind -lunwind";
# $env.PATH = ("/opt/homebrew/opt/llvm/bin" ++ $env.path);
# $env.LDFLAGS = "-L/opt/homebrew/opt/llvm/lib";
# $env.CPPFLAGS = "-I/opt/homebrew/opt/llvm/include";

# rust 
# $env.CARGO_TARGET_DIR = ($env.HOME | path join "bin");

# liker
# $env.LD = "ld";
# $env.CC = "gcc";
# $env.CXX = "g++";
$env.CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER = "gcc";

# libiconv
$env.LIBRARY_PATH = $"/nix/store/dvmq3xa54hfik85259wyf281m076s14h-libiconv-107/lib:/usr/local/lib:($env.LIBRARY_PATH?)";
$env.CPATH = $"/nix/store/dvmq3xa54hfik85259wyf281m076s14h-libiconv-107/include:/usr/local/include:($env.CPATH?)";
$env.LD_LIBRARY_PATH = "/nix/store/dvmq3xa54hfik85259wyf281m076s14h-libiconv-107/lib:$LD_LIBRARY_PATH";
$env.LDFLAGS = "-L/nix/store/dvmq3xa54hfik85259wyf281m076s14h-libiconv-107/lib";
$env.CFLAGS = "-I/nix/store/dvmq3xa54hfik85259wyf281m076s14h-libiconv-107/include";
$env.DYLD_LIBRARY_PATH = $"($env.LIBRARY_PATH?):($env.DYLD_LIBRARY_PATH?)";
# libarchive
$env.CPATH = $"/opt/homebrew/opt/libarchive/bin:($env.CPATH?)";

# adhan
$env.ADHAN = $"($env.HOME)/.dotfiles/scripts/salat/resources/ressources_audio_Adhan - Ahmed Al-Nufais.mp3"

# pueue
$env.PUEUE_CONFIG_PATH = $"($env.HOME)/.config/pueue/config.yaml"

# scripts bin

# mojo
$env.MOJO_HOME = $"($env.HOME)/.modular/bin";

# browser
$env.BROWSER = 'zen';

# git
$env.GIT_CONFIG_GLOBAL = ($env.XDG_CONFIG_HOME | path join "git/config");
$env.GIT_TEMPLATE_DIR = ($env.XDG_CONFIG_HOME | path join "git");

# syncthing
$env.STCONFDIR = ($env.HOME | path join ".config/syncthing");
$env.STDATADIR = ($env.HOME | path join ".local/share/syncthing");

# proto
$env.PROTO_HOME = (
  [
    $env.XDG_DATA_HOME,
    "proto"
  ] | path join
);

$env.PROTO_CONFIG_MODE = 'global';

# pkg
$env.pkg = {
  source_dir: (
    [
      $env.XDG_CONFIG_HOME,
      "pkg",
    ] | path join
  ),
};

$env.pkg = {
  ...$env.pkg,

  bridges_set: (
    [
      $env.pkg.source_dir,
      ".bridges"
    ] | path join
  )

  target_dir: "/opt/pkg",

  db_path: "/var/db/pkg/packages.db",

  load_path: "/run/pkg"

};

# PATH ===#
source ~/.config/nushell/lib/core/path.nu;
#===#

#>note: source after path to get the bin in the scope in chaa'Allah

# hooks
nu ~/.config/nushell/lib/core/hooks/pre_source.nu;
nu ~/.config/nushell/lib/core/config/theme/installer.nu;
