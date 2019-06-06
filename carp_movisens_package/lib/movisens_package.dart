part of movisens;

/// movisens sampling package
class MovisensSamplingPackage implements SamplingPackage {
  static const String MOVISENS = "movisens";


  Probe create(String type) => (type == MOVISENS) ? MovisensProbe() : null;

  List<String> get dataTypes => [MOVISENS];

  @override
  // TODO: implement common
  SamplingSchema get common => null;

  @override
  // TODO: implement light
  SamplingSchema get light => null;

  @override
  // TODO: implement minimum
  SamplingSchema get minimum => null;

  @override
  // TODO: implement normal
  SamplingSchema get normal => null;

  @override
  void onRegister() {


    FromJsonFactory.registerFromJsonFunction(
        "MovisensMeasure", MovisensMeasure.fromJsonFunction);

    print("inside register MovisnesMeasure");
}
}
