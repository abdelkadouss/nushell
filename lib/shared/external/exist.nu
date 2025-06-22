use not_exist_action.nu "bin not exist";

def levels [] { ["error", "warning", "info"] };

# check if the bin is in the path and make decisions in Chaa'Allah
export def --env "external exist" [
  bins: list
  --stdout-message(-m) = false # just print message in the stdout if the bin is not in the path
  --action-level(-l): string@levels = "warning" # error, warning, info
  --stdlib(-s) = false # use the nu standard library log commands
  --panic(-p) = false # panic if the bin is not in the path
] {
  for bin in $bins {
    if ( which $bin | is-empty ) {
      bin not exist $bin $panic $stdout_message $action_level $stdlib
      | if not $in {
        return false;
      } else {
        return;

      };

    };

  };

  return true;

};

