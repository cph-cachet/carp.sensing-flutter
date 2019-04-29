/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of audio;

/// This is the base class for this audio sampling package.
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(AudioSamplingPackage());
/// ```
class AudioSamplingPackage implements SamplingPackage {
  static const String AUDIO = "audio";
  static const String NOISE = "noise";

  List<String> get dataTypes => [
        AUDIO,
        NOISE,
      ];

  Probe create(String type) {
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
    FromJsonFactory.registerFromJsonFunction("AudioMeasure", AudioMeasure.fromJsonFunction);
    FromJsonFactory.registerFromJsonFunction("NoiseMeasure", NoiseMeasure.fromJsonFunction);
  }

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) context sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          DataType.AUDIO,
          AudioMeasure(MeasureType(NameSpace.CARP, DataType.AUDIO),
              name: 'Audio Recording', enabled: true, frequency: 60 * 1000, duration: 10 * 1000)),
      MapEntry(
          DataType.NOISE,
          NoiseMeasure(MeasureType(NameSpace.CARP, DataType.NOISE),
              name: 'Ambient Noise', enabled: true, frequency: 37 * 1000, duration: 2 * 1000)),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light audio sampling'
    ..measures[AUDIO].enabled = false;

  SamplingSchema get minimum => light
    ..type = SamplingSchemaType.MINIMUM
    ..name = 'Minimum audio sampling'
    ..measures[NOISE].enabled = false;

  SamplingSchema get normal => common;
}
