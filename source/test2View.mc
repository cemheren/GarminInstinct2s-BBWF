import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Activity;
import Toybox.Weather;
import Toybox.UserProfile;
import Toybox.ActivityMonitor;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Math;

class test2View extends WatchUi.WatchFace {

    private var sleep = false;

    // private var dayCoordinate = new Coordinate(14, 8);
    // private var dayOfWeekCoordinate = new Coordinate(2, 22);
    // private var monthCoordinate = new Coordinate(2, 45);
    private var EIGHT_HOURS = new Time.Duration(28800);

    private var hr = new HeartRate(true); 
    private var sunRiseSet = new SunRiseSet();
    private var forecast = new Forecast();

    private var utcClockCoordinate = new Coordinate(57, -1);
    private var japanClockCoordinate = new Coordinate(30, -1);
    private var turkeyClockCoordinate = new Coordinate(85, -1);
    private var topDividerStart = new Coordinate(17, 22);

    private var clockCoordinate = new Coordinate(50, 35);
    private var secondsCoordinate = new Coordinate(115, 70);

    private var middleBarStartY = 98; 

    private var bottomVersicalDividerHeight = 20;
    private var temperatureMeterBottomStart = new Coordinate(3, middleBarStartY + bottomVersicalDividerHeight);
    
    private var bottomDividerStart = new Coordinate(5, middleBarStartY + bottomVersicalDividerHeight);
    private var bottomVerticalDividerOneStart = new Coordinate(50, middleBarStartY);
    private var bottomVerticalDividerTwoStart = new Coordinate(100, middleBarStartY);

    private var currentTemperatureCoor = new Coordinate(28, middleBarStartY);
    private var currentTemperatureFCoor = new Coordinate(30, middleBarStartY);

    private var stepsCoor = new Coordinate(75, middleBarStartY);
    private var stepsBarCoor = new Coordinate(51, 118);
    
    private var bottomRightBoxCoor = new Coordinate(127, middleBarStartY);

    private var heartRateAreaY = 122;

    private var heartRateCoordinate = new Coordinate(25, heartRateAreaY);
    private var heartRateTrendlineCoordinate = new Coordinate(40, heartRateAreaY);

    private var saliencyAreaLineOneCoor = new Coordinate(135, 5);
    private var saliencyAreaLineTwoCoor = new Coordinate(135, 25);

    private var saliencyAreaGraphCoor = new Coordinate(120, 10);
    
    private var saliencyAreaSecondGraphCoor = new Coordinate(128, 36);

    private var saliencyAreaCircleGraphCoor = new Coordinate(136, 27);

    private var recoveryInfoGraphCoor = new Coordinate(140, 60);

    private var prevMin;
    private var nextDrawAll;

    private var userProfile;

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Seems like we need to update minutes here only 
    function onPartialUpdate(dc as Dc)
    {
        // // dc.setClip(clockCoordinate.X, clockCoordinate.Y, 20, 25);
        // // dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        
        // // drawClocks(dc, true);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {

        var time = System.getClockTime();
        var currMin = time.min;

        if(currMin == prevMin) // update this section more frequently 
        {
            dc.setClip(heartRateCoordinate.X - 20, heartRateCoordinate.Y, 34, 30);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
            dc.clear();

            var currentHeartRate = hr.currentHeartRate();
            var heartrateString = Lang.format("$1$", [currentHeartRate]);
            heartRateCoordinate.drawSmallTextAt(dc, heartrateString);   
        
            return;
        }

        if(nextDrawAll != null && (nextDrawAll > currMin))
        {
            dc.setClip(clockCoordinate.X - 40, clockCoordinate.Y, 85, 50);
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
            dc.clear();

            drawClocks(dc, true);

            if(nextDrawAll > 60 && currMin < 15)
            {
                nextDrawAll = nextDrawAll % 60;
            }

            prevMin = currMin;
            return; 
        }

        nextDrawAll = currMin + 15;

        dc.setClip(0, 0, 170, 170);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        drawClocks(dc, false);
        drawSaliencyArea(dc);

        var hrData = hr.heartRateHistory();
        var currentHeartRate = hr.currentHeartRate();
        heartRateTrendlineCoordinate.drawArray(dc, 30.0, hrData, 100, 120, currentHeartRate);

        var heartrateString = Lang.format("$1$", [currentHeartRate]);
        heartRateCoordinate.drawSmallTextAt(dc, heartrateString);   
        
        var current = Toybox.Weather.getCurrentConditions();
        if(current != null && current.feelsLikeTemperature != null)
        {
            var fah = (current.feelsLikeTemperature * 1.8 + 32).toNumber();
            // currentTemperatureFCoor.drawTinyTextAt(dc, Lang.format("$1$", [fah]));
            currentTemperatureCoor.drawSmallTextAt(dc, Lang.format("$1$°$2$", [fah, WeatherConditions.GetWeatherEmoji(current.condition)]));

            if(current.highTemperature != null && current.highTemperature > 0)
            {
                var h = 80.0;
                temperatureMeterBottomStart.drawPointWithYOffset(dc, h * (current.highTemperature / 30.0), 2);
                
                temperatureMeterBottomStart.drawPointWithYOffset(dc, h * (-0.22), 1); // 20 F  -6.6 / 30.0
                // temperatureMeterBottomStart.drawPointWithYOffset(dc, h * (0 / 30.0), 1);
                temperatureMeterBottomStart.drawPointWithYOffset(dc, h * (0.14), 1); // 40 F   4.4 / 30.0
                temperatureMeterBottomStart.drawPointWithYOffset(dc, h * (0.51), 1); // 60 F  15.5 / 30.0
                temperatureMeterBottomStart.drawPointWithYOffset(dc, h * (0.88), 1); // 80 F  26.6 / 30.0
                // temperatureMeterBottomStart.drawPointWithYOffset(dc, h * (30 / 30.0), 1);
                
                var currentRatio = current.feelsLikeTemperature / 30.0;

                temperatureMeterBottomStart.drawPointWithYOffset(dc, h * (currentRatio), 2);
                temperatureMeterBottomStart.drawVerticalLineForPercentile(dc, 2, h, currentRatio);
            }

        }else
        {
            currentTemperatureCoor.drawSmallTextAt(dc, "--"); 
        }
        // currentTemperatureCoor.drawSmallTextAt(dc, Lang.format("$1$ $2$", [current.feelsLikeTemperature, WeatherConditions.GetWeatherEmoji(current.condition)]));

        var info = ActivityMonitor.getInfo();
        if(info != null && info.steps != null)
        {
            stepsCoor.drawSmallTextAt(dc,  Lang.format("$1$", [info.steps]));
            
            if(info.stepGoal != null && info.stepGoal != 0)
            {
                stepsBarCoor.drawHorizontalLineForPercentile(dc, 2, 49, info.steps.toDouble() / info.stepGoal);
            }
        }

        topDividerStart.drawHorizontalLine(dc, 1, 78);
        if(current != null && current.observationLocationPosition != null)
        {
            var riseSetResult = sunRiseSet.getNextEvent(current);
            var moment = Time.now();
            
            if(riseSetResult.Type == "set")
            {
                var tillSet = riseSetResult.Time.subtract(moment); 
                if(tillSet.greaterThan(EIGHT_HOURS))
                {
                    topDividerStart.drawHorizontalLineForPercentileFromRight(dc, 2, 78, 0);
                }else
                {
                    var leftOver = tillSet.subtract(EIGHT_HOURS);
                    topDividerStart.drawHorizontalLineForPercentileFromRight(dc, 2, 78, leftOver.value().toDouble() / EIGHT_HOURS.value());
                }
            }else
            {
                var tillRise = moment.subtract(riseSetResult.Time); 
                if(tillRise.greaterThan(EIGHT_HOURS))
                {
                    topDividerStart.drawHorizontalLineForPercentileFromRight(dc, 2, 78, 0);
                }else
                {
                    var leftOver = tillRise.subtract(EIGHT_HOURS);
                    topDividerStart.drawHorizontalLineForPercentileFromRight(dc, 2, 78, leftOver.value().toDouble() / EIGHT_HOURS.value());
                }
            }
        }

        bottomDividerStart.drawHorizontalLine(dc, 1, 145);
        bottomVerticalDividerOneStart.drawVerticalLine(dc, 1, bottomVersicalDividerHeight);
        bottomVerticalDividerTwoStart.drawVerticalLine(dc, 1, bottomVersicalDividerHeight);

        if(info != null && info.timeToRecovery != null && info.timeToRecovery != 0)
        {
            recoveryInfoGraphCoor.drawTinyTextAt(dc, Lang.format("R$1$", [info.timeToRecovery]));
        }

        prevMin = System.getClockTime().min;
    }

    function drawClocks(dc as Dc, onlyMain)
    {
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        clockCoordinate.drawLargeTextAt(dc, timeString);

        if(onlyMain)
        {
            return;
        }

        var moment = Time.now();
        var currentTime = Toybox.Time.Gregorian.info(moment, Time.FORMAT_MEDIUM);
        // dayCoordinate.drawTinyTextAt(dc, Lang.format("$1$", [currentTime.day.format("%02d")]));
        // dayOfWeekCoordinate.drawTinyTextAt(dc, Lang.format("$1$", [currentTime.day_of_week]));
        // monthCoordinate.drawTinyTextAt(dc, Lang.format("$1$", [currentTime.month]));

        bottomRightBoxCoor.drawSmallTextAt(dc, Lang.format("$1$ $2$", [currentTime.day_of_week, currentTime.day.format("%02d")]));

        var utcTime = Toybox.Time.Gregorian.utcInfo(moment, Time.FORMAT_MEDIUM);
        var utcTimeString = Lang.format("$1$", [utcTime.hour.format("%02d")]);

        utcClockCoordinate.drawSmallTextAt(dc, utcTimeString);

        var japanHour = (utcTime.hour + 9) %24;
        var turkeyHour = (utcTime.hour + 3) %24;

        japanClockCoordinate.drawSmallTextAt(dc, Lang.format("$1$", [japanHour.format("%02d")]));
        turkeyClockCoordinate.drawSmallTextAt(dc, Lang.format("$1$", [turkeyHour.format("%02d")]));

        // if(!sleep)
        // {
        //     var secondsTimeString = Lang.format("$1$", [clockTime.sec.format("%02d")]);
        //     secondsCoordinate.drawSmallTextAt(dc, secondsTimeString);
        // }else
        // {
        //     var secondsTimeString = "  ";
        //     secondsCoordinate.drawSmallTextAt(dc, secondsTimeString);
        // }
    }

    function drawSaliencyArea(dc as Dc)
    {
        // var info = Activity.getActivityInfo();
        // if(info != null && info.timerTime != null)
        // {
        //     var time = info.timerTime / 1000;
        //     var mins = Math.floor(time / 60);
        //     var seconds =  time - (mins * 60);
        //     saliencyAreaLineOneCoor.drawSmallTextAt(dc, "timer");
        //     saliencyAreaLineTwoCoor.drawSmallTextAt(dc, Lang.format("$1$:$2$", [mins, seconds]));
        //     return;
        // }

        var stats = System.getSystemStats();
        if(stats != null)
        {
            var pwr = stats.battery;
            if(pwr < 2.1)
            {
                var batStr = Lang.format("$1$%", [ pwr.format( "%2d" ) ] );
                saliencyAreaLineOneCoor.drawSmallTextAt(dc, "low");
                saliencyAreaLineTwoCoor.drawSmallTextAt(dc, batStr);
                return;
            }
        }

        var current = Toybox.Weather.getCurrentConditions();
        
        if(current != null)
        {
            var forecastResult = forecast.getNextEvent(current);

            if(forecastResult != null && forecastResult.DailyData != null && forecastResult.Rain) // if rain is false should be enough here but can't be too safe with this stuff
            {
                // saliencyAreaCircleGraphCoor.drawPercentageCurvedBarChart(dc, 25.0, 40.0, forecastResult.DailyData);

                saliencyAreaGraphCoor.drawPercentageBarChart(dc, 20.0 /*height*/, 36.0, forecastResult.DailyData, 2);
                saliencyAreaSecondGraphCoor.drawPercentageBarChart(dc, 10.0 /*height*/, 20.0, forecastResult.WeeklyData, 3);
                return;
            }

            // temps are in C by default 
            // Don't show this later than 5, likely it's not going to get warmer
            var clockTime = System.getClockTime();
            if(clockTime.hour < 5 && current.feelsLikeTemperature != null && current.highTemperature != null && current.highTemperature - current.feelsLikeTemperature > 4)
            {
                var fah = (current.highTemperature * 1.8 + 32).toNumber();
                saliencyAreaLineTwoCoor.drawSmallTextAt(dc, Lang.format("$1$°$2$", [fah, WeatherConditions.GetWeatherEmoji(current.condition)]));
                saliencyAreaLineOneCoor.drawSmallTextAt(dc, "warm");
                return;
            }
        }
        
        if(current != null && current.observationLocationPosition != null)
        {
            var riseSetResult = sunRiseSet.getNextEvent(current);
            saliencyAreaLineOneCoor.drawSmallTextAt(dc, riseSetResult.Type);
            saliencyAreaLineTwoCoor.drawSmallTextAt(dc, riseSetResult.TimeText);
            return;
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
        sleep = false;
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
        sleep = true;
    }

}
