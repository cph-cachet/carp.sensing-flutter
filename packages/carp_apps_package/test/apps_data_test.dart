import 'dart:convert';

import 'package:carp_apps_package/apps.dart';
import 'package:test/test.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  setUp(() {
    // Initialization of serialization
    CarpMobileSensing();
    AppsSamplingPackage().onRegister();
  });

  group('Apps Tests', () {
    test(' - installed apps', () {
      Apps d = Apps([
        App(appName: 'MUBS'),
        App(appName: 'mCardia'),
        App(appName: 'Safari'),
      ]);
      print(d);
      print(_encode(d));
    });

    test(' - apps usage', () {
      AppUsage d2 = AppUsage(DateTime.now(), DateTime.now())
        ..usage = {
          'carp_mobile_sensing_test_app': 1405,
          'systemui': 4,
          'MtpApplication': 5,
          'launcher': 1999,
          'settings': 19,
        };
      print(d2);
      print(_encode(d2));
    });

    /// Test template.
    test('...', () {
      // test template
    });
  });
}
