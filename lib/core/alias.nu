# excalidraw
alias excalidraw = do { cd $env.excalidraw_path; bun start; cd -; };

# zoxide
alias cd = z;
alias cdi = zi;

# nix
alias rebuild = sudo darwin-rebuild switch --flake ~/.nix#darwin;

# dir bookmarks
alias cdir = cd ~/Coding/;
alias tdir = cd ~/Coding/test/;

# ls
alias l = ls -a;

# yazi
alias y = yazi;

# lazygit
alias lz = lazygit

# zellij
alias m = zellij

# qView
# alias qv = /Applications/qView.app/Contents/MacOS/qView
