export def main [input] {
  if not ($input | describe | str starts-with "record") { arrays $input; return; };
  let $input = $input | transpose pathes content;
  let in_len = $input | length;
  mut folders = [];
  mut files = [];

  mut index = $in_len - 1;
  while ($index >= 0) {
    let path = $input | get content | select $index | get 0;

    if (($path | describe) | (($in == "string") or ($in == "nothing"))) {
      $files = $files | append $index;
    } else if ($path | describe | str starts-with "list") {
      $folders = $folders | append $index;
    }
    $index -= 1;
  };

  for file in $files {
    let path = ( $input | get $file | get pathes );
    if not ($path | path exists) {

      let content = ($input | get $file | get content);
      if ($content | describe) == "string" {
        $content | save $path;
      } else {
        touch $path;
      }

      print $"(ansi green_bold)+ (ansi blue)($path)(ansi reset)";
    }
  }

  for folder in $folders {
    let dir = ( $input | get $folder | get pathes );
    if not ($dir | path exists) {
      mkdir $dir;
      print $"(ansi green_bold)+ (ansi purple)($dir)(ansi reset)";
    }
    arrays ( $input | get $folder | get content ) $dir;
  };
};

def arrays [arr, parent = ""] {
  for item in $arr {
    if ($item | describe | str starts-with "record") {

      mut names = [];
      let paths = ($item | transpose pathes content | get pathes);
      for $path in $paths {
        $names = ($names | append ($parent | path join $path));
      };

      mut out = {};
      mut index = 0;
      for $name in $names {
        $out = ($out | insert $name ( $item | transpose pathes content | get content | get $index ) );
        $index += 1;
      };

      main $out;
    } else if ($item | describe) == "string" {
      if not ($item | path exists) {
        let file = ($parent | path join $item );
        if not ($file | path exists) {
          touch $file;
          print $"(ansi green_bold)+ (ansi blue)($parent | path join $item)(ansi reset)";
        };
      };
    };
  };
};
