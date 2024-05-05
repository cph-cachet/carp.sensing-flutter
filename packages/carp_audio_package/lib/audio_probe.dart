/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of 'media.dart';

/// A probe recording audio from the microphone. It starts recording on [start]
/// and stops recording on [stop], and post the recorded [Media] object to the
/// [measurements] stream.
///
/// Note that this probe generates a lot of data and should be used with caution.
///
/// Also note that this probe records raw sound directly from the microphone
/// and hence records everything - including human speech - in its proximity.
///
/// The audio probe generates an [Media] data measurement that holds the
/// meta-data for each recording along with the actual recording in an audio file.
/// How to upload or store this data to a data backend is up to the implementation
/// of the [DataManager], which is used in the [Study].
class AudioProbe extends MeasurementProbe {
  /// The name of the folder used for storing audio files.
  static const String AUDIO_FILES_PATH = 'audio';

  String? _path;
  bool _isRecording = false;
  DateTime? _startRecordingTime, _endRecordingTime;
  Media? _data;
  var recorder = FlutterSoundRecorder();
  String? _soundFileName;

  bool get isRecording => _isRecording;

  @override
  Future<bool> onStart() async {
    try {
      await _startAudioRecording();
      debug('Audio recording resumed - sound file : $_soundFileName');
    } catch (error) {
      warning('An error occurred trying to start audio recording - $error');
      addError(error);
      return false;
    }
    return true;
  }

  @override
  Future<bool> onStop() async {
    // when stopping the audio sampling, stop recording and collect the datum
    if (_isRecording) {
      try {
        await _stopAudioRecording();
        final measurement = await getMeasurement();
        if (measurement != null) addMeasurement(measurement);
        debug('Audio recording paused - sound file : $_soundFileName');
      } catch (error) {
        warning('An error occurred trying to stop audio recording - $error');
        addError(error);
      }
    }
    return true;
  }

  Future<void> _startAudioRecording() async {
    if (_isRecording) {
      warning(
          'Trying to start audio recording, but recording is already running. '
          'Make sure to pause this audio probe before resuming it.');
    } else {
      // check permission to access the microphone
      final status = await Permission.microphone.status;
      if (!status.isGranted) {
        warning(
            '$runtimeType - permission not granted to use to microphone: $status - trying to request it');
        await Permission.microphone.request();
      }
      _startRecordingTime = DateTime.now().toUtc();
      _data = Media(
        mediaType: MediaType.audio,
        filename: 'ignored for now',
        startRecordingTime: _startRecordingTime!,
      );
      _soundFileName = await filePath;
      _data!.path = _soundFileName;
      _data!.filename = _soundFileName!.split("/").last;
      _isRecording = true;

      // start the recording
      recorder.openRecorder();
      await recorder.startRecorder(
        toFile: _soundFileName,
        codec: Codec.aacMP4,
      );
    }
  }

  Future<void> _stopAudioRecording() async {
    _endRecordingTime = DateTime.now().toUtc();
    _isRecording = false;

    // stop the recording
    await recorder.stopRecorder();
    recorder.closeRecorder();
  }

  @override
  Future<Measurement?> getMeasurement() async => Measurement(
      sensorStartTime: _startRecordingTime!.microsecondsSinceEpoch,
      sensorEndTime: _endRecordingTime?.microsecondsSinceEpoch,
      data: _data!..endRecordingTime = _endRecordingTime);

  String get studyDeploymentPath => '/${deployment?.studyDeploymentId}';

  /// Returns the local path on the device where sound files can be stored.
  /// Creates the directory, if not existing.
  Future<String> get path async {
    if (_path == null) {
      // create a sub-directory for sound files
      final directory = await Directory(
              '${await Settings().getDeploymentBasePath(deployment!.studyDeploymentId)}/${Settings.CARP_DATA_FILE_PATH}/$AUDIO_FILES_PATH')
          .create(recursive: true);

      _path = directory.path;
    }
    return _path!;
  }

  /// Returns the  filename of the sound file.
  /// The file is named by the unique id (uuid) of the [Media]
  String get filename => '${_data!.id}.mp4';

  /// Returns the full file path to the sound file.
  Future<String> get filePath async {
    String dir = await path;
    return "$dir/$filename";
  }
}
