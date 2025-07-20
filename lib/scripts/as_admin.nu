use ../shared/external "external exist";

const PERMISSION_MANAGER = "sudo";

# list of variables that should not be included in the scope
const IGNORED_VARS = [ "$in" ];
const IGNORED_ALIAS = [ "as admin" ];

# run a command as admin
# note: ur config file should be syntaxly correct
@example "run a custom command as admin" {
  as admin { say_thanks_to_Allah };
  # let's say u have the custom command `say_thanks_to_Allah` in your config
  # def say_thanks_to_Allah [] {if (is-admin) { print "i am an admin thanks to Allah" } }
  # ==> i am an admin thanks to Allah
}
export def "as admin" [ cmd: closure ] {
  # check if nu in the path
  external exist --panic true [ "nu" ];

  if not (is-admin) {
    if not ($nu.env-path | nu-check) or not ($nu.config-path | nu-check) { panic "u have an issue in ur config" };

    # make the scope ready to source in Chaa'Allah
    mut to_remove_files = [];

    let var_scope_file = ( mktemp --suffix .nu --tmpdir-path /tmp );
    let customs_scope_file = ( mktemp --suffix .nu --tmpdir-path /tmp );
    let module_scope_file = ( mktemp --suffix .nu --tmpdir-path /tmp );
    let alias_scope_file = ( mktemp --suffix .nu --tmpdir-path /tmp );

    $to_remove_files = ( $to_remove_files | append $var_scope_file );
    $to_remove_files = ( $to_remove_files | append $customs_scope_file );
    $to_remove_files = ( $to_remove_files | append $module_scope_file );
    $to_remove_files = ( $to_remove_files | append $alias_scope_file );


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

    let customs = (
      (scope commands)
      | where type == custom
      | get name
    );

    for custom in $customs {
      let code = ( view source ($custom) );
      let code = $"($code)(char nl)";

      $code
      | save --append $customs_scope_file;

    };

    for module in (scope modules) {
      if ($module.file | path exists) and ($module.file | nu-check) {
        let module_tmp_file = ( mktemp --suffix .nu --tmpdir-path /tmp );
        $to_remove_files = ( $to_remove_files | append $module_tmp_file );

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

    # make the closer a string
    let cmd_as_string = (
      $cmd
      | to nuon --serialize
      | str substring 1..(
        ( $in | str length ) - 2
      )
    );

    # run the command as admin
    ^$PERMISSION_MANAGER -SE nu --config ($nu.env-path) -c $"
    source ($nu.config-path);
    source ($var_scope_file);
    source ($customs_scope_file);
    source ($module_scope_file);
    source ($alias_scope_file);
    do --env ($cmd_as_string);
    "

    # clean up
    rm -rfp $to_remove_files;

  } else {
    do $cmd

  }

}
