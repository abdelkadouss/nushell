# For more information on defining custom themes, see
# https://www.nushell.sh/book/coloring_and_theming.html
# And here is the theme collection
# https://github.com/nushell/nu_scripts/tree/main/themes

# to hide the theme commands from the global scope
overlay new theme;
overlay use theme;

source installer.nu;

use update_terminal.nu "update terminal";
use themes/catppuccin_mocha.nu;

# set the theme
catppuccin_mocha set color_config;

# override the default theme
$env.config.color_config.background = "#000000";

# update the terminal theme based on the env var
update terminal;

# ls colors
$env.LS_COLORS = (
  ( read file --raw lib/assets/ls-colors )
  | str trim
)

overlay hide theme;
