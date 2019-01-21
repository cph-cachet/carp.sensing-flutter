part of runtime;

// -------------------------------------------------------------------
// Controller for creating and adding events to a stream.
// -------------------------------------------------------------------

///// Type of a probe controller's `onStart`, `onRestart`, `onResume`, `onPause` and `onStop` callbacks.
//typedef void ControllerCallback();
//
///// Type of stream controller `onInitialize` callbacks.
//typedef void ControllerInitializeCallback(Measure measure);
//
//abstract class ProbeController<T> {
//  /// The probe that this controller is controlling.
//  //Probe<T> get probe;
//
//  /// The stream of data from the probe this controller is controlling.
//  Stream<T> get stream;
//
//  factory ProbeController(
//      {void onInitialize(Measure measure),
//      void onStart(),
//      void onRestart(),
//      void onPause(),
//      void onResume(),
//      onStop()}) {
//    return null;
//  }
//}
//
//abstract class StreamProbeController<T> {
//  factory StreamProbeController(Stream<T> stream,
//      {void onInitialize(Measure measure),
//      void onStart(),
//      void onRestart(),
//      void onPause(),
//      void onResume(),
//      onStop()}) {
//    return null;
//  }
//}

/// The [BatteryProbe] listens to the hardware battery and collect a [BatteryDatum]
/// every time the battery state changes. For example, battery level or charging mode.
//class BatteryProbe2 extends StreamProbe {
//  Battery battery = new Battery();
//
//  BatteryProbe2() : super();
//
//  Stream<Datum> get stream {
//    StreamController<Datum> controller;
//    StreamSubscription<BatteryState> subscription;
//
//    void onData(state) async {
//      try {
//        int level = await battery.batteryLevel;
//        Datum datum = BatteryDatum.fromBatteryState(measure, level, state);
//        controller.add(datum);
//      } catch (error) {
//        controller.addError(error);
//      }
//    }
//
//    controller = StreamController<Datum>(
//        onListen: () => subscription.resume(),
//        onPause: () => subscription.pause(),
//        onResume: () => subscription.resume(),
//        onCancel: () => subscription.cancel());
//
//    subscription = battery.onBatteryStateChanged
//        .listen(onData, onError: (error) => controller.addError(error), onDone: () => controller.close());
//
//    return controller.stream;
//  }
//}
