export def main [path] {
  mut p = $path
  if ($path | describe | str starts-with "table") {
    $p = ($path | get 0 | get name| path dirname)
  } else {
    if (not ($path | describe | $in == "string")) {
      return "path must be a string or a table";
    }
  };

  if (not ($p | path exists)) {
    return "path does not exist";
  };

  l $p | get name
  | each {
    |i| l $i
  }
}
