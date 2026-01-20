use not_exist_action.nu "bin not exist";

def levels [ ]: nothing -> list<string> { [ error warning info ] };

# check if the bin is in the path and make decisions in Chaa'Allah
export def --env "external exist" [
  --stdout-message (-m) = false # just print message in the stdout if the bin is not in the path
  --action-level (-l): string@levels = "warning" # error, warning, info
  --stdlib (-s) = false # use the nu standard library log commands
  --panic (-p) = false # panic if the bin is not in the path
  # nu-lint-ignore: list_param_to_variadic
  bins: list<string> # bins to check
]: nothing -> oneof<bool, nothing> {
  for bin in $bins {
    if (which $bin | is-empty) {
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
