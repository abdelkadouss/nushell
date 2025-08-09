use ../shared/external *;

export def main [] {
  external exist --panic true ["python3"];
  let myIpAdr = (
    sys net
    | where name == en0
    | get ip
    | first
    | where protocol == ipv4
    | first
    | get address
  )

  print $"(ansi bg)just go to:(char nl)(ansi bu)http://($myIpAdr):8000(ansi reset)"

  external run python3 `-m` http.server;
}
