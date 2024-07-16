/*
 * Copyright 2021-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of 'media.dart';

// TODO -- audio recording and noise is conflicting... can't run at the same time...

/// A sampling package for capturing audio (incl. noise) and video (incl. images).
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(MediaSamplingPackage());
/// ```
class MediaSamplingPackage extends SmartphoneSamplingPackage {
  static const String MEDIA = "${NameSpace.CARP}.media";
  static const String VIDEO = "${NameSpace.CARP}.video";
  static const String IMAGE = "${NameSpace.CARP}.image";

  /// Measure type for one-time collection of audio from the phone's microphone.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] connected device for data collection.
  ///  * No sampling configuration needed.
  static const String AUDIO = "${NameSpace.CARP}.audio";

  /// Measure type for periodic collection of noise data from the phone's microphone.
  ///  * Event-based (Periodic) measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use a [PeriodicSamplingConfiguration] for configuration.
  static const String NOISE = "${NameSpace.CARP}.noise";

  @override
  DataTypeSamplingSchemeMap get samplingSchemes =>
      DataTypeSamplingSchemeMap.from([
        DataTypeSamplingScheme(
          CAMSDataTypeMetaData(
            type: AUDIO,
            displayName: "Audio Recording",
            timeType: DataTimeType.TIME_SPAN,
            dataEventType: DataEventType.ONE_TIME,
            permissions: [Permission.microphone],
          ),
        ),
        DataTypeSamplingScheme(
          CAMSDataTypeMetaData(
            type: VIDEO,
            displayName: "Video Recording",
            timeType: DataTimeType.TIME_SPAN,
            dataEventType: DataEventType.ONE_TIME,
            permissions: [Permission.camera],
          ),
        ),
        DataTypeSamplingScheme(
          CAMSDataTypeMetaData(
            type: IMAGE,
            displayName: "Image Capture",
            timeType: DataTimeType.POINT,
            dataEventType: DataEventType.ONE_TIME,
            permissions: [Permission.camera],
          ),
        ),
        DataTypeSamplingScheme(
            CAMSDataTypeMetaData(
              type: NOISE,
              displayName: "Noise Recording",
              timeType: DataTimeType.TIME_SPAN,
              dataEventType: DataEventType.EVENT,
              permissions: [Permission.microphone],
            ),
            PeriodicSamplingConfiguration(
              interval: const Duration(minutes: 5),
              duration: const Duration(seconds: 10),
            )),
      ]);

  @override
  Probe? create(String type) {
    switch (type) {
      case AUDIO:
        return AudioProbe();
      case VIDEO:
        return VideoProbe();
      case IMAGE:
        return VideoProbe();
      case NOISE:
        return NoiseProbe();
      default:
        return null;
    }
  }

  @override
  void onRegister() {
    FromJsonFactory().registerAll([
      Media(filename: 'filename', mediaType: MediaType.audio),
      Noise(meanDecibel: 0, stdDecibel: 0, minDecibel: 0, maxDecibel: 0),
    ]);
  }
}
