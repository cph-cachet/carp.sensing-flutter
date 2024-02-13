part of carp_movesense_package;

enum MovesenseBatteryState { low, high }

/// A Facade to the [mdsflutter](https://pub.dev/packages/mdsflutter) plugin
/// (which has a horrible API).
abstract interface class MdsFacade {
  Future<void> connect();
  Future<void> disconnect();
  Future<MovesenseBatteryState> get BatteryState;
  Stream<MovesenseBatteryState> get BatteryStateEvents;
}
