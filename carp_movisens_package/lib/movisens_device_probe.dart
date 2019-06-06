part of movisens;

class MovisensProbe extends StreamProbe {
  UserData userData;
  Movisens _movisens;

  MovisensProbe() : super();

  @override
  void onInitialize(Measure measure) {
    assert(measure is MovisensMeasure);
    MovisensMeasure m = measure as MovisensMeasure;

    /* UserData  userData = UserData(100, 180, Gender.male, 25, SensorLocation.chest,
        '88:6B:0F:CD:E7:F2', 'Sensor 02655');*/

    /// initialize userData with data from Measure

    UserData userData = UserData(m.weight, m.height, m.gender, m.age,
        m.sensorLocation, m.address, m.deviceName);

    print("inside probe");
    _movisens = new Movisens(userData);
  }

  Stream<MovisensDatum> get stream =>
      _movisens.movisensStream.map((event) => MovisensDatum.fromMap(event));
}
