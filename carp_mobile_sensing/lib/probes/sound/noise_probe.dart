part of audio;

// TODO - this probe really needs a rewrite according to the new architecture....

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
  Duration frequency, duration;
  int samplingRate;
  StreamSubscription<NoiseEvent> noiseSubscription;
  List<num> _noiseReadings = new List();

  Stream<Datum> get events => controller.stream;

  NoiseProbe(NoiseMeasure measure) : super(measure) {
    frequency = Duration(milliseconds: measure.frequency);
    duration = (measure.duration != null) ? Duration(milliseconds: measure.duration) : null;
    samplingRate = (measure as NoiseMeasure).samplingRate;
    _noise = new Noise(samplingRate);
  }

  Future onStart() async {
    // Create a recurrent timer that wait (pause) and then resume the sampling.
    Timer.periodic(frequency, (Timer timer) {
      this.resume();
      // Create a timer that stops the sampling after the specified duration.
      new Timer(duration, () {
        this.pause();
      });
    });
  }

  void onRestart() {
    frequency = Duration(milliseconds: (measure as NoiseMeasure).frequency);
    duration = ((measure as NoiseMeasure).duration != null)
        ? Duration(milliseconds: (measure as NoiseMeasure).duration)
        : null;
    samplingRate = (measure as NoiseMeasure).samplingRate;
    _noise = new Noise(samplingRate);
  }

  void onStop() {
    _noise = null;
  }

  void onResume() {
    _startListening();
  }

  void onPause() async {
    _stopListening();
    Datum _datum = await datum;
    if (_datum != null) controller.add(_datum);
  }

  void onData(NoiseEvent event) {
    _noiseReadings.add(event.decibel);
  }

  void _startListening() async {
    if (_isListening) return;
    try {
      noiseSubscription = _noise.noiseStream.listen(onData);
    } catch (err) {
      controller.addError(err);
    }
  }

  void _stopListening() {
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
