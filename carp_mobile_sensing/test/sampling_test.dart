import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    CarpMobileSensing.ensureInitialized();
  });

  group('Sampling Configurations', () {
    test('Sampling Packages.', () {
      var schemes = DeviceSamplingPackage().samplingSchemes;
      expect(schemes.configurations.length, 5);

      schemes.addSamplingSchema(SensorSamplingPackage().samplingSchemes);
      expect(schemes.configurations.length, 11);

      print(schemes.types);
    });
  });
}
