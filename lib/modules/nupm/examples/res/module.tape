Output examples/res/module.webm

Set Shell "nu"
Set FontSize 28

Type "# In the name of Allah"
Sleep 500ms
Enter

Type "cd ./examples/res" Enter

Type "# Let's make new nu module"  Enter
Sleep 1s
Type "mkdir my-module"  Enter
Sleep 500ms
Type "cd my-module; ls -a"  Enter
Sleep 500ms
Type "nupm new"  Enter
Sleep 500ms
Type "ls -a"  Enter
Sleep 500ms
Type "open nupm.nuon"  Enter
Sleep 2s

Type "# Let's add some deps insah'Allah" Enter
Type "nupm add https://github.com/vyadh/nutest.git*nutest git-module" Enter
Sleep 7s
Type "open nupm.nuon | get packages"  Enter
Sleep 1s
Type "use target/deps/module/nutest" Enter
Sleep 1s
Type "cp -rf ../test_example.nu ." Enter
Sleep 1s
Type "nutest list-tests --path test_example.nu" Enter
Sleep 1s
Type "# u can install a script, module and rust based plugin from either a git repo or crates.io (i mean the rust base plugins)" Enter
Sleep 1.5s

Type "# To install the deps in the next time insha'Allah run:"
Type "nupm rebuild --if-not-exists" Enter
Sleep 1s
Type "ls -a target/deps" Enter
Sleep 1s
Type "rm -rfp target/deps" Enter
Sleep 1s
Type "nupm rebuild --if-not-exists" Enter
Sleep 7s
Type "ls -a target/deps" Enter
Sleep 1s
