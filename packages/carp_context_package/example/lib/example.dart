import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_context_package/context.dart';

/// This is a very simple example of how this sampling package is used as part
/// of defining a study protocol in CARP Mobile Sensing (CAMS).
///
/// NOTE, however, that the code below will not run on it own. A study protocol
/// needs to be deployed and executed in the CAMS framework.
///
/// See the documentation on how to use CAMS:
/// https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(ContextSamplingPackage());

  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Context Sensing Example',
  );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

  // Add an automatic task that starts collecting location, geolocation,
  // activity, and a geofence after 5 minutes.
  // Is using the 'common' measure definitions in the package.
  protocol.addTriggeredTask(
      DelayedTrigger(delay: Duration(minutes: 5)),
      AutomaticTask()
        ..addMeasures(DeviceSamplingPackage().common.getMeasureList(
          types: [
            ContextSamplingPackage.LOCATION,
            ContextSamplingPackage.GEOLOCATION,
            ContextSamplingPackage.ACTIVITY,
            ContextSamplingPackage.GEOFENCE,
          ],
        )),
      phone);

  // Add an automatic task that collects weather and air_quality every 30 miutes.
  // Not that API keys for the weather and air_quality measure must be specified.
  protocol.addTriggeredTask(
      PeriodicTrigger(
        period: Duration(minutes: 30),
        duration: Duration(seconds: 10),
      ),
      AutomaticTask()
        ..addMeasure(WeatherMeasure(
            type: ContextSamplingPackage.WEATHER,
            name: 'Weather',
            description:
                "Collects local weather from the WeatherAPI web service",
            apiKey: 'Open_Weather_API_key_goes_here'))
        ..addMeasure(AirQualityMeasure(
            type: ContextSamplingPackage.AIR_QUALITY,
            name: 'Air Quality',
            description:
                "Collects local air quality from the Air Quality Index (AQI) web service",
            apiKey: 'AQI_API_key_goes_here')),
      phone);
}
