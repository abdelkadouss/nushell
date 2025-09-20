# zoxide
alias cd = z;
alias cdi = zi;

# ls
alias l = ls -a;

# yazi
alias y = yazi;

# lazygit
alias lz = lazygit;

# zellij
alias m = zellij;

# run commands
alias "run emu" = emulator -avd android_35 -no-metrics;

# nufmt
alias "nufmt" = ~/.local/share/nushell/nupm/script/nufmt.nu -c ( $env.TOPIARY_CONFIG_FILE | path dirname );
