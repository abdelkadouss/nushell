use as_admin.nu "as admin";

overlay new as_admin;
overlay use as_admin;

# list of variables that should not be included in the scope
const IGNORED_VARS = [ "$in" ];
const IGNORED_ALIAS = [ "as admin" ];

# make the scope ready to source in Chaa'Allah
let var_scope_file = ( mktemp --suffix .nu --tmpdir-path /scope );
let module_scope_file = ( mktemp --suffix .nu --tmpdir-path /scope );
let alias_scope_file = ( mktemp --suffix .nu --tmpdir-path /scope );

# filter the scope
let var_scope = (
  scope variables
  | (
    $in
    | where {|var|
      not (
        $var.name in $IGNORED_VARS
      )
    }
  )
);

for var in $var_scope {
  $"let ($var.name) = ( $var.value | to nuon --serialize );(char nl)"
  | save --append $var_scope_file

}

for module in (scope modules) {
  if ($module.file | path exists) and ($module.file | nu-check) {
    let module_tmp_file = ( mktemp --suffix .nu --tmpdir-path /tmp );

    open --raw $module.file
    | save -f $module_tmp_file;

    $module_tmp_file
    | $"use ($module.name) *;(char nl)"
    | save --append $module_scope_file;

  };

};

let alias_scope = (
  scope aliases
  | where {|alias|
    not (
      $alias.name in $IGNORED_ALIAS
    )
  }

);

for alias in $alias_scope {
  $"alias ($alias.name | to nuon --serialize) = ($alias.expansion);(char nl)"
  | save --append $alias_scope_file

};

if not ( $var_scope_file | nu-check ) {
  panic "oh unexpected issue in makeing the scope file that used to include scope in Chaa'Allah";
}

overlay hide as_admin
