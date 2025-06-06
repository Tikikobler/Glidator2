using Toybox.Application;
using Toybox.Sensor;

using Toybox.Activity;
using Toybox.ActivityRecording;
using Toybox.Attention;
using Toybox.System as Sys;

// --------------------------------------------------------------------------------
// Session recording
// --------------------------------------------------------------------------------

var session;

function isRecording()
{
    return (Toybox has :ActivityRecording) && $.session != null && $.session.isRecording();
}

function stopRecording(save)
{
    if ($.isRecording())
    {
        $.session.stop();
        if (save)
        {
            $.session.save();
        }
        else
        {
            $.session.discard();
        }
        
        if (Attention has :playTone)
        {
            Attention.playTone(Attention.TONE_STOP);
        }
        
        if (Attention has :vibrate)
        {
            var vibeData =
            [
                new Attention.VibeProfile(25, 1000)
            ];
            Attention.vibrate(vibeData);
        }
        
        $.session = null;
    }
}

function startRecording()
{
    if (isRecording())
    {
        return;
    }
    
    if (Toybox has :ActivityRecording)
    {
        $.session = ActivityRecording.createSession({
            :name=>"Glide",
            :sport=>Activity.SPORT_FLYING});
        $.session.start();
        
        if (Attention has :playTone)
        {
            Attention.playTone(Attention.TONE_START);
        }
        if (Attention has :vibrate)
        {
            var vibeData =
            [
                new Attention.VibeProfile(100, 1000)
            ];
            Attention.vibrate(vibeData);
        }
    }
}
         
// --------------------------------------------------------------------------------
// Globals
// --------------------------------------------------------------------------------
                  
var preferences;
  
// --------------------------------------------------------------------------------
// Main app
// --------------------------------------------------------------------------------

class FlyInstrumentApp extends Application.AppBase
{
    var mainView;
    var viewList;
    var delegateList;
    var currentViewIndex;
    
    function initialize()
    {
        AppBase.initialize();
        preferences = new Preferences();
        viewList = [];
        delegateList = [];
        currentViewIndex = 0; // Start with FlyInstrumentView
        Sys.println("App initialized, viewList: " + viewList + ", delegateList: " + delegateList + ", currentViewIndex: " + currentViewIndex);
    }

    // onStart() is called on application start up
    function onStart(state)
    {
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE, Sensor.SENSOR_TEMPERATURE]);
        Sensor.enableSensorEvents(method(:onSensor));
        Sys.println("App started, sensors enabled");
    }

    // onStop() is called when your application is exiting
    function onStop(state)
    {
        $.stopRecording(false);
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
        Sensor.enableSensorEvents(null);
        Sensor.unregisterSensorDataListener();
        Sys.println("App stopped, sensors disabled");
    }
    
    function onPosition(info as $.Toybox.Position.Info) as Void
    {
        // Do nothing to avoid both call of onPosition and onSensor called in the same cycle
        // mainView.updateData();   
    }
   
    // Should be called every 1Hz
    function onSensor(info as $.Toybox.Sensor.Info) as Void
    {
        mainView.updateData();
    }
    
    // Return the initial view of your application here
    function getInitialView()
    {
        mainView = new FlyInstrumentView();
        var timeView = new TimeView();
        var positionView = new PositionView(); // Add the new view
        viewList = [mainView, timeView, positionView]; // Update the view list
        delegateList = [new BaseInputDelegate(self), new BaseInputDelegate(self), new BaseInputDelegate(self)];
        Sys.println("Initial view setup, viewList size: " + viewList.size() + ", views: " + viewList[0].toString() + ", " + viewList[1].toString());
        Sys.println("delegateList size: " + delegateList.size());
        return [viewList[currentViewIndex], delegateList[currentViewIndex]];
    }

    // Switch to a specific view by index
    function switchToView(index)
    {
        Sys.println("switchToView called with index: " + index + ", viewList size: " + viewList.size());
        if (index >= 0 && index < viewList.size()) {
            currentViewIndex = index;
            Sys.println("Switching to view index: " + index + ", view: " + viewList[index].toString());
            WatchUi.switchToView(viewList[currentViewIndex], delegateList[currentViewIndex], WatchUi.SLIDE_IMMEDIATE);
        } else {
            Sys.println("Invalid view index: " + index);
        }
    }
}