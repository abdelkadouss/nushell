$env.config.plugins = {
  highlight: {
    true_colors: true,
    theme: ansi
  },
  e: {
    alias: {
      shell: ~/.config/nushell/config.nu
      env: ~/.config/nushell/env.nu
      pkg: ~/.config/pkg
      keys: ~/.config/nushell/lib/core/config/keymapping.nuon
    }
  },
  jumps: {
    backward_file: ('/tmp/nu' | path join ".nu.jumps.backward")
    forward_file: ('/tmp/nu' | path join ".nu.jumps.forward")
  }
  clean: {
    commands: [
      {|| sudo -S pkg clean }
      {||
        use jumps.nu 'jump cleanup';
        jump cleanup;

      }
      {|| brew cleanup } # :MACOS:
    ]
  }
  nupm: {
    NUPM_PACKAGE_DECLARATION_FILE_PATH: (
      $env.NU_CONFIG_DIR
      | path join "packages.toml"
    ),
    NUPM_TMP_DIR: "/var/tmp/nupm",
    NUPM_PLUGINS_DECLARATION_FILE_PATH: (
      $env.NU_CONFIG_DIR
      | path join "plugins.toml"
    ),
    NUPM_BIN_DECLARATION_FILE_PATH: (
      $env.NU_CONFIG_DIR
      | path join "plugins.toml"
    ),
    NUPM_DIST_PATH: ($env.NU_DATA_DIR | path join "nupm"),
    NUPM_HOME: ($env.NU_DATA_DIR | path join "nupm"),
  },
  self_host: {
    podman_machine: "self-host-machine",
    data_path: ($env.XDG_DATA_HOME | path join "self_host"),
    templates_path: (
      [
        $env.NU_CONFIG_DIR,
        "modules",
        "self_host",
        templates
      ] | path join
    )
  },
  git: {
    remote: {
      platforms: {
        github: "abdelkadouss"
        gitea: "abdelkadous"
        codeberg: "abdelkadous"
      }
    }
  },
  new: {
    templates_dir: ($env.HOME | path join ".templates")
  },
  nupsql: {
    databases: [
      {
        # The name that is used to query the database (nuql query **name** query)
        name: local
        # Necessary connection information (except the password) 
        host: localhost
        db: dev
        user: developer
        # Optional path to ssl certificate if needed.
        # cert: /home/user/.../cert.crt
        # Optional query alias to avoid typing often used statements
        query_alias: [
          {
            name: users
            query: "SELECT * FROM users;"
          }
        ]
        # Optional flag. If true ssl connection is required.
        ssl: false
      }
    ]
  },
  tm: {
    enabled: false
  }
} # Per-plugin configuration. See https://www.nushell.sh/contributor-book/plugins.html#configuration.

$env.config.plugin_gc = {
  # Configuration for plugin garbage collection
  default: {
    enabled: true # true to enable stopping of inactive plugins
    stop_after: 10sec # how long to wait after a plugin is inactive to stop it
  }
  plugins: {
    # alternate configuration for specific plugins, by name, for example:
    #
    # gstat: {
    #     enabled: false
    # }
  }
}

