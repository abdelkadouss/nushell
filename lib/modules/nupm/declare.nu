use runtime.nu *;

const PKG_TYPES = [
  'bin',
  'module',
  'script'
];

export def "plugin declare" [
    name: string,
    path: string,
    pkg_type: string
] {
  runtime check;

  let plugins_declaration_file = (
    runtime info | get plugins_declaration_file
  );

  let new_declaration = (
    open $plugins_declaration_file
    | get -o $pkg_type
    | default {}
    | upsert $name $path
  );

  open $plugins_declaration_file
  | upsert $pkg_type $new_declaration
  | save -f $plugins_declaration_file;

};

export def "plugin undeclare" [
  pkg_name: string
  pkg_type: string
] {
  runtime check;

  let plugins_declaration_file = ( runtime info | get plugins_declaration_file );

  if not ( $pkg_type in $PKG_TYPES ) {
    panic $"Unknown package type: ( $pkg_type )"

  };

  let new_declaration = (
    open $plugins_declaration_file
    | get $pkg_type
    | default {}
    | reject $pkg_name
  );

  open $plugins_declaration_file
  | upsert $pkg_type $new_declaration
  | save -f $plugins_declaration_file;


};
