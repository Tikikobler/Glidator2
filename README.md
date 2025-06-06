
# Glidator2

A Garmin Connect IQ app for glider pilots to monitor and record flight data in real-time. Built in Monkey C, it leverages Garmin's GPS, barometer, and heart rate sensors to provide essential metrics for gliding. This project extends the original Glidator app by Gaetan Marti (https://github.com/gaetanmarti/glidator).

You can find the app in the Garmin IQ store under Glidator2

## Features
- **Flight Metrics**: Displays altitude (m), vertical speed (m/s) with color-coded feedback (green for climb >0.3 m/s, red for sink <-2.0 m/s, gray for neutral), ground speed (km/h), and heading (radians).
- **Compass View**: Graphical compass with cardinal directions, degree markings, and GPS coordinates (degrees, minutes, seconds).
- **Time & Battery View**: Shows current time and battery percentage with a graphical icon.
- **Activity Recording**: Records flight sessions ("Glide" sport type) using Garmin's ActivityRecording API, with start/stop controls and audio/vibration feedback.
- **Preferences**: Toggle audio beeps for climbing, stored via Application Storage.
- **View Navigation**: Switch between FlyInstrumentView, PositionView, and TimeView using up/down keys.
- **Sensor Integration**: Uses GPS, barometer, and optional heart rate sensors, with fallbacks for unavailable data.

## Usage
- **Launch**: Start the app on your Garmin device to enter FlyInstrumentView.
- **Navigation**: Use up/down keys to cycle views, select key to start/stop recording, menu key for preferences, and back key to exit or access the quit menu.
- **Recording**: Save or discard flight sessions via the quit menu.
- **Preferences**: Enable/disable audio beeps in the preferences menu.

## Technical Details
- **Language**: Monkey C
- **APIs**: Toybox (Application, WatchUi, Position, Sensor, ActivityRecording, Attention, Graphics)
- **Files**:
  - `FlyInstrumentApp.mc`: Main app logic, sensor initialization, and view switching.
  - `FlyInstrumentView.mc`: Main view for flight metrics.
  - `PositionView.mc`: Compass with GPS coordinates.
  - `TimeView.mc`: Time and battery display.
  - `WatchData.mc`: Manages GPS, activity, and sensor data.
  - `WatchDisplay.mc`: Handles rendering of metrics and compass.
  - `Preferences.mc`: Manages user settings.
  - `FlyInstrumentDelegate.mc`: Input handling and menu logic.
- **Notes**:
  - Type checking disabled for certain API calls to avoid Garmin SDK issues.
  - Extensive logging with `Sys.println` for debugging.
  - Optimized for Garmin's device context (Dc) rendering.

## Development

### Requirements
To develop and build Glidator, you need the following tools:
- **Garmin Connect IQ SDK**: Download from [Garmin's Connect IQ SDK page](https://developer.garmin.com/connect-iq/sdk/). This includes the `monkeyc` compiler and `monkeydo` simulator.
- **Java Runtime Environment (JRE)**: Install JAVA 17 as required by the Connect IQ SDK.
- **VS Code with Connect IQ Extension**: Install Visual Studio Code and the [Connect IQ extension](https://marketplace.visualstudio.com/items?itemName=Garmin.connectiq). Configure the SDK path in VS Code settings (>MonkeyC: Verify installation).
- **Optional**: A compatible Garmin device for testing (e.g., Fenix, Forerunner, or Edge series supporting Connect IQ).

### Setup
1. Install the Connect IQ SDK:
   - Download and extract the SDK to a directory (e.g., `~/connectiq-sdk`).
   - Set the `CONNECTIQ_HOME` environment variable to point to this directory.
2. Configure your IDE:
   - For Eclipse, import the project and set up the Connect IQ SDK path in Preferences > Connect IQ.
   - For VS Code, configure the SDK path in the Connect IQ extension settings.
3. Clone the repository: `git clone https://github.com/yourusername/glidator2.git`.

### Building and Running
- **Command Line**: Use `monkeyc` to compile the project:
  ```bash
  monkeyc -f monkey.jungle -o bin/Glidator.prg -d <device_id>
  ```
  Replace `<device_id>` with your target device (e.g., `fenix6`, `forerunner945`). Find supported devices in the SDK's `devices` folder.
- **IDE**:
  - In VS Code, use the Connect IQ extension's build task (Ctrl+Shift+B or Cmd+Shift+B).
  - In VS Code, use the debug button to build and run the app in the simulator.
- **Debugging**: Enable `Sys.println` logs in the code for debugging. View logs in the simulator's console or IDE output. Simulate GPS data via the simulator's "Location" settings.

### Exporting .iq File
- Compile the app with the `-r` flag to generate a signed `.iq` file for distribution:
  ```bash
  monkeyc -f monkey.jungle -o bin/Glidator.iq -r
  ```
- Alternatively, in VS Code, select the >Monkey C: Export Project option, which packages the app with your developer key (that you can generate also with a Monkey C command ).
- The resulting `.iq` file is ready for sideloading or publishing.

### Publishing to Connect IQ Store
1. **Create a Developer Account**: Sign up at [Garmin's Developer Portal](https://developer.garmin.com/connect-iq/).
2. **Prepare App Metadata**:
   - Update the `manifest.xml` with your app's UUID, name, description, and supported devices.
   - Add icons, screenshots, and descriptions for the store listing.
3. **Upload to Connect IQ Store**:
   - Log in to the Garmin Developer Portal.
   - Create a new app listing, upload the `.iq` file, and fill in details (description, changelog, supported languages).
   - Submit for review. Garmin typically reviews apps within a few days.
4. **Sideloading for Testing**: Transfer the `.iq` file to a compatible Garmin device via USB (place in the `GARMIN/Apps` folder) or use the Connect IQ mobile app.


## Credits
Adapted by Tim Kobler from the original Glidator app by Gaetan Marti (https://github.com/gaetanmarti/glidator). Thanks to Gaetan for open-sourcing the foundation, enabling further development for the gliding community.
