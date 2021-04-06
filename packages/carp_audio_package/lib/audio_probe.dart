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
  /// The path to use for storing files collected as a [FileDatum].
  static const String AUDIO_FILES_PATH = 'audio';

  String _path;
  bool _isRecording = false;
  DateTime _startRecordingTime, _endRecordingTime;
  AudioDatum _datum;

  String soundFileName;

  Future onResume() async {
    soundFileName = await _startAudioRecording();
    debug('Audio recording resumed - sound file : $soundFileName');
  }

  Future onPause() async {
    // when pausing the audio sampling, stop recording and collect the datum
    if (_isRecording) {
      await _stopAudioRecording();
      getDatum().then((Datum data) {
        if (data != null) controller.add(data);
      }).catchError(
          (error, stacktrace) => controller.addError(error, stacktrace));
    }
  }

  Future onStop() async {
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
      _datum = AudioDatum();
      soundFileName = await filePath;
      _startRecordingTime = DateTime.now();
      _datum
        ..path = soundFileName
        ..filename = soundFileName.split("/").last
        ..startRecordingTime = _startRecordingTime;
      _isRecording = true;
      RecordMp3.instance.start(
          soundFileName,
          (error) => controller.addError(
              'Error starting audio recording in $runtimeType -  $error'));
    }
    return soundFileName;
  }

  Future _stopAudioRecording() async {
    _endRecordingTime = DateTime.now();
    _isRecording = false;
    RecordMp3.instance.stop();
  }

  Future<Datum> getDatum() async =>
      _datum..endRecordingTime = _endRecordingTime;

  String get studyDeploymentPath => (measure is CAMSMeasure)
      ? '/${(measure as CAMSMeasure).studyDeploymentId}'
      : '';

  /// Returns the local path on the device where sound files can be stored.
  /// Creates the directory, if not existing.
  Future<String> get path async {
    if (_path == null) {
      // get local working directory
      final localApplicationDir = await getApplicationDocumentsDirectory();
      // create a sub-directory for sound files
      final directory = await Directory(
              '${localApplicationDir.path}/${FileDataManager.CARP_FILE_PATH}$studyDeploymentPath/$AUDIO_FILES_PATH')
          .create(recursive: true);

      _path = directory.path;
    }
    return _path;
  }

  /// Returns the  filename of the sound file.
  /// The file is named by the unique id (uuid) of the [AudioDatum]
  String get filename => '${_datum.id}.mp3';

  /// Returns the full file path to the sound file.
  Future<String> get filePath async {
    String dir = await path;
    return "$dir/$filename";
  }
}
