use shared/environment.nu *;
use app_config.nu *;

# clean installation tmps
export def 'nupm clean' [] {
  config check;

  let tmp_dir = env exists --panic --return-value $.config.plugins.nupm.NUPM_TMP_DIR;

  rm -rfp $tmp_dir;

  print $"🧹"

};
