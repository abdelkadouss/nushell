# quick edit
use e.nu

# share dir
use shdir.nu

# salat
use salat.nu

# traslator.
use tt.nu;

# def tt [text: string] {
#   tl $text | str reverse;
# };

# table tree.
use ttree.nu;

# super touch.
use t.nu;

# git short interface.
use g.nu;

# nupm
use nupm *;

# self http post 
use self_host *;

# web search
use web_search.nu *;

# dm
use dm *;

# fzf
use fzf.nu *;

# d2 stdin
use d2_stdin.nu *;

# as admin
use as_admin.nu *;

# dir marks
source nupm/script/bookmark_for_dir.nu

# link
use link.nu;

# pkgx
use pkgx_build.nu *;

# jumps
use jumps.nu [ 'jump backward' 'jump forward' 'jump cleanup' 'jump list' ];

use clean.nu;
