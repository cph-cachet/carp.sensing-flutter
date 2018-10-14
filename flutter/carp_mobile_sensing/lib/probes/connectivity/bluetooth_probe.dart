/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of connectivity;

/// The [BluetoothProbe] scans for nearby and visible Bluetooth devices and collect a [BluetoothDatum] for each.
class BluetoothProbe extends ListeningProbe {
  FlutterBlue _flutterBlue;
  StreamSubscription<ScanResult> _subscription;
  Timer _startTimer;
  Duration timeout;
  Duration frequency;

  BluetoothProbe(BluetoothMeasure _measure) : super(_measure);

  @override
  void initialize() {
    super.initialize();
    _flutterBlue = FlutterBlue.instance;
  }

  @override
  Future start() async {
    super.start();

    timeout = new Duration(milliseconds: (measure as BluetoothMeasure).duration);

    int _frequency = (measure as BluetoothMeasure).frequency;
    frequency = new Duration(milliseconds: _frequency);

    this.resume();
  }

  @override
  void stop() {
    if (_subscription != null) _subscription.cancel();
    _subscription = null;
    _startTimer.cancel();
  }

  @override
  void pause() {
    if (_subscription != null) _subscription.cancel();
    _subscription = null;
    _startTimer.cancel();
  }

  @override
  void resume() {
    // create a recurrent timer that resumes sampling every [frequency].
    _startTimer = new Timer.periodic(frequency, (Timer timer) {
      // starting the scanning event loop, will run the [timeout] duration
      _subscription = _flutterBlue
          .scan(scanMode: ScanMode.lowLatency, timeout: timeout)
          .listen(_onData, onError: _onError, onDone: _onDone, cancelOnError: true);
    });
  }

  void _onData(ScanResult result) async {
    BluetoothDatum _bd = new BluetoothDatum();

    _bd.bluetoothDeviceId = result.device.id.id;
    _bd.bluetoothDeviceName = result.device.name;
    _bd.connectable = result.advertisementData.connectable;
    _bd.txPowerLevel = result.advertisementData.txPowerLevel;
    _bd.rssi = result.rssi;

    switch (result.device.type) {
      case BluetoothDeviceType.classic:
        _bd.bluetoothDeviceType = "classic";
        break;
      case BluetoothDeviceType.dual:
        _bd.bluetoothDeviceType = "dual";
        break;
      case BluetoothDeviceType.le:
        _bd.bluetoothDeviceType = "le";
        break;
      default:
        _bd.bluetoothDeviceType = "unknown";
    }

    this.notifyAllListeners(_bd);
  }

  void _onDone() {}

  void _onError(error) {
    ErrorDatum _ed = new ErrorDatum(error.toString());

    this.notifyAllListeners(_ed);
  }
}
