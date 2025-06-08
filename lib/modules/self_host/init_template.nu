# use ~/.templates/lib/fs.nu;

def format_and_write [file_path: string, output_path, content: string] {
  mut output = (cat $file_path);

  while ($output | str contains "<#>") {
    $output = ($output | str replace "<#>" $content);
  };

  $output | save $output_path;
};

export def main [templete_name: string, output_path: string] {
  let file_name = $"($templete_name).nu";
  let templates_dit = ($env.config.plugins.self_host.templates_path | default "./templates");

  ls $templates_dit
  | if ($in | find $file_name | is-not-empty) {
    mut output = $output_path;

    if ( $output | path exists) {
      $output = ($output | path join (random int | into string) );
    };

    format_and_write ( [$templates_dit, $file_name] | path join ) $output ($output_path | path parse | get stem);
  } else {
    error make {
      msg: $"the template '($file_name)' does not exist."
      label: {
        text: "this template does not exist"
        span: (metadata $file_name).span
      }
      help: $"go ahead and make the template in the ($templates_dit) folder"
    }
  };

};
