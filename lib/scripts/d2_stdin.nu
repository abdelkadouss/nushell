use ../shared/external "external exist";

export def "d2 --stdin" [ --theme (-t) = 0 --sketch (-s) ]: string -> nothing {
  # make sure d2 and viu is installed
  external exist [ d2 viu ];

  # make a temp file
  let tmp = (mktemp --suffix .png --tmpdir-path "/tmp" | path expand);

  # convert to png and write to temp file and open in viu
  $in | (
    if $sketch {
      $in
      | d2 --sketch --theme $theme --stdout-format png -
      | save -f $tmp;
    } else {
      $in
      | d2 --theme $theme --stdout-format png -
      | save -f $tmp;
    }
  );

  # run
  viu $tmp;

  # ckeanup
  rm -rfp $tmp;

};

export def "d2 cat" [
  file: string
  --theme (-t) = 0
  --sketch (-s)
] {
  if ($sketch) {
    open $file
    | d2 --stdin --theme $theme --sketch;

  } else {
    open $file
    | d2 --stdin --theme $theme;

  }

}
