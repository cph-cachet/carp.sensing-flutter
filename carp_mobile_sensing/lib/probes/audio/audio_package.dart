part of audio;

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
              name: 'Audio Recording', enabled: true, frequency: 60 * 1000, duration: 2 * 1000)),
      MapEntry(
          DataType.NOISE,
          NoiseMeasure(MeasureType(NameSpace.CARP, DataType.NOISE),
              name: 'Ambient Noise', enabled: true, frequency: 60 * 1000, duration: 2 * 1000)),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light audio sampling'
    ..measures[AUDIO].enabled = false;

  SamplingSchema get minimum => light
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Minimum audio sampling'
    ..measures[NOISE].enabled = false;

  SamplingSchema get normal => common;
}
