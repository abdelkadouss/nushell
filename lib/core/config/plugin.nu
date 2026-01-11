# vim:fileencoding=utf-8:foldmethod=marker

$env.config.plugins = {
# : Highlight {{{
  highlight: {
    true_colors: true,
    theme: ansi
  },
# : }}}
# : E {{{
  e: {
    alias: {
      shell: ~/.config/nushell/config.nu
      env: ~/.config/nushell/env.nu
      pkg: ~/.config/pkg
      keys: ~/.config/nushell/lib/core/config/keymapping.nuon
    }
  },
# : }}}
# : Jumps {{{
  jumps: {
    backward_file: ('/tmp/nu' | path join ".nu.jumps.backward")
    forward_file: ('/tmp/nu' | path join ".nu.jumps.forward")
  }
# : }}}
# : Clean {{{
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
# : }}}
# : Theme {{{
  theme: {
    name: 'rose pine'
    run_install_hooks: true
    # : Install Hooks {{{
    install_hooks: [
      { # bat
        from: 'https://github.com/badloop/bat-rose-pine/raw/refs/heads/main/Rose-Pine.tmTheme'
        to: '~/.config/bat/themes/Rose-Pine.tmTheme'
        mkdir: true
        overwrite: true
      }
      {
        from: 'https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme'
        to: '~/.config/bat/themes/Catppuccin-Mocha.tmTheme'
        mkdir: true
        overwrite: true
      }
      { # yazi
        run: {|| ya pkg add yazi-rs/flavors:catppuccin-mocha }
      }
      {
        run: {|| ya pkg add Mintass/rose-pine }
      }
      {
        run: {|| ya pkg add BennyOe/tokyo-night }
      }
      { # zellij
        from: 'https://github.com/vague-theme/vague-zellij/raw/refs/heads/main/vague.kdl'
        to: '~/.config/zellij/themes/vague.kdl'
        mkdir: true
        overwrite: true
      }
      {
        from: 'https://github.com/rose-pine/zellij/raw/refs/heads/main/dist/rose-pine.kdl'
        to: '~/.config/zellij/themes/rose-pine.kdl'
        mkdir: true
        overwrite: true
      }
      { # lazygit
        from: 'https://github.com/rose-pine/lazygit/raw/refs/heads/main/themes/rose-pine.yml'
        to: '~/.config/lazygit/themes/rose-pine.yml'
        mkdir: true
        overwrite: true
      }
      {
        from: 'https://github.com/vague-theme/vague-lazygit/raw/refs/heads/main/vague.yml'
        to: '~/.config/lazygit/themes/vague.yml'
        mkdir: true
        overwrite: true
      }
    ]
    # : }}}
    # : Definitions {{{
    definitions: [
      {
        desc: 'change the ls-colors via the vivid cli'
        case: 'kebab'
        cmd: {|theme_name|
          vivid generate $theme_name | save -f ~/.config/nushell/lib/assets/ls-colors
        }
      }

      {
        desc: 'generate the theme change hook for nushell under the gen dir'
        case: 'snake'
        cmd: {|theme_name|
          # NOTE: use the theme install module instead, u can fine it under config/theme/
          # http get https://raw.githubusercontent.com/nushell/nu_scripts/refs/heads/main/themes/nu-themes/($theme_name | str kebab-case).nu
          # | save -f ~/.local/share/nushell/themes/($theme_name).nu

          $'use themes/($theme_name).nu;(char nl)($theme_name) set color_config;
          '
          | save -f ~/.local/share/nushell/gen/theme_change_hook.nu

          return { type: 'add-to-file', file: '~/.config/nushell/lib/core/config/theme/mod.nu' code: 'source gen/theme_change_hook.nu' }
        }
      }

      {
        desc: 'change the lazygit theme'
        case: 'kebab'
        cmd: {|theme_name|
          let lazygit_config_file = $'($env.home)/.config/lazygit/config.yml';
          mv $'($lazygit_config_file | path dirname)/themes/($theme_name).yml' $lazygit_config_file
        }
      }

      {
        desc: 'generate the theme change hook for ghostty under the gen dir'
        case: 'kebab'
        cmd: {|theme_name|
          let dest_file = '~/.local/share/nushell/gen/theme_change_hook_for_ghostty';
          $'theme = ( $theme_name )'
          | save -f $dest_file

          return { type: 'add-to-file', file: 'ghostty config' code: $'config-file = ( $dest_file )' }
        }

      }

      {
        desc: 'change starship theme'
        case: 'kebab'
        cmd: {|theme_name|
          let starship_config_file = $'($env.home)/.config/starship.toml';

          mut starship_config = ( open $starship_config_file );

          $starship_config.palette = $theme_name;
          $starship_config | to toml | save -f $starship_config_file

          use std/log warning;
          warning $'make sure ($theme_name) pallete included in the starship config file at ( $starship_config_file )' | print;
        }
      }
      {
        desc: 'change the theme for nvim'
        case: 'kebab'
        palette: false
        cmd: {|theme_name|
          let nvim_theme_config_file = $'($env.home)/.config/nvim/lua/plugins/editor/colorscheme.lua';

          $"local colorscheme = '($theme_name)'(char nl)(char nl)return {(char nl) require\('plugins.editor.themes.' .. colorscheme\),(char nl)}"
          | save -f $nvim_theme_config_file;
        }
      }
      {
        desc: 'change obsidian vaults themes'
        case: 'title'
        palette: false
        cmd: {|theme_name|
          mut obsidian_vault_appearance = ( open ~/code/notebooks/.obsidian/appearance.json )

          $obsidian_vault_appearance.cssTheme = $theme_name

          $obsidian_vault_appearance | to json | save -f ~/code/notebooks/.obsidian/appearance.json

        }
      }

      {
        desc: 'change the yazi theme'
        case: 'kebab'
        cmd: {|theme_name|
          let yazi_theme_config_file = $'($env.home)/.config/yazi/theme.toml';
          mut yazi_theme_config = ( open $yazi_theme_config_file );

          $yazi_theme_config.flavor.use = $theme_name;
          $yazi_theme_config.flavor.dark = $theme_name;

          $yazi_theme_config | to toml | save -f $yazi_theme_config_file;

        }
      }

    ]
    # : }}}

  }
# : }}}
# : Nupm {{{
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
    NUPM_DIST_PATH: ($env.NU_DATA_DIR | path join "nupm"),
    NUPM_HOME: ($env.NU_DATA_DIR | path join "nupm"),
  },
# : }}}
# : Self Host {{{
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
# : }}}
# : Git {{{
  git: {
    remote: {
      platforms: {
        github: "abdelkadouss"
        gitea: "abdelkadous"
        codeberg: "abdelkadous"
      }
    }
  },
# : }}}
# : New {{{
  new: {
    templates_dir: ($env.HOME | path join ".templates")
  },
# : }}}
# : Nupsql {{{
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
# : }}}
# : Tm {{{
  tm: {
    enabled: false
  }
# : }}}
} # Per-plugin configuration. See https://www.nushell.sh/contributor-book/plugins.html#configuration.

# : Plugin Garbage Collection {{{
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
# : }}}
