using Toybox.WatchUi;
using Toybox.ActivityRecording;

using Toybox.System as Sys;

// --------------------------------------------------------------------------------

class MyMenu2QuitDelegate extends WatchUi.Menu2InputDelegate
{
    function initialize()
    {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item)
    {
        if( item.getId().equals("resume") )
        {
            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
        else if( item.getId().equals("save") )
        {
            $.stopRecording(true);
            System.exit();
        }
        else if( item.getId().equals("ignore") )
        {
            $.stopRecording(false);
            System.exit();
        }
    }
    
    function onBack()
    {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

// --------------------------------------------------------------------------------

class MyMenu2PreferencesDelegate extends WatchUi.Menu2InputDelegate
{
    var beepToggleMenu;

    function initialize(beepTM)
    {
        Menu2InputDelegate.initialize();
        beepToggleMenu = beepTM;
    }

    function onSelect(item)
    {
        if( item.getId().equals("audio") )
        {
            Sys.println("On MyMenu2PreferencesDelegate:audio");
        }
    }
    
    function onBack()
    {
        $.preferences.setBeep(beepToggleMenu.isEnabled());
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

// --------------------------------------------------------------------------------

class BaseInputDelegate extends WatchUi.BehaviorDelegate
{
    var app;

    function initialize(appInstance)
    {
        BehaviorDelegate.initialize();
        app = appInstance;
        Sys.println("BaseInputDelegate initialized, app: " + (app != null ? app.toString() : "null"));
    }

    function onSelect()
    {
        $.startRecording();
        WatchUi.requestUpdate();
        Sys.println("Select pressed, starting recording");
        return true;
    }
    
    function onBack()
    {
        if ($.isRecording())
        {
            var menu = new WatchUi.Menu2({:title=>"Quit ?"});
            menu.addItem(new WatchUi.MenuItem("Resume", null, "resume", null));
            menu.addItem(new WatchUi.MenuItem("Save", null, "save", null));
            menu.addItem(new WatchUi.MenuItem("Ignore", null, "ignore", null));
            var delegate = new MyMenu2QuitDelegate();
            
            WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
            Sys.println("Back pressed, showing quit menu");
        }
        else
        {
            System.exit();
            Sys.println("Back pressed, exiting app");
        }
        return true;
    }
    
    function onMenu()
    {
        var menu = new WatchUi.Menu2({:title=>"Preferences"});
            
        var beep = $.preferences.getBeep();
        var beepTM = new WatchUi.ToggleMenuItem("Beep", "Set audio on/off", "beep", beep, null);
        menu.addItem(beepTM);
          
        var delegate = new MyMenu2PreferencesDelegate(beepTM);
            
        WatchUi.pushView(menu, delegate, WatchUi.SLIDE_IMMEDIATE);
        Sys.println("Menu pressed, showing preferences");
        
        return true;
    }
    
    function onKey(keyEvent)
    {
        var key = keyEvent.getKey();
        Sys.println("onKey called, key: " + key);
        if (app == null) {
            Sys.println("Error: app reference is null");
            return true;
        }
        if (key == WatchUi.KEY_UP) {
            var nextIndex = (app.currentViewIndex - 1 + app.viewList.size()) % app.viewList.size();
            Sys.println("UP pressed, switching to previous view, index: " + nextIndex);
            app.switchToView(nextIndex);
            return true;
        }
        else if (key == WatchUi.KEY_DOWN) {
            var nextIndex = (app.currentViewIndex + 1) % app.viewList.size();
            Sys.println("DOWN pressed, switching to next view, index: " + nextIndex);
            app.switchToView(nextIndex);
            return true;
        }
        Sys.println("Unhandled key: " + key);
        return true;
    }
}