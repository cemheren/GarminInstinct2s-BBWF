import Toybox.Activity;
import Toybox.ActivityMonitor;

class HeartRate 
{
    private var _showHeartRate;
    private var graphData;
    // private static var sixHours = new Time.Duration(12600);
    // private static var oneMin = new Time.Duration(600);

    public function initialize(showHeartRate)
    {
        _showHeartRate = showHeartRate;
    }

    function currentHeartRate()
    {
        var info = Activity.getActivityInfo();
        
        if(info == null || info.currentHeartRate == null)
        {
            return "--";
        } 

        return info.currentHeartRate;
    }

    function heartRateHistory(){
        graphData = new PlottableArray(ActivityMonitor.INVALID_HR_SAMPLE);

        if (ActivityMonitor has :getHeartRateHistory) {
            var getNext = true;
            
            var iterator = ActivityMonitor.getHeartRateHistory(100, true /* newestFirst */);

            while (getNext) {
                var sample = iterator.next();
                if (sample != null) {

                    
                    if (sample.heartRate == ActivityMonitor.INVALID_HR_SAMPLE)
                    {
                        graphData.addInvalidData(sample.heartRate);
                    }
                    else
                    {
                        graphData.add(sample.heartRate);
                    }
                } 
                else 
                {
                    getNext = false;
                }
            }
        }

        return graphData;
    }
} 

