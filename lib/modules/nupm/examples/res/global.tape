Output examples/res/global.gif

Set Shell "nu"
Set FontSize 32

Type "# In the name of Allah"
Sleep 500ms
Enter

Type "cd $nu.default-config-dir" Enter

Type "# This is my nushell config"
Sleep 500ms
Enter
Type "ls -a"  Enter
Sleep 2s

Type "# Let's insatll some thing using nupm"  Enter
Sleep 500ms
Type "nupm add https://github.com/abdelkadouss/nushell.git*lib/scripts/salat.nu git-script"  Enter
Sleep 3s

Type "# Try it now..." Enter
Type "use nupm/script/salat.nu"  Enter
Sleep 500ms
Type "salat"  Enter
Sleep 2s
Type "# It's working, thanks to Allah"  Enter

Type "# nupm gonna store the packages in a packages.toml file"  Enter
Sleep 500ms
Type "ls packages.toml"  Enter
Sleep 500ms
Type "open packages.toml | get packages"  Enter
Type "# look it's there thanks to Allah"  Enter
Sleep 3s
Type "# That's mean u can install them later via one command insha'Allah nupm rebuild"
Sleep 500ms
Enter

Type "# Now let's try remove it insha'Allah"
Enter
Type "nupm remove lib/scripts/salat.nu # lib/scripts/salat.nu is the plugin name becuase it's a file inside a repo" Enter
Sleep 3s
Type "# Try useing it now"  Enter
Type "use nupm/script/salat.nu"  Enter
Sleep 1s
Type "# Take a look now" Enter
Type "open packages.toml | get packages"  Enter
Sleep 2s
Type "# It's gone, thanks to Allah"  Enter
Sleep 2s
