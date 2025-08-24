# version = "0.99.1"

# config
source core/config/mod.nu;

# hide the dev commands
hide "read file";

# source ~/.config/nushell/lib/core/pre_source.nu;
source core/source.nu;
source core/alias.nu;
source core/scope.nu;
source core/hooks/after_load_config_env.nu;

# completions
source completion/mod.nu;
