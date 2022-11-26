class SunRiseSetResult
{
    function initialize(type, timeText, time)
    {
        Type = type;
        TimeText = timeText;
        Time = time;
    }

    public var Type;
    public var TimeText;
    public var Time;
}

class SunRiseSet
{
    using Toybox.Time;
    using Toybox.Time.Gregorian;

    private static var cacheExpiry;
    private static var cacheValue;

    function initialize()
    {

    }

    function getNextEvent(current)
    {
        var moment = Time.now();

        if(cacheExpiry == null || cacheExpiry.compare(moment) < 0)
        {
            if(current.observationLocationPosition == null)
            {
                return new SunRiseSetResult("--", Lang.format("$1$:$2$", ["--", "--"]));
            }
            
            var currSunset = Toybox.Weather.getSunset(current.observationLocationPosition, moment);

            if(currSunset.compare(moment) > 0)
            {
                var set = Gregorian.info(currSunset, Time.FORMAT_MEDIUM);
                cacheValue = new SunRiseSetResult("set", Lang.format("$1$:$2$", [set.hour, set.min.format("%02d")]), currSunset);
                cacheExpiry = currSunset;
                return cacheValue;
            }

            var nextSunRise = Toybox.Weather.getSunrise(current.observationLocationPosition, moment.add(new Time.Duration(Gregorian.SECONDS_PER_DAY)));
            var rise = Gregorian.info(nextSunRise, Time.FORMAT_MEDIUM);
            cacheValue = new SunRiseSetResult("rise", Lang.format("$1$:$2$", [rise.hour, rise.min.format("%02d")]), nextSunRise);
            cacheExpiry = nextSunRise;
            return cacheValue;
        }else{
            return cacheValue;
        }
    }
}