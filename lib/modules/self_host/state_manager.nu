const tmp_file = "/tmp/self_host/runing_apps.db";

def make_table_if_not_exists [] {
  let tmp_dir = ( $tmp_file | path dirname );

  if not ( $tmp_dir | path exists ) {
    mkdir $tmp_dir;

  }

  if not ( $tmp_file | path exists ) {
    try {
      stor create -t runing_apps -c { name: str }

    } catch { ignore };

    stor export -f $tmp_file;

    stor reset | ignore;

  };

};

export def "state add" [ app_name: string ] {
  make_table_if_not_exists;
  open $tmp_file
  | query db $"insert into runing_apps values \( '($app_name)' )"
  | ignore;

};

export def "state delete" [ app_name: string ] {
  if not ( $tmp_file | path exists ) {
    print "no thing to delete 📭";
    return;

  };

  make_table_if_not_exists;
  open $tmp_file
  | query db $"delete from runing_apps where name = '($app_name)'"
  | ignore;

  if (
    (
      open $tmp_file
      | to json
      | from json
      | get runing_apps
      | length
    ) < 1
  ) {
    rm -rf $tmp_file;

  };

};

export def "self host list" [] {
  if not ( $tmp_file | path exists ) {
    print "no thing there 📭";
    return;

  };

  open $tmp_file | get runing_apps;

};
