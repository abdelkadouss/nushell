use runtime.nu *;

export def "config read" [] {
  let input_file = ( runtime info | get packages_declaration_file );

  return ( open $input_file | get -o packages );

}

export def "config write" [
  pkg: record<
        name: string,
        repo: string,
        type: string
  >
] {
  runtime check;

  let target_file = ( runtime info | get packages_declaration_file );

  open $target_file
  | get -o packages
  | default {}
  | upsert $pkg.name {
    repo: $pkg.repo,
    type: $pkg.type

  }
  | { packages: $in }
  | save -f $target_file;

}

export def "config remove" [
  pkg_name: string
] {
  runtime check;

  let target_file = ( runtime info | get packages_declaration_file );

  open $target_file
  | get -o packages
  | default {}
  | reject $pkg_name
  | { packages: $in }
  | save -f $target_file;

}
