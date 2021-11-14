import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    // This is a hack. Need to create some serialization object in order to intialize searialization.
    tmp = DomainJsonFactory();
  });

  group('Trigger Tests', () {
    test(' - RecurrentScheduledTrigger - success', () {
      RecurrentScheduledTrigger t;

      // collect every day at 13:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        time: Time(hour: 13, minute: 30),
        duration: Duration(seconds: 1),
      );
      //print(toJsonString(t));
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inHours, 24);

      // collect every day at 22:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        time: Time(hour: 22, minute: 30),
        duration: Duration(seconds: 1),
      );
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inHours, 24);

      // collect every other day at 13:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        separationCount: 1,
        time: Time(hour: 13, minute: 30),
        duration: Duration(seconds: 1),
      );
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 2);

      // collect every wednesday at 12:23
      t = RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        dayOfWeek: DateTime.wednesday,
        time: Time(hour: 12, minute: 23),
        duration: Duration(seconds: 1),
      );
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 7);

      // collect every thursday at 14:23
      t = RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        dayOfWeek: DateTime.thursday,
        time: Time(hour: 14, minute: 23),
        duration: Duration(seconds: 1),
      );
      print('${t.firstOccurrence} - ${t.period}');
      expect(t.period.inDays, 7);

      // collect every 2nd thursday at 14:00
      t = RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        dayOfWeek: DateTime.thursday,
        separationCount: 1,
        time: Time(hour: 14, minute: 00),
        duration: Duration(seconds: 1),
      );
      print(
          'weekly, Thursday at 14:00 :: first : ${t.firstOccurrence} - period : ${t.period.inDays}');
      expect(t.period.inDays, 2 * 7);

      // the monthly trigger from iPDM-GO app
      t = RecurrentScheduledTrigger(
        triggerId: 'Blood glucose events trigger',
        type: RecurrentType.monthly,
        dayOfMonth: 1,
        time: Time(hour: 18),
        remember: true,
        duration: Duration(seconds: 1),
      );
      print(
          'monthly, 1st day of month at 18:00 :: first : ${t.firstOccurrence} - period : ${t.period.inDays}');
      expect(t.period.inDays, 1 * 30);

      // collect quarterly on the 11th day of the first month
      // in each quarter at 21:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.monthly,
        dayOfMonth: 11,
        separationCount: 2,
        time: Time(hour: 21, minute: 30),
        duration: Duration(seconds: 1),
      );
      print(
          'quarterly, 11th day of month at 21:30 :: first : ${t.firstOccurrence} - period : ${t.period.inDays}');
      expect(t.period.inDays, 3 * 30);

      // collect monthly in the second week on a monday at 14:30
      t = RecurrentScheduledTrigger(
        type: RecurrentType.monthly,
        weekOfMonth: 2,
        dayOfWeek: DateTime.tuesday,
        time: Time(hour: 14, minute: 30),
        duration: Duration(seconds: 1),
      );
      print(
          'monthly, 2nd week of month on Tuesday at 14:30 :: first : ${t.firstOccurrence} - period : ${t.period.inDays}');
      expect(t.firstOccurrence.weekday, DateTime.tuesday);
      expect(t.period.inDays, 30);

      // collect quarterly as above,
      // but remember this trigger across app shutdown
      t = RecurrentScheduledTrigger(
        triggerId: '1234wef',
        type: RecurrentType.monthly,
        dayOfMonth: 11,
        separationCount: 2,
        time: Time(hour: 21, minute: 30),
        remember: true,
        duration: Duration(seconds: 1),
      );
      print(
          'quarterly, 11th day of month at 21:30 :: first : ${t.firstOccurrence} - period : ${t.period.inDays}');
      expect(t.period.inDays, 3 * 30);
    });

    test(' - RecurrentScheduledTrigger - assert failures', () {
      // all of the following should fail due to assert
      RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        time: Time(hour: 13, minute: 30),
        duration: Duration(seconds: 1),
      );
      RecurrentScheduledTrigger(
        type: RecurrentType.daily,
        separationCount: -1,
        time: Time(hour: 13, minute: 30),
        duration: Duration(seconds: 1),
      );

      RecurrentScheduledTrigger(
        type: RecurrentType.weekly,
        time: Time(hour: 12, minute: 23),
        duration: Duration(seconds: 1),
      );

      RecurrentScheduledTrigger(
        type: RecurrentType.monthly,
        dayOfWeek: DateTime.monday,
        time: Time(hour: 14, minute: 30),
        duration: Duration(seconds: 1),
      );
      RecurrentScheduledTrigger(
        type: RecurrentType.monthly,
        dayOfMonth: 43,
        separationCount: 2,
        time: Time(hour: 21, minute: 30),
        duration: Duration(seconds: 1),
      );
      RecurrentScheduledTrigger(
        type: RecurrentType.monthly,
        weekOfMonth: 12,
        dayOfWeek: DateTime.monday,
        time: Time(hour: 14, minute: 30),
        duration: Duration(seconds: 1),
      );
    }, skip: true);

    test(' - CronScheduledTrigger', () {
      print('cron job at 12:00 every day.');
      CronScheduledTrigger t =
          CronScheduledTrigger.parse(cronExpression: '0 12 * * *');
      print(t);
      print(toJsonString(t));

      t = CronScheduledTrigger(
        minute: 0,
        hour: 12,
        duration: Duration(seconds: 1),
      );
      print(t);

      t = CronScheduledTrigger(
        minute: 10,
        hour: 12,
        day: 5,
        month: DateTime.april,
        weekday: DateTime.tuesday,
        duration: Duration(seconds: 1),
      );
      print(t);
    });

    test(' - RandomRecurrentTrigger', () {
      RandomRecurrentTrigger t = RandomRecurrentTrigger(
        // startTime: Time(hour: 8, minute: 0),
        // endTime: Time(hour: 20, minute: 0),
        startTime: Time(hour: 8, minute: 56),
        endTime: Time(hour: 20, minute: 10),
        // startTime: Time(hour: 8, minute: 0),
        // endTime: Time(hour: 8, minute: 30),
        minNumberOfTriggers: 2,
        maxNumberOfTriggers: 8,
        duration: Duration(seconds: 1),
      );
      print(toJsonString(t));

      RandomRecurrentTriggerExecutor ex = RandomRecurrentTriggerExecutor(t);
      List<Time> times = ex.samplingTimes;
      print(times);
      times.forEach((time) {
        print(time);
        assert(time.isAfter(t.startTime));
        assert(time.isBefore(t.endTime));
      });
    });

    test(' - ConditionalPeriodicTrigger', () {
      ConditionalPeriodicTrigger t = ConditionalPeriodicTrigger(
        period: Duration(minutes: 1),
        resumeCondition: () {
          return ('jakob'.length == 5);
        },
      );
      print(toJsonString(t));

      ConditionalPeriodicTriggerExecutor ex =
          ConditionalPeriodicTriggerExecutor(t);
    });

    /// Test template.
    test('...', () {
      // test template
    });
  });
}
