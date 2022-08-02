/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of media;

/// A probe recording audio from the microphone. It starts recording on [resume]
/// and stops recording on [pause], and post its [MediaDatum] to the [data] stream.
///
/// This probe can be used in a [PeriodicTrigger], which allows for periodic
/// sampling of audio by specifying the [period] and [duration].
/// It is important that the recording duration is not longer than the sampling
/// frequency, i.e. this probe does **not** allow for overlapping recordings.
///
/// Note that this probe generates a lot of data and should be used with caution.
///
/// Also note that this probe records raw sound directly from the microphone
/// and hence records everything - including human speech - in its proximity.
///
/// The audio probe generates an [MediaDatum] that holds the meta-data for each
/// recording along with the actual recording in an audio file.
/// How to upload this data to a data backend is up to the implementation of the
/// [DataManager], which is used in the [Study].
class AudioProbe extends DatumProbe {
  /// The name of the folder used for storing audio files.
  static const String AUDIO_FILES_PATH = 'audio';

  String? _path;
  bool _isRecording = false;
  DateTime? _startRecordingTime, _endRecordingTime;
  MediaDatum? _datum;
  var recorder = FlutterSoundRecorder();
  String? _soundFileName;

  bool get isRecording => _isRecording;

  @override
  Future<void> onResume() async {
    try {
      await _startAudioRecording();
      debug('Audio recording resumed - sound file : $_soundFileName');
    } catch (error) {
      warning('An error occured trying to start audio recording - $error');
      controller.addError(error);
    }
  }

  @override
  Future<void> onPause() async {
    // when pausing the audio sampling, stop recording and collect the datum
    if (_isRecording) {
      try {
        await _stopAudioRecording();
        Datum? data = await getDatum();
        if (data != null) controller.add(data);
        debug('Audio recording paused - sound file : $_soundFileName');
      } catch (error) {
        warning('An error occured trying to stop audio recording - $error');
        controller.addError(error);
      }
    }
  }

  @override
  Future<void> onStop() async {
    if (_isRecording) await onPause();
    await recorder.stopRecorder();
    super.onStop();
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
            '$runtimeType - permission not granted to use to micophone: $status - trying to request it');
        await Permission.microphone.request();
      }
      _startRecordingTime = DateTime.now().toUtc();
      _datum = MediaDatum(
        mediaType: MediaType.audio,
        filename: 'ignored for now',
        startRecordingTime: _startRecordingTime!,
      );
      _soundFileName = await filePath;
      _datum!.path = _soundFileName;
      _datum!.filename = _soundFileName!.split("/").last;
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
  Future<Datum?> getDatum() async =>
      _datum?..endRecordingTime = _endRecordingTime;

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
  /// The file is named by the unique id (uuid) of the [MediaDatum]
  String get filename => '${_datum!.id}.mp4';

  /// Returns the full file path to the sound file.
  Future<String> get filePath async {
    String dir = await path;
    return "$dir/$filename";
  }
}
