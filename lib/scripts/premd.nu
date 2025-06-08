export def main [mdFile: string] {
  Markdown.pl $mdFile | save previwe.html;
  echo `<style>
          body {
            font-family: sans-serif;
            background: #000000 ;
            color: #cdd6f4;
            }
            a { color: #b4beff; }
        </style>` o>> previwe.html;
  zsh -c "open previwe.html";
}
