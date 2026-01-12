use runtime.nu *;

# clean installation tmps
export def 'nupm clean' [] {
  runtime check;

  let tmp_dir = ( runtime info | get tmp_dir );

  rm -rfp $tmp_dir;

  print $"🧹"

};
