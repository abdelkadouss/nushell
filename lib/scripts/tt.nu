use ../shared/external *;

# translate text
export def main [
  text: string,
  target: string = "ar"
  --reverse-chars(-r)
  --reverse-words(-w)
] {
  external exist --panic true [ "libretranslate" ];

  let body = {
    q: $text,
    source: "auto",
    target: $target,
  }

  let translate = {
    http post --content-type application/json http://localhost:5000/translate $body 
    | get translatedText 
    | if ($reverse_chars or $reverse_words) {
      match $reverse_chars {
        true => { 
          print ($in | str reverse);
        }
        false => { $in | split words | reverse | each { |word|
          print -n $word; print -n " ";
        } | ignore }
      }
    } else {$in}
  };

  try {
    do $translate;
  } catch { |err|
    print -e "Will looks like the server is down, trying to start it...";
    if ( $err.msg == "Network failure" ) {
      let id = (
        job spawn {
          libretranslate --load-only en,ar;
        };
      );
      sleep 2sec;
      $env.TRANSLATE_PID =  (job list | where id == $id | get pids | first | first);
      sleep 3sec;
      print -e "Pass the server to the background";

      try {
        do $translate;
      } catch { |err|
        if ($env.TRANSLATE_PID? | is-not-empty) {
          try { kill -9 $env.TRANSLATE_PID };
          $env.TRANSLATE_PID = "";
        }
        echo $err.msg;
      }
    }
  };
}
