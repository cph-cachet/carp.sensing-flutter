part of audio;

/// A listening probe collecting noise data from the microphone.
///
/// See [NoiseMeasure] on how to configure this probe, including setting the
/// frequency, duration and sampling rate of the sampling rate.
///
/// Does not record sound, and instead reports the audio level with a specified frequency,
/// in a given sampling window.
class NoiseProbe extends AbstractProbe {
  StreamController<Datum> controller = StreamController<Datum>();
  Noise _noise;
  bool _isListening = false;
  DateTime _startRecordingTime;
  DateTime _endRecordingTime;
  int _samplingRate;
  StreamSubscription<NoiseEvent> noiseSubscription;
  List<num> _noiseReadings = new List();

  Stream<Datum> get events => controller.stream;

  /// Initialize an [NoiseProbe] taking a [NoiseMeasure] as configuration.
  NoiseProbe(NoiseMeasure measure) : super.init(measure);

  @override
  void initialize() {
    _samplingRate = (measure as NoiseMeasure).samplingRate;
    _noise = new Noise(_samplingRate);
    super.initialize();
  }

  @override
  Future start() async {
    super.start();
    int _frequency = (measure as NoiseMeasure).frequency;
    int _duration = (measure as NoiseMeasure).duration;
    Duration _pause = new Duration(milliseconds: _frequency);
    Duration _samplingDuration = new Duration(milliseconds: _duration);
    // Create a recurrent timer that wait (pause) and then resume the sampling.
    Timer.periodic(_pause, (Timer timer) {
      this.resume();
      // Create a timer that stops the sampling after the specified duration.
      new Timer(_samplingDuration, () {
        this.pause();
      });
    });
  }

  @override
  void stop() {
    _noise = null;
  }

  @override
  void resume() {
    startListening();
  }

  @override
  void pause() async {
    stopListening();
    Datum _datum = await datum;
    if (_datum != null) controller.add(_datum);
  }

  void onData(NoiseEvent event) {
    _noiseReadings.add(event.decibel);
  }

  void startListening() async {
    if (_isListening) return;
    try {
      noiseSubscription = _noise.noiseStream.listen(onData);
    } catch (err) {
      controller.addError(err);
    }
  }

  void stopListening() {
    noiseSubscription.cancel();
    _endRecordingTime = DateTime.now();
    _isListening = false;
  }

  Future<Datum> get datum async {
    Stats stats = Stats.fromData(_noiseReadings);
    num mean = stats.mean;
    num std = stats.standardDeviation;
    num min = stats.min;
    num max = stats.max;
    return new NoiseDatum(meanDecibel: mean, stdDecibel: std, minDecibel: min, maxDecibel: max);
  }
}
