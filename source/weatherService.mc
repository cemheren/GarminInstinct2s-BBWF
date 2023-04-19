using Toybox.Background;
using Toybox.System as Sys;
using Toybox.System;
using Toybox.Communications;

// The Service Delegate is the main entry point for background processes
// our onTemporalEvent() method will get run each time our periodic event
// is triggered by the system.

// (:background)
class WeatherServiceDelegate extends Toybox.System.ServiceDelegate {
	
    var url = "https://atlas.microsoft.com/weather/forecast/hourly/json";

	function initialize() {
		Sys.ServiceDelegate.initialize();
		// inBackground=true;				//trick for onExit()
	}
	
    function onTemporalEvent() {
    	var now=Sys.getClockTime();
    	var ts=now.hour+":"+now.min.format("%02d");

        var params = {                                              // set the parameters
            "api-version" => "1.1",
            "query" => "47.608013,-122.349358",
            "duration" => "1",
            "subscription-key" => ""
        };

        var options = {                                             // set the options
            :method => Communications.HTTP_REQUEST_METHOD_GET,      // set HTTP method
            :headers => {                                           // set headers
                    "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED},
                                                                   // set response type
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
        };

        var responseCallback = method(:onReceive);                  // set responseCallback to
                                                                   // onReceive() method
 
        // Make the Communications.makeWebRequest() call
        Communications.makeWebRequest(url, params, options, responseCallback);
        Sys.println("making request: "+ url);
    }

       // set up the response callback function
   function onReceive(responseCode, data) {
        if (responseCode == 200) {
            System.println("Request Successful");                   // print success
        }
        else {
            System.println("Response: " + responseCode);            // print response code
        }

        //just return the timestamp
        Sys.println("bg exit: "+data);
        Background.exit(data);
   }
}
