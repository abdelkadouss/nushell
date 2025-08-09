export module env {
  export def exists [
    var: cell-path,
    --panic(-p)
    --return-value(-v)
  ] {
    try {
      $env
      | get $var
      | (
        if $return_value {
          return $in

        } else {
          return true

        }
      )
    } catch {
      if $panic {
        panic $"Missing Environment Variable: ( $var ) does not exist"

      }

      return false

    };

  };

};
