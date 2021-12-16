/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

// TODO -- audio recording and noise is conflicting... can't run at the same time...

/// A sampling package for capturing audio (incl. noise) and video (incl. images).
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(AudioVideoSamplingPackage());
/// ```
class AudioVideoSamplingPackage extends SmartphoneSamplingPackage {
  static const String AUDIO = "dk.cachet.carp.audio";
  static const String VIDEO = "dk.cachet.carp.video";
  static const String NOISE = "dk.cachet.carp.noise";

  List<String> get dataTypes => [
        AUDIO,
        VIDEO,
        NOISE,
      ];

  Probe? create(String type) {
    switch (type) {
      case AUDIO:
        return AudioProbe();
      case VIDEO:
        return VideoProbe();
      case NOISE:
        return NoiseProbe();
      default:
        return null;
    }
  }

  void onRegister() {
    FromJsonFactory().register(NoiseMeasure(
      type: NOISE,
      frequency: Duration(minutes: 5),
      duration: Duration(seconds: 10),
    ));
  }

  List<Permission> get permissions =>
      [Permission.microphone, Permission.camera];

  SamplingSchema get common => SamplingSchema(
      type: SamplingSchemaType.common,
      name: 'Common (default) context sampling schema',
      powerAware: true)
    ..measures.addEntries([
      MapEntry(
          AUDIO,
          CAMSMeasure(
            type: AUDIO,
            name: 'Audio Recording',
            description:
                "Collects an audio recording from the phone's microphone",
            enabled: true,
          )),
      MapEntry(
          VIDEO,
          CAMSMeasure(
            type: VIDEO,
            name: 'Video or Image Recording',
            description:
                "Collects a video recording or an image from the phone's camera",
            enabled: true,
          )),
      MapEntry(
          NOISE,
          NoiseMeasure(
            type: NOISE,
            name: 'Ambient Noise',
            description:
                "Collects noise in the background from the phone's microphone",
            enabled: false,
            frequency: Duration(minutes: 5),
            duration: Duration(seconds: 10),
          )),
    ]);

  SamplingSchema get light {
    SamplingSchema light = common
      ..type = SamplingSchemaType.light
      ..name = 'Light context sampling';
    (light.measures[AUDIO] as CAMSMeasure).enabled = false;
    return light;
  }

  SamplingSchema get minimum {
    SamplingSchema minimum = light
      ..type = SamplingSchemaType.minimum
      ..name = 'Minimum context sampling';
    (minimum.measures[NOISE] as NoiseMeasure).enabled = false;
    return minimum;
  }

  SamplingSchema get normal => common;

  SamplingSchema get debug => common
    ..type = SamplingSchemaType.debug
    ..name = 'Debugging audio sampling schema'
    ..powerAware = false
    ..measures[AUDIO] = CAMSMeasure(
      type: AUDIO,
      name: 'Audio Recording',
      description: "Collects an audio recording from the phone's microphone",
      enabled: true,
    )
    ..measures[NOISE] = NoiseMeasure(
      type: NOISE,
      name: 'Ambient Noise',
      description:
          "Collects noise in the background from the phone's microphone",
      enabled: true,
      frequency: Duration(minutes: 1),
      duration: Duration(seconds: 10),
    );
}
