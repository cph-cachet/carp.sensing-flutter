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
class AudioProbe extends Probe {
  /// The name of the folder used for storing audio files.
  static const String AUDIO_FILES_PATH = 'audio';

  final _recorder = FlutterSoundRecorder();
  String? _path;
  bool _isRecording = false;
  Media? _data;
  String? _soundFileName;
  bool get isRecording => _isRecording;

  @override
  Future<bool> onStart() async {
    if (await requestPermissions()) {
      try {
        await _startAudioRecording();
        debug('Audio recording started - sound file : $_soundFileName');
      } catch (error) {
        warning('An error occurred trying to start audio recording - $error');
        addError(error);
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> onStop() async {
    // when stopping the audio sampling, stop recording and collect the measurement
    if (_isRecording) {
      try {
        await _stopAudioRecording();

        var measurement = _data != null
            ? Measurement(
                sensorStartTime:
                    _data!.startRecordingTime!.microsecondsSinceEpoch,
                sensorEndTime: _data!.endRecordingTime?.microsecondsSinceEpoch,
                data: _data!)
            : null;

        if (measurement != null) addMeasurement(measurement);
        debug('Audio recording stopped - sound file : $_soundFileName');
      } catch (error) {
        warning('An error occurred trying to stop audio recording - $error');
        addError(error);
      }
    }
    return true;
  }

  Future<void> _startAudioRecording() async {
    // fast out if recording is already in progress (can only record one at a time)
    if (_isRecording) {
      warning(
          'Trying to start audio recording, but recording is already running. '
          'Make sure to stop this audio probe before resuming it.');
      return;
    }

    _data = Media(
      mediaType: MediaType.audio,
      filename: 'ignored for now',
      startRecordingTime: DateTime.now().toUtc(),
    );
    _soundFileName = await _filePath;
    _data!.path = _soundFileName;
    _data!.filename = _soundFileName!.split("/").last;
    _isRecording = true;

    // start the recording
    _recorder.openRecorder();
    await _recorder.startRecorder(
      toFile: _soundFileName,
      codec: Codec.aacMP4,
    );
  }

  Future<void> _stopAudioRecording() async {
    _data?.endRecordingTime = DateTime.now().toUtc();
    _isRecording = false;

    // stop the recording and close the recorder
    await _recorder.stopRecorder();
    _recorder.closeRecorder();
  }

  /// The local path on the device where sound files are stored.
  /// Creates the sound directory, if not existing.
  Future<String> get _audioPath async {
    if (_path == null) {
      // create a sub-directory for sound files
      final directory = await Directory(
              '${await Settings().getDeploymentBasePath(deployment!.studyDeploymentId)}/${Settings.CARP_DATA_FILE_PATH}/$AUDIO_FILES_PATH')
          .create(recursive: true);

      _path = directory.path;
    }
    return _path!;
  }

  /// The filename of the sound file.
  /// The file is named by the unique id (uuid) of the [Media]
  String get _filename => '${_data!.id}.mp4';

  /// The full file path to the sound file.
  Future<String> get _filePath async => "${await _audioPath}/$_filename";
}
