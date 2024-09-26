part of 'media.dart';

/// A probe that captures a video or image.
///
/// This probes does not in itself capture the video/image. It merely is a placeholder
/// for being able to add a video/image measure to a protocol.
class VideoProbe extends MeasurementProbe {
  @override
  Future<Measurement?> getMeasurement() async =>
      null; // the measurement is created in the app from the VideoUserTask
}
