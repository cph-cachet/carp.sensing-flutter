import 'dart:convert';

import 'package:carp_apps_package/apps.dart';
import 'package:test/test.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  setUp(() {
    // Initialization of serialization
    CarpMobileSensing.ensureInitialized();
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
      AppUsageInfo(
        'dk.cachet',
        'carp_mobile_sensing_test_app',
        Duration(seconds: 4),
        DateTime.now(),
        DateTime.now(),
        DateTime.now(),
      );

      AppUsage d2 = AppUsage(DateTime.now(), DateTime.now())
        ..usage = {
          'carp_mobile_sensing_test_app': AppUsageInfo(
            'dk.cachet',
            'carp_mobile_sensing_test_app',
            Duration(seconds: 4),
            DateTime.now(),
            DateTime.now(),
            DateTime.now(),
          ),
          'systemui': AppUsageInfo(
            'com.google',
            'systemui',
            Duration(seconds: 4),
            DateTime.now(),
            DateTime.now(),
            DateTime.now(),
          ),
          'MtpApplication': AppUsageInfo(
            'com.google',
            'MtpApplication',
            Duration(seconds: 44),
            DateTime.now(),
            DateTime.now(),
            DateTime.now(),
          ),
          'launcher': AppUsageInfo(
            'com.google',
            'launcher',
            Duration(seconds: 47),
            DateTime.now(),
            DateTime.now(),
            DateTime.now(),
          ),
          'settings': AppUsageInfo(
            'com.google',
            'settings',
            Duration(seconds: 24),
            DateTime.now(),
            DateTime.now(),
            DateTime.now(),
          ),
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
