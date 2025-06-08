use "t.nu";

def animals [] { (ls $env.TEMPLATES_DIR | where name =~ ".nu" | merge (ls $env.TEMPLATES_DIR | where name =~ ".nuon") | get name | each {|e| $e | path parse | get stem }) }

const UNACCEPTED_NAME = "lib";

# make new project realy quick in Chaa Allah.
export def main [name: string@animals] {
  if ($name == $UNACCEPTED_NAME) { print $"(ansi red_bold)ERR: (ansi reset)Can't use name (ansi underline)'($UNACCEPTED_NAME)'(ansi reset) as template name!"; return; };

  let base = ( $env.TEMPLATES_DIR );
  let struct = $base | path join $"($name).nuon";
  let run = $base | path join $"($name).nu";

  if not ($struct | path exists) {
    print $"Template struct ($name).nuon not found!... ignoring.";
  } else {
    print $"Making ($name).nuon structure...";
    t ( open $struct );

  };
  if not ($run | path exists) {
    print $"Script ($name).nu not found!... ignoring.";
  } else {
    print $"Runing ($name).nu script...";
    nu $run;
  };

  print $"Done thank's to Allah 🌻✨";

  return;
};
