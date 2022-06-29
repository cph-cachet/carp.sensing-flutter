/*
 * Copyright 2021-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of media;

// TODO -- audio recording and noise is conflicting... can't run at the same time...

/// A sampling package for capturing audio (incl. noise) and video (incl. images).
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(AudioVideoSamplingPackage());
/// ```
class MediaSamplingPackage extends SmartphoneSamplingPackage {
  static const String AUDIO = "${NameSpace.CARP}.audio";
  static const String VIDEO = "${NameSpace.CARP}.video";
  static const String IMAGE = "${NameSpace.CARP}.image";
  static const String NOISE = "${NameSpace.CARP}.noise";

  List<String> get dataTypes => [
        AUDIO,
        VIDEO,
        IMAGE,
        NOISE,
      ];

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

  void onRegister() {}

  List<Permission> get permissions =>
      [Permission.microphone, Permission.camera];

  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        NOISE,
        PeriodicSamplingConfiguration(
          interval: Duration(minutes: 5),
          duration: Duration(seconds: 10),
        ));
}
