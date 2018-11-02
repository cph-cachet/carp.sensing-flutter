/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of audio;

/// A listening probe collecting data from the accelerometer.
///
/// Note that this probe generates a lot of data and should be used with caution.
/// See [SensorMeasure] on how to configure this probe, including setting the
/// frequency and duration of the sampling rate.
class AudioProbe extends ListeningProbe {
  FlutterSound flutterSound;
  StreamSubscription _recorderSubscription;
  Timer _startTimer;
  Timer _stopTimer;
  bool _isRecording = false;
  String lastPath;
  AudioDatum _datum;

  // Initialize an audio probe taking a [SensorMeasure] as configuration.
  AudioProbe(SensorMeasure _measure) : super(_measure);

  @override
  void initialize() {
    flutterSound = new FlutterSound();
    super.initialize();
    flutterSound.setSubscriptionDuration(0.01);
  }

  @override
  Future start() async {
    super.start();

    print("Audio Probe: start() called");

    // Define the probe sampling frequency
    // (not related to audio file sampling rate)
    int _frequency = (measure as SensorMeasure).frequency;
    Duration _pause = new Duration(milliseconds: _frequency);
    int _duration = (measure as SensorMeasure).duration;
    Duration _samplingDuration = new Duration(milliseconds: _duration);

    // create a recurrent timer that wait (pause) and then resume the sampling.
    _startTimer = new Timer.periodic(_pause, (Timer timer) {
      this.resume();

      // create a timer that stops the sampling after the specified duration.
      _stopTimer = new Timer(_samplingDuration, () {
        this.pause();
      });
    });
  }

  @override
  void stop() {
    if (_datum != null) this.notifyAllListeners(_datum);
    flutterSound = null;
    _datum = null;
  }

  @override
  void resume() {
    startAudioRecording();
  }

  @override
  void pause() async {
    _datum = await datum;
    if (_datum != null) this.notifyAllListeners(_datum);
    _datum = null;
  }

  void startAudioRecording() async {
    if (_isRecording) return;
    try {
      String appDocPath = await generateLocalPath();
      lastPath = appDocPath;
      print("App Doc Path: $appDocPath");

      String path = await flutterSound.startRecorder(appDocPath);
      print('startRecorder: $path');

      _recorderSubscription = flutterSound.onRecorderStateChanged.listen((e) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(e.currentPosition.toInt());
        print(date);
      });

      _isRecording = true;
    } catch (err) {
      print('startRecorder error: $err');
    }
  }

  Future<String> stopAudioRecording() async {
    String result;
    try {
      result = await flutterSound.stopRecorder();
      print('stopRecorder: $result');

      if (_recorderSubscription != null) {
        _recorderSubscription.cancel();
        _recorderSubscription = null;
      }
      _isRecording = false;
    } catch (err) {
      print('stopRecorder error: $err');
    }
    return result;
  }

  Future<AudioDatum> get datum async {
    String result = await stopAudioRecording();
    if (result != null) {
      List<int> bytes = File(lastPath).readAsBytesSync();
      AudioDatum datum = new AudioDatum(filePath: lastPath);
      datum.audioBytes = bytes;
      return datum;
    }
    print("audio_probe: datum() => No audio data");
  }

  Future<String> generateLocalPath() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String timeStamp = DateTime.now().toString().replaceAll(" ", "_");
    return appDocDir.path + "/$timeStamp.m4a";
  }
}
