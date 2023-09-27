class ForecastResult
{
    function initialize(dailyData, weeklyData, rain)
    {
        DailyData = dailyData;
        Rain = rain;
        WeeklyData = weeklyData;
    }

    public var DailyData;
    public var Rain;
    public var WeeklyData;
}

class Forecast
{
    using Toybox.Time;
    using Toybox.Time.Gregorian;

    private static var cacheExpiry;
    private static var cacheValue;

    private static var HALF_HOUR;

    function initialize()
    {
        HALF_HOUR = new Time.Duration(1800);
    }

    function getNextEvent(current)
    {
        var moment = Time.now();

        if(cacheExpiry == null || cacheExpiry.compare(moment) < 0)
        {
            if(current != null)
            {
                var forecast = Toybox.Weather.getHourlyForecast();
                if(forecast != null)
                {
                    var currPrecip = current.precipitationChance;
                    var graphData = new PlottableArray(-1000);
                    var rain = false;

                    for (var i = 0; i < forecast.size(); ++i) 
                    {
                        graphData.add(forecast[i].precipitationChance);

                        if(i < 6 && forecast[i].precipitationChance >= 50) //&& forecast[i].precipitationChance > currPrecip
                        {
                            rain = true;
                            // var rainTime = Toybox.Time.Gregorian.info(forecast[i].forecastTime, Time.FORMAT_MEDIUM);
                            // saliencyAreaLineOneCoor.drawSmallTextAt(dc, "rain @");
                            // saliencyAreaLineTwoCoor.drawSmallTextAt(dc, Lang.format("$1$:$2$", [rainTime.hour, rainTime.min.format("%02d")]));
                            // return;
                        }

                        if(i > 5 && rain == false) 
                        {
                            break;
                        }
                    }

                    if(rain)
                    {
                        var dailyForecast = Toybox.Weather.getDailyForecast();
                        var dailyGraphData = new PlottableArray(-1000);

                        for(var i = 0; i < dailyForecast.size() && i < 5; ++i)
                        {
                            dailyGraphData.add(dailyForecast[i].precipitationChance);
                        }
                        
                        cacheExpiry = moment.add(HALF_HOUR);
                        cacheValue = new ForecastResult(graphData, dailyGraphData, rain);
                    }
                    else
                    {
                        cacheExpiry = moment.add(HALF_HOUR);
                        cacheValue = new ForecastResult(null, null, false);
                    }

                    return cacheValue;
                }

                return new ForecastResult(null, null, false);
            }
            return cacheValue;
        }else{
            return cacheValue;
        }
    }
}