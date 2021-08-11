/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

// TODO -- audio recording and noise is conflicting... can't run at the same time...

/// This is the base class for this audio sampling package.
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(AudioSamplingPackage());
/// ```
class AudioSamplingPackage extends SmartphoneSamplingPackage {
  static const String AUDIO = "dk.cachet.carp.audio";
  static const String NOISE = "dk.cachet.carp.noise";

  List<String> get dataTypes => [
        AUDIO,
        NOISE,
      ];

  Probe? create(String type) {
    switch (type) {
      case AUDIO:
        return AudioProbe();
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

  List<Permission> get permissions => [Permission.microphone];

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
