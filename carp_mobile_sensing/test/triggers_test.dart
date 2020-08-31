import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  setUp(() {
    // This is a hack. Need to create some serialization object in order to intialize searialization.
    Study study = Study("1234", "kkk");
  });

//  /// Test if we can load a raw JSON from a file and convert it into a [Study] object with all its [Task]s and [Measure]s.
//  /// Note that this test, tests if a [Study] object can be create 'from scratch', i.e. without having been created before.
//  test('Raw JSON string -> Study object', () async {
//    String plainStudyJson = File("test/study_1234.json").readAsStringSync();
//
//    Study plainStudy = Study.fromJson(json.decode(plainStudyJson) as Map<String, dynamic>);
//    expect(plainStudy.id, "1234");
//
//    print(_encode(plainStudy));
//  });
//
//  /// Test template.
//  test('...', () {
//    // test template
//  });

  group('Trigger Tests', () {
    test(' - RecurrentScheduledTrigger - success', () {
      RecurrentScheduledTrigger t;

      // collect every day at 13:30
      t = RecurrentScheduledTrigger(type: RecurrentType.daily, time: Time(hour: 09, minute: 30));
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inHours, 24);

      // collect every other day at 13:30
      t = RecurrentScheduledTrigger(type: RecurrentType.daily, separationCount: 1, time: Time(hour: 13, minute: 30));
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 2);

      // collect every wednesday at 12:23
      t = RecurrentScheduledTrigger(type: RecurrentType.weekly, dayOfWeek: DateTime.wednesday, time: Time(hour: 12, minute: 23));
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 7);

      // collect every 2nd monday at 12:23
      t = RecurrentScheduledTrigger(type: RecurrentType.weekly, dayOfWeek: DateTime.thursday, separationCount: 1, time: Time(hour: 09, minute: 23));
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 2 * 7);

      // collect quarterly on the 11th day of the first month in each quarter at 21:30
      t = RecurrentScheduledTrigger(type: RecurrentType.monthly, dayOfMonth: 11, separationCount: 2, time: Time(hour: 21, minute: 30));
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 3 * 30);

      // collect monthly in the second week on a monday at 14:30
      t = RecurrentScheduledTrigger(type: RecurrentType.monthly, weekOfMonth: 2, dayOfWeek: DateTime.tuesday, time: Time(hour: 14, minute: 30));
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.firstOccurrence.weekday, DateTime.tuesday);
      expect(t.period.inDays, 30);

      // collect quarterly as above, but remember this trigger across app shutdown
      t = RecurrentScheduledTrigger(
        triggerId: '1234wef',
        type: RecurrentType.monthly,
        dayOfMonth: 11,
        separationCount: 2,
        time: Time(hour: 21, minute: 30),
        remember: true,
      );
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 3 * 30);
    });

    test(' - RecurrentScheduledTrigger - assert failures', () {
      // all of the following should fail due to assert
      RecurrentScheduledTrigger(type: RecurrentType.daily);
      RecurrentScheduledTrigger(type: RecurrentType.daily, separationCount: -1, time: Time(hour: 13, minute: 30));

      RecurrentScheduledTrigger(type: RecurrentType.weekly, time: Time(hour: 12, minute: 23));

      RecurrentScheduledTrigger(type: RecurrentType.monthly, dayOfWeek: DateTime.monday, time: Time(hour: 14, minute: 30));
      RecurrentScheduledTrigger(type: RecurrentType.monthly, dayOfMonth: 43, separationCount: 2, time: Time(hour: 21, minute: 30));
      RecurrentScheduledTrigger(type: RecurrentType.monthly, weekOfMonth: 12, dayOfWeek: DateTime.monday, time: Time(hour: 14, minute: 30));
    }, skip: true);

    /// Test template.
    test('...', () {
      // test template
    });
  });
}
