/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of audio;

/// A probe recording audio from the microphone. It starts recording on [resume()]
/// and stops recording on [pause()], post its [AudioDatum] to the [events] stream.
/// Use a [AudioMeasure] to configure this probe.
///
/// This probe can be used in a [PeriodicTrigger], which allows for periodic
/// sampling of audio by specifying the [frequency] and [duration].
/// It is important that the recording duration is not longer than the sampling
/// frequency, i.e. this probe does **not** allow for overlapping recordings.
///
/// Note that this probe generates a lot of data and should be used with caution.
///
/// Also note that this probe records raw sound directly from the microphone
/// and hence records everything - including human speech - in its proximity.
///
/// The Audio probe generates an [AudioDatum] that holds the meta-data for each
/// recording along with the actual recording in an audio file.
/// Audio is recording in an MP3 format.
/// How to upload this data to a data backend is up to the implementation of the
/// [DataManager], which is used in the [Study].
class AudioProbe extends DatumProbe {
  static const String AUDIO_FILE_PATH = 'audio';

  String studyId;
  String soundFileName;
  String _path;
  bool _isRecording = false;
  DateTime _startRecordingTime, _endRecordingTime;

  void onInitialize(Measure measure) {
    assert(measure is AudioMeasure);
    super.onInitialize(measure);
    this.studyId = (measure as AudioMeasure).studyId;
  }

  Future<void> onResume() async {
    soundFileName = await _startAudioRecording();
    debug('Audio recording resumed - sound file : $soundFileName');
  }

  Future<void> onPause() async {
    // when pausing the audio sampling, stop recording and collect the datum
    if (_isRecording) {
      await _stopAudioRecording();
      getDatum().then((Datum data) {
        if (data != null) controller.add(data);
      }).catchError(
          (error, stacktrace) => controller.addError(error, stacktrace));
    }
  }

  Future<void> onStop() async {
    if (_isRecording) await onPause();
    RecordMp3.instance.stop();
    super.onStop();
  }

  Future<String> _startAudioRecording() async {
    if (_isRecording) {
      warning(
          'Trying to start audio recording, but recording is already running. '
          'Make sure to pause this audio probe before resuming it.');
    } else {
      soundFileName = await filePath;
      _startRecordingTime = DateTime.now();
      _isRecording = true;
      RecordMp3.instance.start(
          soundFileName,
          (error) => controller.addError(
              'Error starting audio recording in $runtimeType -  $error'));
    }
    return soundFileName;
  }

  Future<void> _stopAudioRecording() async {
    _endRecordingTime = DateTime.now();
    _isRecording = false;
    RecordMp3.instance.stop();
  }

  Future<Datum> getDatum() async {
    return (soundFileName != null)
        ? AudioDatum(
            filename: soundFileName.split("/").last,
            startRecordingTime: _startRecordingTime,
            endRecordingTime: _endRecordingTime)
        : null;
  }

  /// Returns the local path on the device where sound files can be stored.
  /// Creates the directory, if not existing.
  Future<String> get path async {
    if (_path == null) {
      // get local working directory
      final localApplicationDir = await getApplicationDocumentsDirectory();
      // create a sub-directory for sound files
      final directory = await Directory(
              '${localApplicationDir.path}/${FileDataManager.CARP_FILE_PATH}/$studyId/$AUDIO_FILE_PATH')
          .create(recursive: true);

      _path = directory.path;
    }
    return _path;
  }

  /// Returns the  filename of the sound file.
  /// The filename format is
  ///    * Android : `audio-yyyy-mm-dd-hh-mm-ss-ms.mp4`
  ///    * iOS : `audio-yyyy-mm-dd-hh-mm-ss-ms.m4a`
  String get filename {
    String created = DateTime.now()
        .toString()
        .replaceAll(" ", "-")
        .replaceAll(":", "-")
        .replaceAll("_", "-")
        .replaceAll(".", "-");
    String type = 'mp3';
    return 'audio-$created.$type';
  }

  /// Returns the full file path to the sound file.
  Future<String> get filePath async {
    String dir = await path;
    return "$dir/$filename";
  }
}
