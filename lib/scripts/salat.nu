export def main [] {
    let res = (http get "https://api.aladhan.com/v1/timingsByCity?city=Debila&country=Algerai%20Arabia&method=1");
    if (($res | get code) == 200) {
        print $res.data.timings;
    } else {
        print -e "error";
    }
}
