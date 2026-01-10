let xdg = {
  XDG_CONFIG_HOME: ($env.HOME | path join ".config")
  XDG_DATA_HOME: ($env.HOME | path join ".local/share")
  XDG_CACHE_HOME: ($env.HOME | path join ".cache")
};

$xdg | load-env

let nu_vars = {
  NU_CONFIG_DIR: ($env.XDG_CONFIG_HOME | path join "nushell")
  NU_DATA_DIR: ($env.XDG_DATA_HOME | path join "nushell")
}

$nu_vars | load-env

let nushell = {
  NU_LIB_DIRS: [
    ( $env.NU_CONFIG_DIR | path join 'lib' )
    ( $env.NU_CONFIG_DIR | path join 'lib/scripts' )
    ( $env.NU_CONFIG_DIR | path join 'lib/modules' )
    ( $env.XDG_DATA_HOME | path join 'completions' )
    $env.NU_DATA_DIR
  ]
  # Directories to search for plugin binaries when calling register
  NU_PLUGIN_DIRS: [
    ( $env.XDG_DATA_HOME | path join 'nupm/bin' )
  ]
}

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

let tools = {
  EDITOR: 'nvim'
  BROWSER: 'qutebrowser'
  PAGER: 'bat'
}

let carapace = {
  CARAPACE_BRIDGES: 'zsh,fish,bash,inshellisense' # optional
}

let fzf = {
  FZF_DEFAULT_OPTS: $"--border=rounded --color=fg:#cdd6f4,hl:#94e2d5,fg+:#cdd6f4,bg+:#313244,hl+:#94e2d5,info:#f5c2e7,prompt:#f5e0dc,pointer:#f5e0dc,marker:#f5e0dc,spinner:#f5e0dc,header:#f5e0dc --preview 'bat --color=always {}'"
}

let bat = {
  BAT_THEME: "Rose-Pine"
}


let bun = {
  BUN_INSTALL: ( $env.XDG_DATA_HOME | path join "bun" )
  BUN_HOME: ( $env.XDG_DATA_HOME | path join "bun" )
}

let go = {
  GOPATH: ( $env.XDG_DATA_HOME | path join "go" )
  GOBIN: ( $env.XDG_DATA_HOME | path join "go/bin" )
}

let gradle = {
  GRADLE_USER_HOME: ( $env.XDG_DATA_HOME | path join "gradle" )
}

let dart = {
  DART_HOME: ( $env.XDG_DATA_HOME | path join "dart" )
  PUB_CACHE: ( $env.XDG_CACHE_HOME | path join "dart/pub" )
  ANALYZER_STATE_LOCATION_OVERRIDE: ( $env.XDG_CACHE_HOME | path join "dart/server" )
  DART_SDK_PATH: ( $env.XDG_DATA_HOME | path join "dart/sdk" )
  DART_SDK: ( $env.XDG_DATA_HOME | path join "dart/sdk" )
}

let flutter = {
  FLUTTER_HOME: ( $env.XDG_DATA_HOME | path join "flutter" )
  FLUTTER_STORAGE_BASE: ( $env.XDG_DATA_HOME | path join "flutter" )
  FVM_CACHE_PATH: ( $env.XDG_CACHE_HOME | path join "fvm" )
}

let rust = {
  CARGO_HOME: ( $env.XDG_DATA_HOME | path join "cargo" )
  # RUSTUP_HOME: ( $env.XDG_DATA_HOME | path join "rustup" )
  CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER: "gcc"
}

let less = {
  LESSHISTFILE: (
    [
      $env.HOME,
      '.local'
      'state'
      'lesshst'
    ]
  )
}

let zsh = {
  ZSH_COMPDUMP: ( $env.XDG_CACHE_HOME | path join "zsh/zcompdump" )
}

let c = {
  CC: "/opt/homebrew/opt/llvm/bin/clang"
  CXX: "/opt/homebrew/opt/llvm/bin/clang++"
  LD: "lld-link"
  CPATH: $"/opt/homebrew/opt/libarchive/bin:($env.CPATH?)"
  CPPFLAGS: "-I/opt/homebrew/opt/llvm/include"
  DYLD_LIBRARY_PATH: $"($env.LIBRARY_PATH?):($env.DYLD_LIBRARY_PATH?)"
  LDFLAGS: "-L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib/unwind -lunwind"
}

let git = {
  GIT_CONFIG_GLOBAL: ($env.XDG_CONFIG_HOME | path join "git/config")
  GIT_TEMPLATE_DIR: ($env.XDG_CONFIG_HOME | path join "git")
}

let gh = {
  GH_PAGER: "diffnav"
}

let syncthing = {
  STCONFDIR: ($env.HOME | path join ".config/syncthing")
  STDATADIR: ($env.HOME | path join ".local/share/syncthing")
}

let lua = {
  LUA_PATH: (
    [
      (
        $env.XDG_DATA_HOME
        | path join "lua/lua_modules/share/lua/5.4/?.lua;"
      )
      (
        $env.XDG_DATA_HOME
        | path join "lua/lua_modules/share/lua/5.4/?/init.lua;;"
      )
    ]
    | str join 
  )
  LUA_CPATH: (
    $env.XDG_DATA_HOME
    | path join "lua/lua_modules/lib/lua/5.4/?.so;;"
  )
}

let proto = {
  PROTO_HOME: (
    [
      $env.XDG_DATA_HOME,
      "proto"
    ] | path join
  )
  PROTO_CONFIG_MODE: 'global'
}

let asdf = {
  ASDF_TOOL_VERSIONS_FILENAME: ".tool-versions"
  ASDF_DATA_DIR: ($env.XDG_DATA_HOME | path join "asdf")
  ASDF_CONFIG_FILE: (
    $env.XDG_CONFIG_HOME
    | path join "asdf"
    | path join "asdfrc"
  )
}

let topiary = {
  TOPIARY_CONFIG_FILE: ($env.XDG_CONFIG_HOME | path join topiary languages.ncl)
  TOPIARY_LANGUAGE_DIR: ($env.XDG_CONFIG_HOME | path join topiary languages)
}

let pkgx = {
  PKGX_DIR: ($env.XDG_DATA_HOME | path join pkgx)
}

let env_groups = [
  $nushell
  $tools
  $fzf
  $carapace
  $bat
  $git
  $gh
  $bun
  $go
  $gradle
  $dart
  $flutter
  $rust
  $less
  $zsh
  $c
  $syncthing
  $lua
  $proto
  $asdf
  $topiary

];

for e in $env_groups {
  $e | load-env;

}

hide env_groups

# PATH ===#
source ~/.config/nushell/lib/core/path.nu;
#===#

#>note: source after path to get the bin in the scope in chaa'Allah

# hooks
nu ~/.config/nushell/lib/core/hooks/pre_source.nu;
nu ~/.config/nushell/lib/core/config/theme/installer.nu;
