/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of audio;

// TODO - PERMISSIONS
// This probe needs PERMISSIONS to use
//    - audio recording / microphone
//    - file access / storage
//
// If these permissions are not set, the app crashes....
// See issue on github.

/// A probe recording audio from the microphone.
///
/// Note that this probe generates a lot of data and should be used with caution.
/// Use a [AudioMeasure] to configure this probe, including setting the
/// [frequency] and [duration] of the sampling.
/// It is important that the recording duration is not longer than the sampling frequency,
/// i.e. this probe does **not** allow for overlapping recordings.
///
/// Also note that this probe records raw sound directly from the microphone and hence
/// records everything - including human speech - in its proximity.
///
/// The Audio probe generates an [AudioDatum] that holds the meta-data for each recording
/// along with the actual recording in an audio file. How to upload this data to a data backend
/// is up to the implementation of the [DataManager], which is used in the [Study].
class AudioProbe extends BufferingPeriodicProbe {
  static const String AUDIO_FILE_PATH = 'audio';

  String studyId;
  String soundFileName;
  String _path;
  bool _isRecording = false;
  DateTime _startRecordingTime, _endRecordingTime;
  String _recording;
  FlutterSound _flutterSound = new FlutterSound();

  void onInitialize(Measure measure) {
    super.onInitialize(measure);
    this.studyId = (measure as AudioMeasure).studyId;
    print('onInitialize() : $measure');
  }

  void onRestart() {
    super.onRestart();
    this.studyId = (measure as AudioMeasure).studyId;
    print('onRestart() : $measure');
  }

  void onStop() {
    _flutterSound = null;
    super.onStop();
  }

  void onSamplingStart() {
    print('onSamplingStart()');
    try {
      _startAudioRecording();
    } catch (err) {
      controller.addError(err);
    }
  }

  void onSamplingEnd() {
    print('onSamplingEnd()');
    _stopAudioRecording().catchError((err) => controller.addError(err));
  }

  void _startAudioRecording() async {
    print('_startAudioRecording(), recording = $_isRecording');
    if (_isRecording) return;
    soundFileName = await filePath;
    print('_startAudioRecording(), soundFileName = $soundFileName');

    _startRecordingTime = DateTime.now();
    _recording = null;
    //await _flutterSound.startRecorder(soundFileName);

    String path = await _flutterSound.startRecorder(null);
    print('startRecorder: $path');

    _isRecording = true;
  }

  Future<String> _stopAudioRecording() {
    print('_stopAudioRecording(), recording = $_isRecording');
    return Future.sync(() async {
      _endRecordingTime = DateTime.now();
      _isRecording = false;
      _recording = await _flutterSound.stopRecorder();
      print('stopRecorder: $_recording');
      return _recording;

      //return _flutterSound.stopRecorder();
    });
  }

//  Future<String> _stopAudioRecording() async {
//    try {
//      String result = await _flutterSound.stopRecorder();
//      _endRecordingTime = DateTime.now();
//      _isRecording = false;
//      return result;
//    } catch (err) {
//      controller.addError(err);
//      return err;
//    }
//  }

  Future<Datum> getDatum() async {
    try {
      //String result = await _stopAudioRecording();
      if (_recording != null) {
        String filename = soundFileName.split("/").last;
        return AudioDatum(
            filename: filename, startRecordingTime: _startRecordingTime, endRecordingTime: _endRecordingTime);
      } else {
        return ErrorDatum(message: "No sound recording available");
      }
    } catch (err) {
      return ErrorDatum(message: "AudioProbe Error: $err");
    }
  }

  /// Returns the local path on the device where sound files can be stored.
  /// Creates the directory, if not existing.
  Future<String> get path async {
    if (_path == null) {
      // get local working directory
      final localApplicationDir = await getApplicationDocumentsDirectory();
      // create a sub-directory for sound files
      final directory =
          await Directory('${localApplicationDir.path}/${FileDataManager.CARP_FILE_PATH}/$studyId/$AUDIO_FILE_PATH')
              .create(recursive: true);

      _path = directory.path;
    }
    return _path;
  }

  /// Returns the full file path to the sound file.
  /// The filename format is "audio-yyyy-mm-dd-hh-mm-ss-ms.m4a".
  Future<String> get filePath async {
    String dir = await path;
    String created =
        DateTime.now().toString().replaceAll(" ", "-").replaceAll(":", "-").replaceAll("_", "-").replaceAll(".", "-");
    return "$dir/audio-$created.m4a";
  }
}
