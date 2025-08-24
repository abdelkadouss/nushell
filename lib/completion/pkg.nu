def commands [] { [] };


# a portbale, multi repo, cross platform, rust base, scriptable package manager 
# Install packages
@example "install/remove packages based on configuration" {
  pkg sync;
}
extern pkg [
  cmd: string@commands,
  --help(-h),                                 # Prints help information
  --version(-v),                              # Prints version information
]

# Sync packages with configuration (install/remove as configured)
extern "pkg build" [
  --help(-h),                                 # Prints help information
  --update(-u),                               # even update the installed packages via the update command
]

# Sync packages with configuration (install/remove as configured)
extern "pkg sync" [
  --help(-h),                                 # Prints help information
  --update(-u),                               # even update the installed packages via the update command
]

# Force sync all packages (reinstall everything)
extern "pkg rebuild" [
  --help(-h),                                 # Prints help information
]

# Update packages
@example "update a package" {
  pkg update nu;
}
extern "pkg update" [
  --help(-h),                                 # Prints help information
  pkgs?: string # list of packages to update (default: all)
]

# List installed packages
extern "pkg info" [
  --help(-h),                                 # Prints help information
  pkgs?: string # list of packages to show info about (default: all)
]

# Link packages in PATH 
extern "pkg link" [
  --help(-h),                                 # Prints help information
]

# Clean cache and temporary files
extern "pkg clean" [
  --help(-h),                                 # Prints help information
]

# Print this message or the help of the given subcommand(s)
extern "pkg help" [
  --help(-h),                                 # Prints help information
]

hide commands;
