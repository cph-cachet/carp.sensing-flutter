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
          AUDIO,
          AudioMeasure(MeasureType(NameSpace.CARP, AUDIO),
              name: 'Audio Recording', enabled: true, frequency: 5 * 60 * 1000, duration: 10 * 1000)),
      MapEntry(
          NOISE,
          NoiseMeasure(MeasureType(NameSpace.CARP, NOISE),
              name: 'Ambient Noise', enabled: false, frequency: 5 * 60 * 1000, duration: 10 * 1000)),
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

  SamplingSchema get debug => common
    ..type = SamplingSchemaType.DEBUG
    ..name = 'Debugging audio sampling schema'
    ..powerAware = false
    ..measures[AUDIO] = AudioMeasure(MeasureType(NameSpace.CARP, AUDIO),
        name: 'Audio Recording', enabled: true, frequency: 52 * 1000, duration: 5 * 1000)
    ..measures[NOISE] = NoiseMeasure(MeasureType(NameSpace.CARP, NOISE),
        name: 'Ambient Noise', enabled: true, frequency: 21 * 1000, duration: 5 * 1000);
}
