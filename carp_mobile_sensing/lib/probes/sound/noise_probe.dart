part of audio;

/// A listening probe collecting noise data from the microphone.
///
/// See [NoiseMeasure] on how to configure this probe, including setting the
/// frequency and duration of the sampling rate.
///
/// Does not record sound, and instead reports the audio level with a specified frequency, in a given sampling window.
class NoiseProbe extends ListeningProbe {
  Noise noise;
  bool _isListening = false;
  DateTime _startRecordingTime;
  DateTime _endRecordingTime;
  int _frequency;
  StreamSubscription<NoiseEvent> _noiseSubscription;
  List<num> _noiseValues = new List();

  // Initialize an audio probe taking a [SensorMeasure] as configuration.
  NoiseProbe(AudioMeasure _measure)
      : assert(_measure != null),
        super(_measure);

  @override
  void initialize() {
    // Define the probe sampling frequency
    _frequency = (measure as AudioMeasure).frequency;
    noise = new Noise(_frequency);
    super.initialize();
  }

  @override
  Future start() async {
    super.start();
    Duration _pause = new Duration(milliseconds: _frequency);
    int _duration = (measure as AudioMeasure).duration;
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
    noise = null;
  }

  @override
  void resume() {
    startListening();
  }

  @override
  void pause() async {
    stopListening();
    Datum _datum = await datum;
    if (_datum != null) this.notifyAllListeners(_datum);
  }

  void onData(NoiseEvent event) {
    _noiseValues.add(event.decibel);
  }

  void startListening() async {
    if (_isListening) return;
    try {
      _noiseSubscription = noise.noiseStream.listen(onData);
    } catch (err) {
      print('startListening() error: $err');
    }
  }

  void stopListening() {
    _noiseSubscription.cancel();
    _endRecordingTime = DateTime.now();
    _isListening = false;
  }

  Future<Datum> get datum async {
    Stats stats = Stats.fromData(_noiseValues);
    num mean = stats.mean;
    num std = stats.standardDeviation;
    num min = stats.min;
    num max = stats.max;
    print("NoiseProbe: $mean, $std, $min, $max");
    return new NoiseDatum(
        meanDecibel: mean, stdDecibel: std, minDecibel: min, maxDecibel: max);
  }
}
