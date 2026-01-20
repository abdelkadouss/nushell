const CLIPBOARD_PATH = '~/.local/state/nushell/files_clipboard';

# copy files to paste them in other path
export def copy [
  --remove-original (-r) # remove the original file after paste
]: oneof<string, list<string>> -> nothing {
  let to_copy = $in;

  try { mkdir ($CLIPBOARD_PATH | path expand | path dirname) };
  try { touch ($CLIPBOARD_PATH | path expand) };

  for path in $to_copy {
    $path
    | path expand
    | (
      if $remove_original {
        $"($path)|rm"
      } else { $path }
    )
    | save --append ($CLIPBOARD_PATH | path expand);

  }

}

# paste files from clipboard
export def paste [
]: nothing -> nothing {
  open ($CLIPBOARD_PATH | path expand)
  | lines
  | where { is-not-empty }
  | each { split row "|" }
  | (
    for line in $in {
      if not ($line.0 | path exists) {
        use std/log;
        log info $'path ($line.0) not exists';
        continue;

      };

      try {
        if (($line.1? | default null) | is-not-empty) {
          mv $line.0 .
          continue;

        }

        cp --recursive $line.0 .;

      } catch {
        use std/log;
        log error $'failed to paste ($line.0)'

      }

    }
  )

  if ($CLIPBOARD_PATH | path exists) {
    rm --force --recursive $CLIPBOARD_PATH

  }

}
