### README:

# * this script needs some env vars to be seted which are next:
# ** $env.config.plugins.salat.city: ur city name
# ** $env.config.plugins.salat.country: ur country name

###

### NOTE: for e.g u can uncomment the following lines to set ur city and country name
# $env.config.plugins.salat.city = "Mecca";
# $env.config.plugins.salat.country = "Saudi";

# list salat timings of today
@example 'list salat timings' {
    $env.config.plugins.salat.city = "Mecca";
    $env.config.plugins.salat.country = "Saudi";
    salat;
}
export def main [] {
    let res = (http get $"https://api.aladhan.com/v1/timingsByCity?city=($env.config.plugins.salat.city)&country=($env.config.plugins.salat.country)%20Arabia&method=1");
    if (($res | get code) == 200) {
        print $res.data.timings;
    } else {
        print -e "error";
    }
}
