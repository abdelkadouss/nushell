# version = "0.99.1"

# config
source ~/.config/nushell/lib/core/config/mod.nu;

# hide the dev commands
hide "read file";

# source ~/.config/nushell/lib/core/pre_source.nu;
source ~/.config/nushell/lib/core/source.nu;
source ~/.config/nushell/lib/core/alias.nu;
source ~/.config/nushell/lib/core/scope.nu;
source ~/.config/nushell/lib/core/hooks/after_load_config_env.nu;

# completions
source-env ~/.config/nushell/lib/completion/mod.nu;

# nupm
source ~/.config/nushell/lib/modules/nupm/load.nu;
