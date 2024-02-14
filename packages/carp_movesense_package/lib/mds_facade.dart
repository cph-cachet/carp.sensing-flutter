part of carp_movesense_package;

enum MovesenseBatteryState { low, ok }

/// A Facade for a Movesense device using the [mdsflutter](https://pub.dev/packages/mdsflutter)
/// plugin (which has a horrible API).
class MovesenseDeviceFacade {
  MovesenseBatteryState _batteryState = MovesenseBatteryState.low;
  final StreamController<MovesenseBatteryState> _batteryEventController =
      StreamController.broadcast();
  final StreamController<MovesenseDeviceState> _stateEventController =
      StreamController.broadcast();

  String address;
  String? serial;

  MovesenseDeviceFacade(this.address);

  /// Get the latest know battery state.
  MovesenseBatteryState get batteryState => _batteryState;

  /// The stream of battery states.
  Stream<MovesenseBatteryState> get batteryStateEvents =>
      _batteryEventController.stream;

  Future<void> connect() async {}

  Future<void> disconnect() async {}

  void _setupBatteryMonitoring() {
    Timer.periodic(const Duration(minutes: 1), (_) {
      Mds.get(
        Mds.createRequestUri(serial!, "/System/States/1"),
        "{}",
        ((data, statusCode) {
          final dataContent = json.decode(data);
          num batteryState = dataContent["content"] as num;
          debug("$runtimeType - Battery state: $batteryState");
          _batteryState = batteryState == 1
              ? MovesenseBatteryState.low
              : MovesenseBatteryState.ok;
          _batteryEventController.add(_batteryState);
        }),
        (error, statusCode) => {},
      );
    });
  }

  /// The stream of state events.
  Stream<MovesenseDeviceState> get stateEvents => _stateEventController.stream;
}
