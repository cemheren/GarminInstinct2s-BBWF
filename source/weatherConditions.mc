class WeatherConditions
{
    static function GetWeatherEmoji(c as Number)
    {

        //https://developer.garmin.com/connect-iq/api-docs/Toybox/Weather.html#getCurrentConditions-instance_function
        switch (c){
            case 0:      //CONDITION_CLEAR
            case 22:     //CONDITION_PARTLY_CLEAR
            case 23:     //CONDITION_MOSTLY_CLEAR
            return "sn"; 
            case 1:      //CONDITION_PARTLY_CLOUDY
            return "pc"; 
            case 2:      //CONDITION_MOSTLY_CLOUDY
            case 20:     //CONDITION_CLOUDY
            return "cl"; 
            case 3:      //CONDITION_RAIN
            case 14:     //CONDITION_LIGHT_RAIN
            case 15:     //CONDITION_HEAVY_RAIN
            case 45:     //CONDITION_CLOUDY_CHANCE_OF_RAIN
            case 25:     //CONDITION_SHOWERS
            case 26:     //CONDITION_HEAVY_SHOWERS
            case 27:     //CONDITION_CHANCE_OF_SHOWERS
            return "rn";
            case 4:      //CONDITION_SNOW
            case 46:     //CONDITION_CLOUDY_CHANCE_OF_SNOW
            return "sw";
            case 5:      //CONDITION_WINDY
            return "wd";
            case 6:      //CONDITION_THUNDERSTORMS
            return "st";
            case 7:      //CONDITION_WINTRY_MIX
            return "st";
            case 8:      //CONDITION_FOG
            return "fg";
            case 9:      //CONDITION_HAZY
            case 39:     //CONDITION_HAZE
            return "hz";
            case 33:     //CONDITION_SMOKE
            return "smk";

            default:
            return "u";
        }

        return "p";
    }
}