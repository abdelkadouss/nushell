use ../shared/bin_utils.nu [make_sure_bin_in_the_path, run_bin_if_in_path];

export def main [] {
  make_sure_bin_in_the_path ["python3"];
  let myIpAdr = (
    sys net
    | where name == en0
    | get ip
    | first
    | where protocol == ipv4
    | first
    | get address
  )

  print $"just go to:\n http://($myIpAdr):8000"

  run_bin_if_in_path python3 -m http.server;
}
