# A concise Git interface for common operations
export def main [
  cmd: string,          # Command string (combine letters: 'a'=add, 'c'=commit, etc.)
  --add(-a): string = ".",       # Arguments for add command
  --commit(-c): string = "",    # Commit message (required if -c present)
  --push(-p) = "",              # Flag to push
  --status(-s) = "",            # Flag to show status
  --log(-l) = "",
  --diff(-d) = "",
] {
  let commands = {
    a: { git add --patch $add }
    c: { git commit -m $commit }
    p: { git push (git remote) (git branch --show-current) }
    s: { run_git status --short | lines | split column " " space change file | reject space }
    l: { run_git log --oneline --decorate --graph --all $log }
    d: { run_git diff --output-indicator-new=' ' --output-indicator-old=' ' $diff }
  }

  $cmd | split chars | each { |char|
    if $char in $commands {
      do ($commands | get $char)
    } else {
      print $"(ansi yellow)Warning:(ansi reset) Ignoring unknown command '($char)'"
    }
  } | ignore;
}

def --wrapped run_git [...cmd] {
  let git_cmd = $cmd | first;
  let opts = $cmd | last;
  let cmd = $cmd | drop 1;
  if ($opts == "") {
    print $"(ansi purple)($git_cmd):(ansi reset)" ( git ...$cmd );
  } else {
    print $"(ansi purple)($git_cmd):(ansi reset)" ( git ...$cmd $opts );
  }
}
