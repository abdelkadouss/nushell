#!/bin/nu
export def main [] {
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
  python3 -m http.server
}
